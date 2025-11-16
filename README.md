# agents-learning-system

Capture and implement learnings with hierarchical storage and closed-loop tracking.

## Quick Start for New Users

**Pre-approve skills for faster workflow**: Add this to your Claude Code settings to automatically use this plugin's skills without prompting:

```json
{
  "approvedSkills": [
    "agents-learning-system:capture-learning",
    "agents-learning-system:apply-learning"
  ]
}
```

**Benefits**: Commands like `/learn` will run immediately without asking permission, making learning capture seamless.

## Features

- **Hierarchical Storage**: Organize learnings at global, profile, project, and agent levels
- **Closed-Loop Tracking**: Ensures learnings are implemented with documentation updates
- **Cross-Profile Patterns**: Identify and extract patterns across multiple contexts
- **Documentation-First**: Updates documentation before creating learning files
- **Robust Search**: Find learnings across all profiles with multiple output formats

## Installation

```bash
/plugin marketplace add pjbeyer/agents-marketplace
/plugin install agents-learning-system@agents-marketplace
```

## Commands

### `/learn`

Capture a learning at the appropriate hierarchy level.

```bash
/learn
```

The command:
1. Detects current hierarchy level
2. Updates documentation first
3. Creates learning file with metadata
4. Verifies correct location

### `/implement-learnings`

Implement captured learnings across profiles.

```bash
/implement-learnings
```

The command:
1. Finds unimplemented learnings
2. Identifies cross-profile patterns
3. Updates documentation
4. Marks learnings complete
5. Extracts patterns to appropriate levels

## Hierarchy Levels

### Global (`~/Projects`)
Cross-profile patterns, MCP tools, global workflows, documentation standards

**Categories**: `mcp-patterns`, `workflows`, `agents`, `documentation`

### Profile (`~/Projects/{profile}`)
Profile-specific tools, patterns, optimizations

**Profiles**: `pjbeyer`, `work`, `play`, `home`
**Categories**: `tools`, `patterns`, `optimizations`, `integrations`

### Project
Project-specific architecture, implementation patterns

**Categories**: `architecture`, `implementation`, `testing`, `deployment`

### Agent
Agent-specific capabilities and improvements

**Categories**: `capabilities`, `integrations`, `improvements`

## Principles

1. **Documentation first** - Update docs before creating learning files
2. **Closed-loop tracking** - Mark learnings complete with verification
3. **Hierarchical organization** - Store at appropriate level
4. **Cross-profile patterns** - Extract common patterns to global docs

### Closed-Loop Marker Standard

**Required format**: `## ✅ CLOSED LOOP - YYYY-MM-DD`

The date format is **mandatory** and must match the regex: `^## ✅ CLOSED LOOP - [0-9]{4}-[0-9]{2}-[0-9]{2}`

**Why date-stamped format?**
- Avoids false positives from template examples like `## ✅ CLOSED LOOP - [Date]`
- Provides clear implementation date for tracking
- Enables automated verification via `find-learnings.sh` script
- Ensures learning files are only marked closed when actually completed

**Correct examples**:
- ✅ `## ✅ CLOSED LOOP - 2025-11-16`
- ✅ `## ✅ CLOSED LOOP - 2025-01-15`

**Incorrect examples** (won't be detected as implemented):
- ❌ `## ✅ CLOSED LOOP - IMPLEMENTATION COMPLETE` (no date)
- ❌ `## ✅ CLOSED LOOP - PENDING DOCUMENTATION` (contradicts closed status)
- ❌ `✅ CLOSED LOOP - 2025-11-16` (missing `##` header prefix)
- ❌ `## ✅ CLOSED LOOP` (no date)

**For learnings that are NOT yet complete**, use:
- `## ⏳ OPEN - PENDING IMPLEMENTATION`
- `## ⏳ OPEN - PENDING DOCUMENTATION`
- `## ⏳ OPEN - TESTING`

**Only add the CLOSED LOOP marker when**:
1. All implementation tasks are complete
2. Documentation has been updated
3. Verification confirms it works
4. The specific date of completion is known

## Scripts

### `find-learnings.sh`

Robust script for finding and analyzing learning files.

**Usage**:
```bash
# Show summary statistics
find-learnings.sh --summary

# List unimplemented learnings
find-learnings.sh --unimplemented

# List all learnings
find-learnings.sh --list

# Count by category
find-learnings.sh --count

# JSON output
find-learnings.sh --json
```

**Features**:
- Searches across all profiles
- Filters by implementation status
- Handles missing directories gracefully
- Multiple output formats (text, JSON)
- Never fails with cryptic errors

## Configuration

Configuration is stored in `config/storage-structure.json`:

```json
{
  "hierarchyLevels": {
    "global": "/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings",
    "profile": "{profilePath}/.workflow/docs/continuous-improvement/learnings",
    ...
  },
  "categories": {
    "global": ["mcp-patterns", "workflows", "agents", "documentation"],
    ...
  },
  "closedLoopMarker": "✅ CLOSED LOOP"
}
```

## Skills

### `capture-learning`
Core skill for capturing learnings with proper metadata and documentation updates.

### `apply-learning`
Core skill for implementing learnings and closing the loop with verification.

## Development

### Structure
```
agents-learning-system/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── skills/
│   ├── capture-learning.md   # Capture skill
│   └── apply-learning.md     # Implementation skill
├── commands/
│   ├── learn.md              # User-facing command
│   └── implement-learnings.md # User-facing command
├── scripts/
│   └── find-learnings.sh     # Search script
├── config/
│   └── storage-structure.json # Configuration
└── docs/
    ├── README.md             # This file
    ├── storage-standard.md   # Storage standard details
    └── examples.md           # Usage examples
```

### Testing Locally

1. Create development marketplace:
```json
{
  "name": "dev",
  "plugins": [{
    "name": "agents-learning-system",
    "source": "./"
  }]
}
```

2. Install for testing:
```bash
/plugin marketplace add /path/to/agents-learning-system
/plugin install agents-learning-system@dev
```

3. Restart Claude Code and test commands

## License

MIT License

## Repository

https://github.com/pjbeyer/agents-learning-system
