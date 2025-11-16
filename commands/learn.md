---
description: Capture a learning with metadata, hierarchical storage, and documentation updates
---

# Learn - Capture Learning

Capture a learning with metadata, storage, and documentation updates.

## Invocation

Use and follow the `capture-learning` skill exactly as written.

## Usage

From any location in your project hierarchy:

```bash
/learn
```

The skill will:
1. Detect your current hierarchy level (global/profile/project/agent)
2. Guide you through capturing the learning
3. Ensure documentation is updated FIRST
4. Create the learning file with proper metadata
5. Verify the file is in the correct location

## Hierarchy Levels

- **Global** (`~/Projects`) - Cross-profile patterns
- **Profile** (`~/Projects/pjbeyer|work|play|home`) - Profile-specific patterns
- **Project** - Project-specific learnings
- **Agent** - Agent-specific improvements

## Documentation-First Approach

⚠️ **CRITICAL**: This command ensures documentation is updated BEFORE creating the learning file, closing the feedback loop immediately.

## Related

- Skill: `capture-learning` (provides the implementation)
- Command: `/implement-learnings` (implements captured learnings)
- Script: `find-learnings.sh` (discovers learning files)
