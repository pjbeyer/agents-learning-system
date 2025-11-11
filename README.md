# agents-learning-system

A Claude Code plugin for capturing, tracking, and implementing learnings with hierarchical storage and closed-loop tracking across profiles.

## Features

- **Hierarchical Storage**: Organize learnings at global, profile, project, and agent levels
- **Closed-Loop Tracking**: Ensures learnings are implemented with documentation updates
- **Cross-Profile Patterns**: Identify and extract patterns across multiple contexts
- **Documentation-First**: Updates documentation before creating learning files
- **Robust Search**: Find learnings across all profiles with multiple output formats

## Installation

### Option 1: Via agents-marketplace (Recommended)

```bash
# Add the marketplace
/plugin marketplace add pjbeyer/agents-marketplace

# Install the plugin
/plugin install agents-learning-system@agents-marketplace
```

### Option 2: Direct Installation

```bash
# Add marketplace directly to this repo
/plugin marketplace add pjbeyer/agents-learning-system

# Install
/plugin install agents-learning-system@agents-learning-system
```

## Commands

### `/learn`

Capture a new learning at the appropriate hierarchy level.

**Usage**:
```bash
/learn
```

The command will:
1. Detect your current hierarchy level
2. Guide you through the learning capture process
3. Update documentation FIRST (closes the loop immediately)
4. Create the learning file with proper metadata
5. Verify correct file location

### `/implement-learnings`

Review and implement captured learnings across all profiles.

**Usage**:
```bash
/implement-learnings
```

The command will:
1. Find all unimplemented learnings
2. Identify cross-profile patterns
3. Update documentation
4. Mark learnings as implemented
5. Extract patterns to appropriate levels

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

## Key Principles

### 1. Documentation-First Approach
Always update documentation BEFORE creating the learning file. This closes the feedback loop immediately.

### 2. Closed-Loop Tracking
Every learning must be marked with `✅ CLOSED LOOP` when implemented, including:
- What documentation was updated
- How the implementation was verified
- Cross-references to related learnings

### 3. Hierarchical Organization
Store learnings at the appropriate level:
- **Too broad?** Move to higher level
- **Too narrow?** Move to lower level
- **Cross-cutting?** Extract to shared documentation

### 4. Cross-Profile Patterns
Identify patterns appearing in multiple profiles and extract to global documentation.

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
    "global": "/Users/pjbeyer/Projects/docs/continuous-improvement/learnings",
    "profile": "{profilePath}/docs/continuous-improvement/learnings",
    ...
  },
  "categories": {
    "global": ["mcp-patterns", "workflows", "agents", "documentation"],
    ...
  },
  "closedLoopMarker": "✅ CLOSED LOOP"
}
```

## Evidence of Value

Based on actual usage:
- **31 existing learning files** (1 global, 7 pjbeyer, 23 work)
- **97% closed-loop rate** (30/31 implemented)
- **Used across all profiles**
- **Proven pattern for continuous improvement**

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

MIT License - see LICENSE file for details

## Author

Paul Beyer <paul@pjbeyer.com>

## Repository

https://github.com/pjbeyer/agents-learning-system

## Version

1.0.0
