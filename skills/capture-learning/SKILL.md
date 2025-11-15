---
name: capture-learning
description: Capture a learning with metadata, storage, and documentation updates following hierarchical storage standard
---

# Capture Learning Skill

This skill captures learnings at the appropriate hierarchy level (global, profile, project, or agent) with proper metadata, storage, and documentation updates.

## Critical Principle

**⚠️ CLOSE THE LOOP**: Update documentation FIRST, then create learning file to track the improvement.

## Workflow

### Step 1: Detect Current Hierarchy Level

```bash
# Determine where we are
pwd
```

**Hierarchy levels**:
- `/Users/pjbeyer/Projects` → **Global**
- `/Users/pjbeyer/Projects/pjbeyer/` → **pjbeyer profile**
- `/Users/pjbeyer/Projects/work/` → **work profile**
- `/Users/pjbeyer/Projects/play/` → **play profile**
- `/Users/pjbeyer/Projects/home/` → **home profile**
- Within project directory → **Project level**
- Within agent directory → **Agent level**

### Step 2: Determine Appropriate Level for Learning

**Questions to ask**:
1. Is this applicable across ALL profiles? → **Global**
2. Is this specific to one profile? → **Profile**
3. Is this specific to one project? → **Project**
4. Is this specific to one agent? → **Agent**

**Examples**:
- ✅ Global: "Git commit message standard across profiles"
- ✅ Profile: "Jira epic routing" (work only)
- ✅ Project: "API authentication pattern" (this project only)
- ✅ Agent: "Agent capability enhancement" (this agent only)

### Step 3: Get Storage Path from Configuration

Load the storage structure configuration:

```bash
# Configuration location
cat /Users/pjbeyer/.claude/plugins/cache/learning-system/config/storage-structure.json
```

**Expected structure**:
```json
{
  "hierarchyLevels": {
    "global": "/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings",
    "profile": "{profilePath}/.workflow/docs/continuous-improvement/learnings",
    "project": "{projectPath}/docs/continuous-improvement/learnings",
    "agent": "{agentPath}/docs/learnings"
  },
  "categories": {
    "global": ["mcp-patterns", "workflows", "agents", "documentation"],
    "profile": ["tools", "patterns", "optimizations", "integrations"],
    "project": ["architecture", "implementation", "testing", "deployment"],
    "agent": ["capabilities", "integrations", "improvements"]
  }
}
```

### Step 4: Update Documentation FIRST (Mandatory)

**Identify documentation target based on level and category**:

**Global level**:
- MCP patterns → `/Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md`
- Workflows → `/Users/pjbeyer/Projects/.workflow/docs/workflows/`
- Agents → `/Users/pjbeyer/Projects/AGENTS.md`
- Documentation → `/Users/pjbeyer/Projects/.workflow/docs/documentation-registry.md`

**Profile level**:
- Profile-specific → `{profilePath}/docs/` or `{profilePath}/AGENTS.md`

**Project level**:
- Project-specific → `{projectPath}/README.md` or `{projectPath}/docs/`

**Agent level**:
- Agent-specific → `{agentPath}/AGENTS.md` or `{agentPath}/README.md`

**Update documentation with**:
- What was learned
- How to prevent recurrence
- Examples
- Version history with today's date

**Validate**: "Would reading this prevent recurrence?" → Must be YES

### Step 5: Choose Category

Based on the learning content, choose appropriate category from configuration.

**Examples**:
- MCP tool discovery → `mcp-patterns`
- Workflow improvement → `workflows`
- Agent enhancement → `agents`
- Documentation structure → `documentation`

### Step 6: Gather Metadata (NEW - Phase 1 Enhancement)

**Load priorities from config**:
```bash
cat /Users/pjbeyer/.claude/plugins/cache/agents-learning-system/config/storage-structure.json | grep -A 20 '"priorities"'
```

#### 6a. Ask: Priority

**Question**: "How urgent is this learning?"

**Options** (show with descriptions):
- **P0 - Blocking**: Can't proceed - must fix immediately
  - Examples: Command broken, security vulnerability, data loss risk
- **P1 - Urgent**: Workaround exists - fix within 1 hour
  - Examples: Feature partially broken, performance degraded
- **P2 - High**: Can proceed - fix today
  - Examples: Enhancement blocks future work, quality issue
- **P3 - Medium**: Can proceed - fix this week (DEFAULT)
  - Examples: Nice-to-have improvement, optimization
- **P4 - Low**: Can proceed - fix when convenient
  - Examples: Minor enhancement, cosmetic improvement

**Default**: P3 if user unsure

#### 6b. Ask: Impact

**Question**: "What's the impact of this learning?"

**Options**:
- **high**: Affects multiple areas, significant improvement
- **medium**: Affects specific area, moderate improvement (DEFAULT)
- **low**: Minor improvement, limited scope

**Default**: medium

#### 6c. Ask: Effort

**Question**: "How much effort to implement?"

**Options**:
- **high**: Multiple hours, complex changes
- **medium**: 1-2 hours, moderate complexity (DEFAULT)
- **low**: <1 hour, simple changes

**Default**: medium

#### 6d. Ask: Tags

**Question**: "Add tags for this learning? (comma-separated)"

**Show common tags** based on category from config:
- If category is `mcp-patterns`: Suggest `mcp, tool, api, integration, query`
- If category is `workflows`: Suggest `workflow, process, automation, optimization`
- If category is `agents`: Suggest `agent, skill, command, plugin`
- etc.

**User enters**: comma-separated tags or presses enter for suggestions

**Default**: Use suggested tags if user presses enter

**Example**:
```
Tags for this learning? (suggested: mcp, tool, api)
> skill-invocation, commands

Result: ["skill-invocation", "commands"]
```

#### 6e. Set Initial Status

**Status**: Always start as `open`

**Metadata collected**:
- Priority: P0-P4
- Impact: high/medium/low
- Effort: high/medium/low
- Tags: array of strings
- Status: open
- Date: today's date

### Step 7: Create Learning File

**File path format**:
```
{storageBase}/{category}/YYYY-MM-DD-{topic}.md
```

**Use ABSOLUTE paths always**:
```bash
# Good (absolute)
/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-topic.md

# Bad (relative)
docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-topic.md
```

**Template** (NEW - Phase 1 Enhanced Format):
```markdown
---
# Required metadata
date: YYYY-MM-DD
title: Brief descriptive title
category: mcp-patterns|workflows|agents|documentation|architecture|etc

# Triage metadata (Phase 1)
priority: P0|P1|P2|P3|P4
status: open|in-progress|testing|blocked|closed
tags: [tag1, tag2, tag3]

# Impact assessment
impact: high|medium|low
effort: high|medium|low

# Tracking
opened_date: YYYY-MM-DD
hierarchy_level: global|profile|project|agent
document_root: /absolute/path/to/level

# Optional (for future phases)
batch: false
plugin: plugin-name (if applicable)
github_issue: (Phase 7)
jira_ticket: (Phase 7)
---

# [Title]

**Date**: {date}
**Category**: {category}
**Impact**: {impact} | **Effort**: {effort}
**Priority**: {priority}
**Status**: {status}

## Problem

[Clear description of the issue or opportunity]

## Discovery Context

[What were you doing when you discovered this?]
[What task/workflow revealed this learning?]

## Root Cause

[Why does this problem exist?]
[What's the underlying cause?]

## Proposed Solution

[What's the fix or improvement?]
[How should this be implemented?]

## Implementation Plan

1. Step 1
2. Step 2
3. Step 3

## Testing Plan

- Test case 1
- Test case 2
- Test case 3

## Documentation Updates (REQUIRED)

- [ ] Updated: [exact absolute file path]
- [ ] Section: [what was added/changed]
- [ ] Validated: Reading updated docs prevents recurrence

## Related

- **Level**: {hierarchy_level}
- **Document Root**: {document_root}
- **Files**: [related files]
- **Tools**: [tools involved]
- **Tags**: {tags}

## Status

- [ ] Root cause identified
- [ ] Solution designed
- [ ] Implementation started
- [ ] Testing complete
- [ ] Documentation updated
- [ ] Merged/Published

## Completion Marker

When all checkboxes above are complete, add:

## ✅ CLOSED LOOP - [Date]

**Documentation Updated**:
- [x] File: [exact absolute file path]
- [x] Section: [what was added/changed]
- [x] Validated: Reading updated docs prevents recurrence

(Do not add this section until implementation is complete)
```

**Key changes in Phase 1**:
- Added YAML frontmatter with all metadata
- Priority is now P0-P4 (not Critical/High/Medium/Low)
- Status field replaces "Pending"
- Tags array for categorization
- Impact/Effort fields for prioritization
- Structured sections for consistency
- Checklist for tracking progress

### Step 7: Verify File Location

```bash
# Check file was created in correct location
ls -la {expected-path}

# Should show your new file
# If file is elsewhere, move it to correct location
```

### Step 8: Update Log File (Optional)

If the hierarchy level has aggregated log files, add an entry:

```markdown
### [Date] - [Brief Title]
- **Category**: [category]
- **Impact**: [What improved]
- **Details**: See `learnings/{category}/YYYY-MM-DD-{topic}.md`
- **Documentation**: [Files updated]
```

## Troubleshooting

### Files Created in Wrong Location

**Always use ABSOLUTE paths**:
1. Never use relative paths like `docs/...`
2. Always start with `/Users/pjbeyer/`
3. Verify with `ls` after creation

### Learning is at Wrong Hierarchy Level

**Re-evaluate scope**:
- Too broad? Move to higher level
- Too narrow? Move to lower level
- Check if truly applicable at chosen level

## Success Criteria

- ✅ Documentation updated FIRST
- ✅ Learning file created at correct hierarchy level
- ✅ ABSOLUTE path used
- ✅ Proper metadata included
- ✅ File verified in expected location
- ✅ Prevention guidance added to documentation

## Integration

This skill can be invoked by:
- `/learn` command (user-facing)
- Other skills that capture learnings
- Automated learning capture workflows
