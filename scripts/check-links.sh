#!/usr/bin/env bash
# Validate all links in README.md
#
# - GitHub repos: uses gh API to check metadata, archived status, and staleness
# - Non-GitHub links: fetches content and checks for relevant keywords
#
# Usage: ./scripts/check-links.sh [README.md] [--verbose]

set -euo pipefail

README="${1:-README.md}"
VERBOSE="${2:-}"
TIMEOUT=10
MAX_PARALLEL=10
STALE_MONTHS=12

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

RESULTS_FILE="/tmp/link-check-results.$(date +%s).$$"
rm -f "$RESULTS_FILE"
touch "$RESULTS_FILE"

# Extract markdown links as "link_text|||url" pairs
entries=$(grep -oE '\[([^]]*)\]\(([^)]+)\)' "$README" \
    | sed -E 's/\[([^]]*)\]\(([^)]+)\)/\1|||\2/' \
    | grep '|||https\?://' \
    | sort -t'|' -k4 -u)

total=$(echo "$entries" | wc -l | tr -d ' ')
echo "Validating $total unique links in $README..."
echo ""

# Check if gh CLI is available
if command -v gh &>/dev/null; then
    GH_AVAILABLE=true
else
    GH_AVAILABLE=false
    echo -e "${YELLOW}Note: gh CLI not found. GitHub repo validation will fall back to HTTP checks.${NC}"
    echo ""
fi

check_github_repo() {
    local url="$1"
    local link_text="$2"
    local results_file="$3"

    # Extract owner/repo from GitHub URL
    local repo_path
    repo_path=$(echo "$url" | sed -E 's|https?://github\.com/([^/]+/[^/]+).*|\1|')

    if [ -z "$repo_path" ] || [ "$repo_path" = "$url" ]; then
        # Not a repo URL (could be a gist, blob, etc.) — fall back to HTTP
        check_http "$url" "$link_text" "$results_file"
        return
    fi

    # Fetch repo metadata via gh API
    local api_response
    api_response=$(gh api "repos/$repo_path" 2>/dev/null) || {
        echo -e "  ${RED}FAIL${NC} (gh api error) $url"
        echo "FAIL $url — gh API returned an error" >> "$results_file"
        return
    }

    # Check if repo exists (gh api would have failed above if 404)
    local description archived pushed_at
    description=$(echo "$api_response" | jq -r '.description // ""')
    archived=$(echo "$api_response" | jq -r '.archived')
    pushed_at=$(echo "$api_response" | jq -r '.pushed_at // ""')

    local issues=""

    # Check archived status
    if [ "$archived" = "true" ]; then
        issues="${issues}archived; "
    fi

    # Check staleness (no pushes in STALE_MONTHS)
    if [ -n "$pushed_at" ]; then
        local pushed_epoch now_epoch months_ago
        # macOS date vs GNU date
        if date -j -f "%Y-%m-%dT%H:%M:%SZ" "$pushed_at" "+%s" &>/dev/null 2>&1; then
            pushed_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$pushed_at" "+%s" 2>/dev/null)
        else
            pushed_epoch=$(date -d "$pushed_at" "+%s" 2>/dev/null || echo "0")
        fi
        now_epoch=$(date "+%s")
        local stale_seconds=$((STALE_MONTHS * 30 * 24 * 3600))
        if [ "$pushed_epoch" -gt 0 ] && [ $((now_epoch - pushed_epoch)) -gt $stale_seconds ]; then
            local last_push_date
            if date -j -f "%Y-%m-%dT%H:%M:%SZ" "$pushed_at" "+%Y-%m-%d" &>/dev/null 2>&1; then
                last_push_date=$(date -j -f "%Y-%m-%dT%H:%M:%SZ" "$pushed_at" "+%Y-%m-%d")
            else
                last_push_date=$(date -d "$pushed_at" "+%Y-%m-%d" 2>/dev/null || echo "$pushed_at")
            fi
            issues="${issues}stale (last push: ${last_push_date}); "
        fi
    fi

    # Content validation: check that repo description or name relates to the link text
    local link_lower repo_name_lower desc_lower repo_full_lower
    # Strip parenthetical suffixes like "(sg)" and normalize
    link_lower=$(echo "$link_text" | sed 's/ *([^)]*)//g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 -]//g')
    repo_name_lower=$(echo "$repo_path" | tr '[:upper:]' '[:lower:]' | sed 's|.*/||')
    repo_full_lower=$(echo "$repo_path" | tr '[:upper:]' '[:lower:]')
    desc_lower=$(echo "$description" | tr '[:upper:]' '[:lower:]')
    local search_corpus="$repo_name_lower $repo_full_lower $desc_lower"

    # First: check if the full link text (cleaned) matches the repo name
    local content_match=false
    local link_normalized
    link_normalized=$(echo "$link_lower" | sed 's/ *cli$//' | tr -s ' ' | xargs)
    if [ -n "$link_normalized" ] && echo "$search_corpus" | grep -qi "$link_normalized"; then
        content_match=true
    fi

    # Second: check individual keywords (min 2 chars for short tool names)
    if [ "$content_match" = false ]; then
        for word in $link_lower; do
            [ ${#word} -lt 2 ] && continue
            case "$word" in
                the|and|for|cli|tool|with|from|that|this|also|or|an|in|to|of|is|it|by|on) continue ;;
            esac
            if echo "$search_corpus" | grep -qi "$word"; then
                content_match=true
                break
            fi
        done
    fi

    if [ "$content_match" = false ]; then
        issues="${issues}content mismatch (link text '${link_text}' not found in repo name/description); "
    fi

    # Report result
    if [ -n "$issues" ]; then
        # Archived or content mismatch = warning, not failure
        if echo "$issues" | grep -q "content mismatch"; then
            echo -e "  ${YELLOW}WARN${NC} $url"
            echo -e "         ${YELLOW}${issues% ; }${NC}"
            echo "WARN $url — $issues" >> "$results_file"
        elif echo "$issues" | grep -q "archived"; then
            echo -e "  ${YELLOW}WARN${NC} $url"
            echo -e "         ${YELLOW}${issues% ; }${NC}"
            echo "WARN $url — $issues" >> "$results_file"
        else
            echo -e "  ${YELLOW}WARN${NC} $url"
            echo -e "         ${YELLOW}${issues% ; }${NC}"
            echo "WARN $url — $issues" >> "$results_file"
        fi
    else
        [ -n "$VERBOSE" ] && echo -e "  ${GREEN}OK${NC}  $url"
        echo "PASS" >> "$results_file"
    fi
}

check_http() {
    local url="$1"
    local link_text="$2"
    local results_file="$3"
    local attempt=0
    local status=""
    local body_file="/tmp/link-check-body.$$.$RANDOM"

    while [ $attempt -le 2 ]; do
        status=$(curl -s -w "%{http_code}" \
            --max-time "$TIMEOUT" \
            -L \
            -A "Mozilla/5.0 (compatible; link-checker/1.0)" \
            -H "Accept: text/html,application/xhtml+xml" \
            -o "$body_file" \
            "$url" 2>/dev/null || echo "000")

        if [ "$status" -ge 200 ] && [ "$status" -lt 400 ]; then
            break
        fi
        attempt=$((attempt + 1))
        [ $attempt -le 2 ] && sleep 1
    done

    if [ "$status" -ge 200 ] && [ "$status" -lt 400 ]; then
        # Skip content validation for images/badges
        if echo "$url" | grep -qiE '\.(svg|png|jpg|jpeg|gif|ico|webp)$'; then
            [ -n "$VERBOSE" ] && echo -e "  ${GREEN}OK${NC}  ($status) $url  [image]"
            echo "PASS" >> "$results_file"
            rm -f "$body_file"
            return
        fi

        # Content validation: check that page contains something related to the link text
        local content_match=false
        local link_lower
        link_lower=$(echo "$link_text" | sed 's/ *([^)]*)//g' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9 -]//g')

        if [ -f "$body_file" ]; then
            local body_lower
            body_lower=$(tr '[:upper:]' '[:lower:]' < "$body_file" 2>/dev/null | head -c 50000)

            for word in $link_lower; do
                [ ${#word} -lt 2 ] && continue
                case "$word" in
                    the|and|for|cli|tool|with|from|that|this|also|or|an|in|to|of|is|it|by|on) continue ;;
                esac
                if echo "$body_lower" | grep -qi "$word"; then
                    content_match=true
                    break
                fi
            done
        fi

        if [ "$content_match" = true ]; then
            [ -n "$VERBOSE" ] && echo -e "  ${GREEN}OK${NC}  $url"
            echo "PASS" >> "$results_file"
        elif [ -f "$body_file" ] && [ -s "$body_file" ]; then
            # File exists and has content but no keyword match
            echo -e "  ${YELLOW}WARN${NC} $url"
            echo -e "         ${YELLOW}content may not match '${link_text}'${NC}"
            echo "WARN $url — content may not match '${link_text}'" >> "$results_file"
        else
            # Empty response or no body — just check HTTP status
            [ -n "$VERBOSE" ] && echo -e "  ${GREEN}OK${NC}  ($status) $url"
            echo "PASS" >> "$results_file"
        fi
    elif [ "$status" = "000" ]; then
        echo -e "  ${RED}FAIL${NC} (timeout/dns) $url"
        echo "FAIL $url — timeout or DNS failure" >> "$results_file"
    elif [ "$status" = "403" ] || [ "$status" = "429" ]; then
        echo -e "  ${YELLOW}WARN${NC} ($status) $url  [likely bot protection]"
        echo "WARN $url — HTTP $status (likely bot protection)" >> "$results_file"
    else
        echo -e "  ${RED}FAIL${NC} ($status) $url"
        echo "FAIL $url — HTTP $status" >> "$results_file"
    fi

    rm -f "$body_file"
}

check_entry() {
    local entry="$1"
    local results_file="$2"
    local link_text url

    link_text=$(echo "$entry" | sed 's/|||.*//')
    url=$(echo "$entry" | sed 's/.*|||//')

    # Route to appropriate checker
    if echo "$url" | grep -qE '^https?://github\.com/[^/]+/[^/]+' && [ "$GH_AVAILABLE" = "true" ]; then
        check_github_repo "$url" "$link_text" "$results_file"
    else
        check_http "$url" "$link_text" "$results_file"
    fi
}

export -f check_entry check_github_repo check_http
export TIMEOUT VERBOSE STALE_MONTHS RED GREEN YELLOW CYAN NC RESULTS_FILE GH_AVAILABLE

# Run checks with limited parallelism
# GitHub API has rate limits so use fewer parallel requests for those
echo -e "${CYAN}Checking GitHub repos...${NC}"
echo "$entries" | grep '|||https\?://github\.com/' | xargs -P 5 -I {} bash -c 'check_entry "$@" "$RESULTS_FILE"' _ {} 2>/dev/null || true

echo ""
echo -e "${CYAN}Checking other links...${NC}"
echo "$entries" | grep -v '|||https\?://github\.com/' | xargs -P "$MAX_PARALLEL" -I {} bash -c 'check_entry "$@" "$RESULTS_FILE"' _ {} 2>/dev/null || true

# Tally results
passed=$(grep -c "^PASS" "$RESULTS_FILE" || true)
failed=$(grep -c "^FAIL" "$RESULTS_FILE" || true)
warnings=$(grep -c "^WARN" "$RESULTS_FILE" || true)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  ${GREEN}Passed:${NC}   $passed"
echo -e "  ${YELLOW}Warnings:${NC} $warnings  (archived, stale, or content mismatch)"
echo -e "  ${RED}Failed:${NC}   $failed  (broken links)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ "$warnings" -gt 0 ]; then
    echo ""
    echo "Warnings:"
    grep "^WARN" "$RESULTS_FILE" | sed 's/^WARN /  /'
fi

if [ "$failed" -gt 0 ]; then
    echo ""
    echo "Failures:"
    grep "^FAIL" "$RESULTS_FILE" | sed 's/^FAIL /  /'
fi

rm -f "$RESULTS_FILE"

[ "$failed" -gt 0 ] && exit 1
exit 0
