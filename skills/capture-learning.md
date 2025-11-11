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
    "global": "/Users/pjbeyer/Projects/docs/continuous-improvement/learnings",
    "profile": "{profilePath}/docs/continuous-improvement/learnings",
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
- MCP patterns → `/Users/pjbeyer/Projects/docs/mcp/tool-registry.md`
- Workflows → `/Users/pjbeyer/Projects/docs/workflows/`
- Agents → `/Users/pjbeyer/Projects/AGENTS.md`
- Documentation → `/Users/pjbeyer/Projects/docs/documentation-registry.md`

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

### Step 6: Create Learning File

**File path format**:
```
{storageBase}/{category}/YYYY-MM-DD-{topic}.md
```

**Use ABSOLUTE paths always**:
```bash
# Good (absolute)
/Users/pjbeyer/Projects/docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-topic.md

# Bad (relative)
docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-topic.md
```

**Template**:
```markdown
## [Date] - [Category]: [Brief Title]

**Context**: [What task were you performing?]
**Document Root**: [Absolute path to hierarchy level]
**Level**: [Global|Profile|Project|Agent]

**Discovery**:
[What you learned - be specific]

**Root Cause** (if error):
[Why did this happen?]

**Impact**:
[How this affects work at this level]

**Recommendation**:
[Specific action to prevent recurrence]

**Status**: Pending
**Priority**: [Critical|High|Medium|Low]

**Related Documentation Updates** (REQUIRED):
- [x] Updated: [exact absolute file path]
- [x] Section: [what was added/changed]
- [x] Validated: Reading updated docs prevents recurrence

**Related**:
- Level: [{level}]
- Files: [related files]
- Tools: [tools involved]
```

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
