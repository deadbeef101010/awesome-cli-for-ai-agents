# Awesome CLIs for AI Coding Agents [![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

> A curated list of CLI tools that AI coding agents can invoke to extend their capabilities.

This list focuses on **tools that agents call**, not the agents themselves. When you use [Claude Code](https://claude.com/product/claude-code), [Codex CLI](https://github.com/openai/codex), [Gemini CLI](https://github.com/google-gemini/gemini-cli), or any terminal-based AI coding agent, these are the CLI tools that make them more powerful.

**Why CLI tools?** Unlike MCP servers, CLI tools require zero setup — no handshake, no server lifecycle, no SDK. Any agent that can run shell commands can use them immediately. They compose with pipes, chain with `&&`, and leverage decades of Unix tooling. See [CLI vs MCP](#cli-vs-mcp) for a deeper comparison.

## Contents

- [Browser Automation](#browser-automation)
- [Code Search & Analysis](#code-search--analysis)
- [Data Processing & Structured Output](#data-processing--structured-output)
- [API & Web Interaction](#api--web-interaction)
- [Git & Version Control](#git--version-control)
- [Package Management](#package-management)
- [Linting, Formatting & Static Analysis](#linting-formatting--static-analysis)
- [Testing](#testing)
- [Security & Scanning](#security--scanning)
- [Infrastructure & Deployment](#infrastructure--deployment)
- [Containers & Orchestration](#containers--orchestration)
- [Database](#database)
- [File Search & Navigation](#file-search--navigation)
- [Image & Media Processing](#image--media-processing)
- [Documentation & Knowledge](#documentation--knowledge)
- [LLM Utilities & Context Management](#llm-utilities--context-management)
- [System Information & Benchmarking](#system-information--benchmarking)
- [Building AI-Friendly CLIs](#building-ai-friendly-clis)
- [CLI vs MCP](#cli-vs-mcp)
- [Related Standards](#related-standards)
- [Contributing](#contributing)

---

## Browser Automation

- [agent-browser](https://github.com/vercel-labs/agent-browser) - Purpose-built browser automation CLI for AI agents. Uses accessibility-tree snapshots with stable `[ref=e1]` references instead of CSS selectors, reducing context usage by 90%. `JSON` `Agent-First`
- [Playwright](https://github.com/microsoft/playwright) - Cross-browser automation with `npx playwright` commands for codegen, screenshots, PDF generation, and testing. `--reporter=json` for structured test output. `JSON`
- [shot-scraper](https://github.com/simonw/shot-scraper) - CLI for taking screenshots and scraping web pages. Run JavaScript in pages, extract text, generate PDFs. Built on Playwright. `JSON`
- [Playwright CLI](https://github.com/microsoft/playwright-cli) - Agent-first browser automation CLI. Token-efficient commands (`goto`, `click`, `fill`, `screenshot`, `snapshot`) that avoid flooding LLM context. YAML snapshots instead of verbose accessibility trees. Tabs, cookies, network mocking, and tracing built in. `Agent-First`
- [Firecrawl CLI](https://github.com/firecrawl/firecrawl) - Turns websites into LLM-ready markdown or structured data. Commands: `scrape`, `crawl`, `map`, `search`. Supports natural language extraction prompts. `JSON` `Agent-First`

## Code Search & Analysis

- [ripgrep (rg)](https://github.com/BurntSushi/ripgrep) - Fastest recursive regex search. Respects `.gitignore`, skips binaries. `rg --json` outputs JSON Lines with file, line, column, and match details. `JSON`
- [ast-grep (sg)](https://github.com/ast-grep/ast-grep) - Structural code search, lint, and rewriting using tree-sitter ASTs. Understands code structure across 50+ languages. `--json` with `pretty`, `stream`, and `compact` styles. `JSON`
- [Semgrep](https://github.com/semgrep/semgrep) - Lightweight static analysis with patterns that look like source code. 2000+ community rules. `--json` output with findings, severity, and suggested fixes. SARIF support. `JSON`
- [Comby](https://github.com/comby-tools/comby) - Structural code search and replace that respects code delimiters (braces, parentheses, strings). Language-agnostic. `-json-lines` for structured match output. `JSON`
- [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) - Incremental parsing system. `tree-sitter parse` outputs S-expression ASTs. `tree-sitter query` for pattern matching across languages.
- [tokei](https://github.com/XAMPPRocky/tokei) - Counts lines of code, comments, and blanks across 150+ languages. `--output json` (also YAML, CBOR). `JSON`
- [difftastic](https://github.com/Wilfred/difftastic) - Structural diff that compares files by AST, not line-by-line. `--display json` for structured diff data. Supports 30+ languages. `JSON`

## Data Processing & Structured Output

- [jq](https://github.com/jqlang/jq) - The canonical JSON processor. Filter, transform, and query JSON data. Turing-complete query language. Essential for agents parsing API responses. `JSON`
- [yq](https://github.com/mikefarah/yq) - jq-like processor for YAML, JSON, XML, CSV, TOML, and HCL. Cross-format conversion with `--output-format`. In-place editing with `-i`. `JSON`
- [jc](https://github.com/kellyjonbrazil/jc) - Converts output of 100+ CLI tools (ps, ls, df, netstat, dig, mount, etc.) to JSON. Essential "bridge" tool that makes the entire traditional CLI ecosystem agent-readable. `jc dig example.com`, `jc ps aux`. `JSON` `Agent-First`
- [dasel](https://github.com/TomWright/dasel) - Select, put, and delete data from JSON, TOML, YAML, XML, INI, HCL, and CSV with a single tool. Unified query syntax. Up to 3x faster than jq. `JSON`
- [csvkit](https://github.com/wireservice/csvkit) - Suite of tools for CSV: `in2csv`, `csvjson`, `csvgrep`, `csvsort`, `csvcut`, `sql2csv`. Automatic format sniffing and type inference. `JSON`
- [Nushell](https://github.com/nushell/nushell) - Modern shell where everything is structured data (tables, records, lists). Native parsers for JSON, YAML, TOML, CSV. `to json` converts any pipeline output. `JSON`
- [Pandoc](https://github.com/jgm/pandoc) - Universal document converter. 40+ formats including Markdown, HTML, LaTeX, DOCX, PDF. JSON AST output with `-t json`. Lua filters for transformation. `JSON`
- [xsv](https://github.com/BurntSushi/xsv) / [qsv](https://github.com/jqnatividad/qsv) - Fast CSV manipulation in Rust. Index, slice, analyze, split, join CSV data. qsv adds Lua/Python evaluation.

## API & Web Interaction

- [HTTPie](https://github.com/httpie/cli) - Human-friendly HTTP client with JSON as the default content type. `--print=b` for body-only output. Sessions, plugins, `--offline` for request preview. `JSON`
- [xh](https://github.com/ducaale/xh) - HTTPie reimplemented in Rust for speed. Single static binary. HTTPie-compatible syntax. `JSON`
- [curlie](https://github.com/rs/curlie) - curl frontend with HTTPie's UX. All curl options exposed with automatic JSON highlighting. `JSON`
- [gh api](https://cli.github.com/manual/gh_api) - Make authenticated GitHub API calls (REST and GraphQL) directly. Returns raw JSON. Part of the `gh` CLI. `JSON`

## Git & Version Control

- [gh (GitHub CLI)](https://github.com/cli/cli) - Exemplary agent-friendly CLI design. `--json <fields>` on most commands, `--jq` for built-in filtering, `--template` for Go templates. Running `--json` with no arguments lists available fields. PRs, issues, actions, releases, API access. `JSON`
- [glab (GitLab CLI)](https://gitlab.com/gitlab-org/cli) - Official GitLab CLI. `--output json` for structured output. Merge requests, CI/CD pipelines, issues. `JSON`
- [git-cliff](https://github.com/orhun/git-cliff) - Changelog generator from conventional commits. Customizable templates. `--output` to file, `--context` for JSON context output. `JSON`
- [delta](https://github.com/dandavison/delta) - Syntax-highlighting pager for `git diff` output. Word-level diff highlighting. Note: agents typically prefer raw `git diff` output.
- [difftastic](https://github.com/Wilfred/difftastic) - AST-aware structural diff. `--display json`. Useful when agents need semantic understanding of code changes. `JSON`

## Package Management

- [uv](https://github.com/astral-sh/uv) - Rust-based Python package/project manager. 10-100x faster than pip. Replaces pip, venv, pip-tools, pyenv. `uv pip install`, `uv run`, `uv sync`. Single binary. `--quiet` for minimal output.
- [npm](https://github.com/npm/cli) - Node.js package manager. `--json` flag on most commands. `npm ls --json` for dependency tree, `npm audit --json` for security. `--yes` for non-interactive prompts. `JSON`
- [pnpm](https://github.com/pnpm/pnpm) - Fast, disk-efficient Node.js package manager. `--reporter=json` or `--json`. Content-addressable store. Monorepo-native with `--filter`. `JSON`
- [Cargo](https://github.com/rust-lang/cargo) - Rust package manager and build system. `--message-format=json` for build output. `cargo check` for fast validation, `cargo clippy` for linting, `cargo audit` for security. `JSON`

## Linting, Formatting & Static Analysis

- [Ruff](https://github.com/astral-sh/ruff) - Python linter and formatter, 10-100x faster than Flake8/Black. Written in Rust. `ruff check --output-format json`. `ruff check --fix` for auto-fix. Replaces Flake8 + Black + isort. Single binary. `JSON`
- [Biome](https://github.com/biomejs/biome) - Unified linter and formatter for JS, TS, JSX, JSON, CSS, GraphQL. `--reporter=json`. 97% Prettier compatibility. 10-25x faster than ESLint+Prettier. Single binary. `JSON`
- [ESLint](https://github.com/eslint/eslint) - Pluggable JS/TS linter. `--format json` for structured output. `--fix` for auto-fixing. SARIF output. `JSON`
- [Prettier](https://github.com/prettier/prettier) - Opinionated multi-language formatter. `--write` for in-place formatting. `--check` returns exit codes for automation. `--list-different` for changed files list.
- [shellcheck](https://github.com/koalaman/shellcheck) - Bash/shell script linter. `--format=json` for structured output. Essential for agents writing shell scripts. `JSON`
- [SQLFluff](https://github.com/sqlfluff/sqlfluff) - SQL linter and auto-formatter. `sqlfluff lint --format json`. `sqlfluff fix` for auto-fixing. Dialect-flexible. `JSON`

## Testing

- [Playwright Test](https://github.com/microsoft/playwright) - E2E testing with `npx playwright test --reporter=json`. Headless by default. Parallel execution, test sharding, `--grep` for filtering. `JSON`
- [Vitest](https://github.com/vitest-dev/vitest) - Vite-native unit testing. `--reporter=json`. `--run` for non-watch mode (essential for agents). Jest-compatible API. `--bail` for fail-fast. `JSON`
- [Cypress CLI](https://github.com/cypress-io/cypress) - E2E testing. `cypress run --reporter json`. `--headless` mode. `--spec` for file targeting. `JSON`
- [hyperfine](https://github.com/sharkdp/hyperfine) - CLI benchmarking. Runs commands multiple times, detects outliers. `--export-json` for structured results. Warmup runs. `JSON`

## Security & Scanning

- [Trivy](https://github.com/aquasecurity/trivy) - All-in-one security scanner for containers, filesystems, repos, IaC, Kubernetes. `--format json`. `--severity HIGH,CRITICAL` filtering. `--exit-code 1` for CI gating. `JSON`
- [Snyk CLI](https://github.com/snyk/cli) - Security scanning for dependencies, containers, IaC, and code. `--json` output with fix recommendations. `--severity-threshold` filtering. `JSON`
- [Gitleaks](https://github.com/gitleaks/gitleaks) - Secret scanner for git repos and files. Detects API keys, passwords, tokens. `--report-format json`. Pre-commit hook support. `JSON`
- [Grype](https://github.com/anchore/grype) - Vulnerability scanner for container images and filesystems. `-o json` for structured output. SBOM-driven matching. `JSON`
- [osv-scanner](https://github.com/google/osv-scanner) - Google's vulnerability scanner using the OSV database. `--format json` for structured output. Supports lockfiles and SBOMs. `JSON`

## Infrastructure & Deployment

- [Terraform](https://github.com/hashicorp/terraform) / [OpenTofu](https://github.com/opentofu/opentofu) - Infrastructure as Code. `terraform plan -json`, `terraform show -json`, `terraform output -json`. `-auto-approve` for non-interactive mode. Forward-compatible JSON schema. `JSON`
- [Pulumi](https://github.com/pulumi/pulumi) - IaC using real programming languages (TypeScript, Python, Go). `--json` output. Pulumi AI for natural language generation. `JSON`
- [AWS CLI](https://github.com/aws/aws-cli) - Manage all AWS services. `--output json` (default). `--query` for JMESPath filtering. `--no-cli-pager` for non-interactive mode. `JSON`
- [flyctl](https://github.com/superfly/flyctl) - Fly.io CLI. `--json` output. `fly deploy` for one-command deploys. Managed databases and autoscaling. `JSON`
- [Tailscale CLI](https://github.com/tailscale/tailscale) - Secure mesh networking via WireGuard. `tailscale status --json` for network/peer info. Useful for agents that need to reach remote test machines, hardware rigs, or CI runners across a private network. `JSON`
- [Sentry CLI](https://github.com/getsentry/sentry-cli) - Manage Sentry releases, upload source maps and debug symbols, send events, and monitor cron jobs. Written in Rust. Integrates error tracking into deploy pipelines.
- [Railway CLI](https://github.com/railwayapp/cli) - Railway platform CLI. `railway up --detach` for non-blocking deploys. Database provisioning. Environment management.
- [Vercel CLI](https://vercel.com/docs/cli) - Deploy and manage Vercel projects. Framework auto-detection. Structured JSON deploy output with preview URLs. `JSON`

## Containers & Orchestration

- [Docker CLI](https://github.com/docker/cli) - Build, run, manage containers. `docker inspect` returns JSON. `--format '{{json .}}'` for structured output on any command. `--quiet` flag. `JSON`
- [Podman](https://github.com/containers/podman) - Daemonless Docker-compatible engine. `--format json`. Rootless by default. `podman generate kube` for Kubernetes YAML. `JSON`
- [kubectl](https://kubernetes.io/docs/reference/kubectl/) - Kubernetes CLI. `-o json`, `-o jsonpath`, `-o yaml`. `--dry-run=client` for validation. Extensive RBAC support. `JSON`
- [Helm](https://github.com/helm/helm) - Kubernetes package manager. `--output json`. `helm template` for dry-run rendering. `--wait` for deployment verification. `JSON`

## Database

- [sqlite-utils](https://github.com/simonw/sqlite-utils) - Manipulate SQLite databases from the CLI. Pipe JSON/CSV directly in. `sqlite-utils query db.sqlite "SELECT *" --json`. Newline-delimited JSON, CSV, or table output. `JSON`
- [usql](https://github.com/xo/usql) - Universal SQL CLI for 40+ databases (PostgreSQL, MySQL, SQLite, Oracle, SQL Server, and more). Single binary. psql-compatible commands.
- [pgcli](https://github.com/dbcli/pgcli) - Postgres CLI with autocompletion and syntax highlighting. Supports JSON output via `\pset format json`. `JSON`
- [mycli](https://github.com/dbcli/mycli) - MySQL CLI with autocompletion and syntax highlighting. Similar to pgcli but for MySQL/MariaDB.
- [dbmate](https://github.com/amacneil/dbmate) - Lightweight database migration tool. Single binary. Supports PostgreSQL, MySQL, SQLite, ClickHouse. `dbmate up`, `dbmate migrate`, `dbmate rollback`.

## File Search & Navigation

- [fd](https://github.com/sharkdp/fd) - Fast alternative to `find`. Regex and glob patterns. Respects `.gitignore`. `--exec` for command execution on results. `--type f/d/l` filtering.
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder with `--filter` for **non-interactive mode** (critical for agents). Piping support. `--select-1` and `--exit-0` for scripting.
- [watchexec](https://github.com/watchexec/watchexec) - Run commands when files change. Ignores `.git` and build artifacts. Extension filtering. Process restart on change.
- [entr](http://eradman.com/entrproject/) - Simple file watcher. `ls *.py | entr pytest`. Lightweight and composable.

## Image & Media Processing

- [ImageMagick](https://github.com/ImageMagick/ImageMagick) - Image processing Swiss army knife. Convert, resize, crop, compose across 200+ formats. `magick identify -verbose` for metadata. Scriptable pipeline.
- [libvips](https://github.com/libvips/libvips) - Fast image processing (3-10x faster than ImageMagick). Low memory usage. JPEG, PNG, WebP, HEIC, AVIF, PDF, SVG.
- [ocrs](https://github.com/robertknight/ocrs) - OCR tool in Rust. Extracts text from screenshots, scanned docs, and photos. No Tesseract dependency. Outputs plain text.
- [timg](https://github.com/hzeller/timg) - Display images and video in the terminal using Sixel, Kitty, or Unicode block characters. Useful for visual verification by agents in supported terminals.

## Documentation & Knowledge

- [tldr-pages](https://github.com/tldr-pages/tldr) - Simplified man pages with practical examples. 5-10 lines instead of 1000+. Community-maintained. Multiple clients (`tldr`, [tealdeer](https://github.com/tealdeer-rs/tealdeer)). Offline support.
- [cheat.sh](https://github.com/chubin/cheat.sh) - Unified cheat sheet via curl. `curl cheat.sh/tar` for instant lookup. No installation needed. Aggregates tldr-pages, StackOverflow, and more.
- [glow](https://github.com/charmbracelet/glow) - Render Markdown in the terminal. Can fetch Markdown from GitHub/GitLab URLs. Useful for agents displaying formatted docs.

## LLM Utilities & Context Management

- [Repomix](https://github.com/yamadashy/repomix) - Pack entire codebases into AI-friendly formats. XML, Markdown, or plain text output. Token counting. `.gitignore`-aware. Remote repo support. `JSON` `Agent-First`
- [code2prompt](https://github.com/mufeedvh/code2prompt) - Generate LLM prompts from codebases with source tree, token counting, and Handlebars templates. Filter by include/exclude patterns. `Agent-First`
- [files-to-prompt](https://github.com/simonw/files-to-prompt) - Concatenate files into a single prompt. Adds file paths and separators. Extension filters, `.gitignore` integration. Markdown and Claude XML output formats. `Agent-First`
- [llm](https://github.com/simonw/llm) - Interact with any LLM (OpenAI, Anthropic, Google, local) from the CLI. Logs everything to SQLite. Plugins, templates, tool use. Agents can use this for sub-LLM calls. `JSON`
- [ttok](https://github.com/simonw/ttok) - Count and truncate text by tokens. `cat file.txt | ttok` for count, `cat file.txt | ttok -t 100` for truncation. Useful for agents managing context windows.

## System Information & Benchmarking

- [duf](https://github.com/muesli/duf) - Disk usage/free utility. `duf --json` for structured output. `JSON`
- [procs](https://github.com/dalance/procs) - Modern `ps` replacement. Searchable process listing with tree view and Docker support.
- [tokei](https://github.com/XAMPPRocky/tokei) - Code statistics across 150+ languages. `--output json`. `JSON`
- [hyperfine](https://github.com/sharkdp/hyperfine) - CLI benchmarking. `--export-json` for results. Statistical analysis with outlier detection. `JSON`
- [doggo](https://github.com/mr-karan/doggo) - Modern DNS client. `--json` output. Supports DoH, DoT, DoQ, DNSCrypt. `JSON`

---

## Building AI-Friendly CLIs

If you're building a CLI tool that AI agents will use, follow these principles:

### Essential Features

- **JSON output** - Provide `--json` or `--format json` flag for structured output
- **Non-interactive mode** - No prompts, no TTY checks, no user input required
- **Comprehensive --help** - Include examples, available flags, and expected inputs/outputs
- **Standard exit codes** - 0 for success, non-zero for errors
- **Consistent error format** - Print errors to stderr, not stdout

### Anti-Patterns to Avoid

- **Colored output to stdout** - Colors break parsing; use `--no-color` flag or detect non-TTY
- **Progress bars and spinners** - Only show when outputting to a TTY
- **Pagination** - Default to no pager when not in TTY (like `--no-pager`)
- **Required interactivity** - Always provide non-interactive alternatives (`--yes`, `--force`)
- **Unstable output formats** - Keep JSON schema backward-compatible

### Gold Standard Example: GitHub CLI

The `gh` CLI demonstrates best practices:
- `gh pr list --json number,title,author` - Select only needed fields
- `gh pr list --json number --jq '.[].number'` - Built-in jq filtering
- `gh issue create --title "Bug" --body "Description"` - Fully non-interactive
- Running any command with `--json` but no fields lists available fields

See [gh manual](https://cli.github.com/manual/) for inspiration.

---

## CLI vs MCP

CLI tools and MCP servers are complementary, not competing. Here's when to use each:

| Factor | CLI | MCP |
|--------|-----|-----|
| **Setup cost** | Zero — tools already exist | Requires server infrastructure |
| **Token efficiency** | Generally better (targeted queries) | Can flood context with full schema dumps |
| **State management** | Stateless by default | Strong stateful sessions |
| **Security/permissions** | Coarse (full user access) | Granular (OAuth, scoped access) |
| **Ecosystem maturity** | Decades of battle-tested tools | Rapidly growing but younger |
| **Best for** | Speed, cost control, simple tasks | Multi-tool orchestration, enterprise |

**Rule of thumb:** Start with CLI tools. Add MCP when you need persistent state, granular permissions, or multi-tool orchestration.

---

## Related Standards

- **JSON Lines** (`.jsonl`) - Newline-delimited JSON for streaming output. Used by ripgrep, jc, and many agent-first tools.
- **SARIF** - Static Analysis Results Interchange Format. Standard for security and linting tools (Semgrep, ESLint, Trivy).
- **Exit Codes** - Standard Unix convention: 0 = success, 1-255 = various error conditions.
- **XDG Base Directory** - Standard for config file locations (`~/.config/`, `~/.local/share/`).
- **POSIX Utility Conventions** - Guidelines for option syntax (`-a`, `--all`), argument parsing, and help text format.

---

## Contributing

Contributions welcome! Please read the [contribution guidelines](CONTRIBUTING.md) first.

### What belongs here

- CLI tools that AI coding agents can invoke via shell commands
- Tools that provide structured output (JSON, YAML, etc.) or have non-interactive modes
- Tools with comprehensive `--help` documentation and good error messages
- Tools that follow standard CLI conventions (exit codes, stdin/stdout, composability)

### What doesn't belong here

- The AI coding agents themselves (Claude Code, Aider, Codex CLI, Gemini CLI, etc.)
- GUI-only tools with no CLI interface
- MCP servers (unless they also have a standalone CLI mode)
- Libraries/SDKs that aren't invocable as CLI commands
- Tools that require significant setup or configuration before use

### Agent-Friendly CLI Checklist

A tool is a good fit for this list if it meets **3 or more** of these criteria:

- [ ] Provides structured output (`--json`, `--yaml`, or similar)
- [ ] Has non-interactive mode (no prompts, no TTY required)
- [ ] Includes comprehensive `--help` with examples
- [ ] Uses exit codes correctly (0 = success, non-zero = failure)
- [ ] Avoids formatting in structured output (no colors, progress bars, spinners in JSON mode)
- [ ] Provides clear error messages to stderr
- [ ] Composable (works in pipes, respects stdin/stdout conventions)
- [ ] Well-documented with examples and edge cases

---

## License

[![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png)](https://creativecommons.org/publicdomain/zero/1.0/)

To the extent possible under law, the contributors have waived all copyright and related rights to this work.
