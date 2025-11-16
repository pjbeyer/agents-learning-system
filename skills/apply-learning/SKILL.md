---
name: apply-learning
description: Implement a captured learning with closed-loop verification and cross-profile pattern extraction
---

# Apply Learning Skill

This skill systematically reviews and implements captured learnings across all hierarchy levels with proper closed-loop tracking.

## Critical Principle

**⚠️ CLOSE THE LOOP**: Mark learnings as implemented with documentation references and verification.

## Workflow

### Step 1: Find Learning Files

Use the `find-learnings.sh` script to discover all learning files:

```bash
# Find all unimplemented learnings (most common)
/Users/pjbeyer/.claude/plugins/cache/learning-system/scripts/find-learnings.sh --unimplemented

# Show summary statistics
/Users/pjbeyer/.claude/plugins/cache/learning-system/scripts/find-learnings.sh --summary

# List all learning files
/Users/pjbeyer/.claude/plugins/cache/learning-system/scripts/find-learnings.sh --list

# Count by category
/Users/pjbeyer/.claude/plugins/cache/learning-system/scripts/find-learnings.sh --count

# Get JSON output
/Users/pjbeyer/.claude/plugins/cache/learning-system/scripts/find-learnings.sh --json
```

**Script features**:
- ✅ Searches across all profiles (global, pjbeyer, work, play, home)
- ✅ Filters by implementation status (looks for "✅ CLOSED LOOP" marker)
- ✅ Handles missing directories gracefully
- ✅ Provides multiple output formats
- ✅ Never fails with cryptic errors

### Step 2: Identify Cross-Profile Patterns

**Look for patterns appearing in multiple hierarchy levels or profiles**:
- Same issue at global AND profile level → Extract to appropriate level
- Similar pattern in multiple projects → Create shared documentation
- Agent pattern applicable broadly → Promote to project or profile level

**Prioritize by**:
1. **Critical**: Blocking issues, security concerns
2. **High**: Affects multiple profiles or projects
3. **Medium**: Single profile/project but high impact
4. **Low**: Nice-to-have improvements

### Step 3: Identify Documentation Targets

**Based on hierarchy level**:

**Global level** (`/Users/pjbeyer/Projects/.workflow/docs/`):
- MCP patterns → `docs/mcp/tool-registry.md`
- Profile structure → `AGENTS.md`
- Git/system config → `docs/setup/`
- Optimization patterns → `docs/optimization/`

**Profile level** (`{profilePath}/docs/`):
- Profile-specific tools → Profile AGENTS.md or docs/
- Profile workflows → Profile-specific documentation

**Project level** (`{projectPath}/docs/`):
- Project architecture → Project README.md or docs/
- Implementation patterns → Project-specific documentation

**Agent level** (`{agentPath}/docs/`):
- Agent capabilities → Agent AGENTS.md or README.md

### Step 4: Implement Documentation Updates

**For each unimplemented learning**:

1. **Read the learning file** (use Read tool with absolute path)
2. **Identify target documentation** (based on level and category)
3. **Update documentation** with:
   - What was learned
   - How to prevent recurrence
   - Examples from real usage
   - Cross-references if pattern appears in multiple places
4. **Validate**: "Would reading this prevent recurrence?" → Must be YES
5. **Mark as implemented** in learning file (next step)

### Step 5: Mark Learning as Implemented

**Add to the learning file**:

```markdown
## ✅ CLOSED LOOP - [Date]

**Documentation Updated**:
- [x] File: [exact absolute file path]
- [x] Section: [what was added/changed]
- [x] Validated: Reading updated docs prevents recurrence

**Implementation Details**:
- Date: [YYYY-MM-DD]
- Changes: [summary of what was implemented]
- Verification: [how you verified it works]

**Status**: Implemented on [date]
```

**Use Edit tool to add this section** (preserves existing content)

### Step 6: Cross-Profile Pattern Extraction

**If same pattern found in multiple profiles**:

1. **Compare implementations** across profiles
2. **Extract common pattern** to higher-level documentation (profile → global)
3. **Document variations** (if different approaches in different contexts)
4. **Update all related learnings** to reference the extracted pattern
5. **Mark all related learnings as implemented** with cross-reference

**Example**:
```
Pattern found in:
- work/learnings/mcp-patterns/2025-10-25-notion-search.md
- pjbeyer/learnings/mcp-patterns/2025-10-26-notion-database.md

Common: Notion MCP usage patterns

Action:
1. Extract common pattern to /Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md
2. Note profile-specific patterns stay in profile docs
3. Mark both learning files as implemented with cross-reference
```

### Step 7: Verify Implementation

**Test the implementation**:

1. **Documentation validation**:
   - Is documentation clear and actionable?
   - Would someone reading it avoid the same issue?
   - Are examples realistic and helpful?

2. **Cross-level validation** (if applicable):
   - Does pattern work at appropriate hierarchy level?
   - Are cross-references correct?
   - Is information at the right level (no duplication)?

3. **Multi-profile validation** (for cross-profile patterns):
   - Does pattern work in all affected profiles?
   - Are profile-specific variations documented?
   - Is global pattern truly global?

### Step 8: Update Log Files (Optional)

If the hierarchy level maintains aggregated log files, update them:

```markdown
### [Date] - [Brief Title] - IMPLEMENTED
- **Category**: [category]
- **Impact**: [What improved]
- **Implementation**: [YYYY-MM-DD]
- **Documentation**: [Files updated]
```

## Multi-Profile Search Locations

The skill searches across all profiles:

1. **Global**: `/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings/`
2. **pjbeyer**: `/Users/pjbeyer/Projects/pjbeyer/.workflow/docs/continuous-improvement/learnings/`
3. **work**: `/Users/pjbeyer/Projects/work/.workflow/docs/continuous-improvement/learnings/`
4. **play**: `/Users/pjbeyer/Projects/play/.workflow/docs/continuous-improvement/learnings/`
5. **home**: `/Users/pjbeyer/Projects/home/.workflow/docs/continuous-improvement/learnings/`

## Best Practices

### When Reviewing Cross-Profile

1. **Look for commonalities first** (patterns in multiple contexts)
2. **Respect differences** (different profiles have different needs)
3. **Extract carefully** (don't force context-specific patterns to be global)
4. **Document variations** (how contexts handle differently)
5. **Test in all contexts** (verify applicability)

### When Extracting to Higher Level

1. **Verify truly cross-cutting** (used by multiple lower levels)
2. **Generalize appropriately** (remove context-specific details)
3. **Note exceptions** (where contexts diverge)
4. **Update all levels** to reference higher-level pattern
5. **Validate adoption** (contexts actually use it)

### When Marking Implemented

1. **Be specific** (exact file paths, exact sections)
2. **Include verification** (how you tested it)
3. **Add cross-references** (related learnings, documentation)
4. **Use absolute paths** (never relative)
5. **Add date** (when was it implemented)

## Quarterly Cross-Profile Aggregation

**Every Quarter** (Jan, Apr, Jul, Oct):

1. **Count learnings per profile** using `--summary`
2. **Identify cross-profile patterns** (read learnings from all profiles)
3. **Extract to appropriate level** (global vs profile-specific)
4. **Create quarterly summary**:
   - Location: `{level}/docs/continuous-improvement/quarterly-summaries/YYYY-QN-learnings.md`
   - Content: Cross-profile insights, patterns extracted, comparisons
   - Cross-references: Links to individual learnings and updated docs

## Success Criteria

- ✅ All unimplemented learnings reviewed
- ✅ Documentation updated for each learning
- ✅ "✅ CLOSED LOOP" marker added to learning files
- ✅ Cross-profile patterns extracted appropriately
- ✅ Verification completed
- ✅ Related learnings cross-referenced

## Integration

This skill can be invoked by:
- `/implement-learnings` command (user-facing)
- Automated quarterly review workflows
- Cross-profile analysis tools
