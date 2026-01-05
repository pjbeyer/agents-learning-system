# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-05
**Commit:** 64a4fa2
**Branch:** main

## OVERVIEW

Claude Code plugin for hierarchical learning management with closed-loop tracking across global/profile/project/agent levels.

## STRUCTURE

```
phil-ai-learning/
├── .claude-plugin/plugin.json  # Plugin manifest (v1.1.2)
├── commands/                   # User-facing slash commands
│   ├── learn.md               # /learn → capture-learning skill
│   └── implement-learnings.md # /implement-learnings → apply-learning skill
├── skills/                     # Skill implementations
│   ├── capture-learning/      # Capture workflow with metadata
│   └── apply-learning/        # Implementation + cross-profile extraction
├── scripts/
│   └── find-learnings.sh      # Cross-profile learning discovery (Bash 4.0+)
├── config/
│   └── storage-structure.json # Hierarchy paths, categories, priorities
└── docs/
    └── examples.md            # Usage examples
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add new command | `commands/` | Markdown file invoking a skill |
| Add/modify skill logic | `skills/{name}/SKILL.md` | Full workflow in markdown |
| Change hierarchy paths | `config/storage-structure.json` | Hardcoded to ~/Projects |
| Modify search logic | `scripts/find-learnings.sh` | Bash 4.0+ required |
| Plugin metadata | `.claude-plugin/plugin.json` | Version, author, keywords |

## CONVENTIONS

### Closed-Loop Marker (MANDATORY)

Format: `## ✅ CLOSED LOOP - YYYY-MM-DD`

Regex: `^## ✅ CLOSED LOOP - [0-9]{4}-[0-9]{2}-[0-9]{2}`

- Date is **required** (not placeholder text)
- `##` header prefix required
- Used by `find-learnings.sh` for automated status detection

### File Naming

Learning files: `YYYY-MM-DD-descriptive-topic.md`

### Path References

- **Skills**: Use `${CLAUDE_PLUGIN_ROOT}` (expanded at runtime)
- **Learning files**: Always absolute paths (`/Users/pjbeyer/...`)

### Hierarchy Levels

| Level | Storage Path | Categories |
|-------|--------------|------------|
| Global | `~/Projects/.workflow/docs/continuous-improvement/learnings/` | mcp-patterns, workflows, agents, documentation |
| Profile | `~/Projects/{profile}/.workflow/docs/continuous-improvement/learnings/` | tools, patterns, optimizations, integrations |
| Project | `{project}/docs/continuous-improvement/learnings/` | architecture, implementation, testing, deployment |
| Agent | `{agent}/docs/learnings/` | capabilities, integrations, improvements |

### Priorities

P0 (Blocking) → P1 (Urgent) → P2 (High) → P3 (Medium, default) → P4 (Low)

## ANTI-PATTERNS

| Forbidden | Why | Correct |
|-----------|-----|---------|
| Relative paths in learnings | Breaks cross-profile search | Use absolute: `/Users/pjbeyer/...` |
| `## ✅ CLOSED LOOP - [Date]` | Not detected as implemented | Use actual date: `2025-11-16` |
| `## ✅ CLOSED LOOP - PENDING X` | Contradictory status | Use `## ⏳ OPEN - PENDING X` |
| Create learning before docs | Violates documentation-first | Update docs FIRST, then create learning |
| Hardcoded paths in skills | Breaks portability | Use `${CLAUDE_PLUGIN_ROOT}` |
| Run on Bash <4.0 | Associative arrays fail | Use `/opt/homebrew/bin/bash` |

## COMMANDS

```bash
# Find unimplemented learnings
${CLAUDE_PLUGIN_ROOT}/scripts/find-learnings.sh --unimplemented

# Summary statistics
${CLAUDE_PLUGIN_ROOT}/scripts/find-learnings.sh --summary

# JSON output
${CLAUDE_PLUGIN_ROOT}/scripts/find-learnings.sh --json
```

## NOTES

- **External dependency**: Searches `~/Projects/{profile}/.workflow/` directories outside this repo
- **Profiles**: `pjbeyer`, `work`, `play`, `home` (hardcoded in config)
- **No CI/CD**: Manual install via `/plugin marketplace add`
- **Bash 4.0+**: macOS default bash is 3.2; script uses `/opt/homebrew/bin/bash`
