# Contributing

Thank you for taking the time to contribute! This list is meant to be a community resource for anyone working with AI coding agents.

## Guidelines

### Adding a Tool

Please ensure your tool meets these criteria:

1. **It's a CLI tool** — invocable as a shell command, not just a library or SDK
2. **It's useful for AI coding agents** — agents like Claude Code, Codex CLI, or Gemini CLI would benefit from calling it
3. **It's actively maintained** — has seen commits in the last 12 months
4. **It has good documentation** — `--help` output, README, or docs site

### Formatting

Use this format for entries:

```markdown
- [Tool Name](https://github.com/owner/repo) - One-sentence description that starts with a capital letter and ends with a period. Notable flags or features. `JSON` `Agent-First`
```

Tags (add when applicable):
- `JSON` — Has native JSON output mode
- `Agent-First` — Specifically designed for AI agent use
- `Agent-Essential` — Not designed for agents, but critical for agent workflows

### Pull Request Process

1. Fork the repo and create your branch from `main`
2. Add your tool in the appropriate category, maintaining alphabetical order within each category
3. If your tool doesn't fit an existing category, propose a new one
4. Ensure your PR description explains why the tool is useful for AI coding agents
5. One tool per PR is preferred, but related tools can be grouped

### Suggesting New Categories

Open an issue first to discuss the category. Include:
- Category name
- Why it deserves a separate section
- At least 3 tools that would go in it

### Quality Standards

- Descriptions should be factual, not promotional
- Links should point to the primary source (usually GitHub repo)
- Focus on features relevant to agent use (JSON output, non-interactive mode, etc.)
- No affiliate links, tracking parameters, or referral codes

## Code of Conduct

Be kind, constructive, and respectful. This project follows the [Contributor Covenant](https://www.contributor-covenant.org/).
