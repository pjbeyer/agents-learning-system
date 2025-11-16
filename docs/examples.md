# Usage Examples

## Example 1: Capturing a Global Learning

**Scenario**: Discovered a better way to configure MCP servers that works across all profiles

```bash
cd ~/Projects
/learn
```

**Workflow**:
1. System detects: Global level
2. Prompts for category: `mcp-patterns`
3. Updates `/Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md` with the new pattern
4. Creates `/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-server-configuration.md`
5. Verifies file location

**Learning file**:
```markdown
## 2025-11-11 - MCP Patterns: Server Configuration Best Practice

**Context**: Configuring Notion MCP server across profiles
**Document Root**: /Users/pjbeyer/Projects
**Level**: Global

**Discovery**:
Using environment variables for MCP server credentials works better than
hardcoded values in .mcp.json files.

**Recommendation**:
Store credentials in profile-specific .env files, reference in .mcp.json

**Status**: Pending
**Priority**: High

**Related Documentation Updates** (REQUIRED):
- [x] Updated: /Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md
- [x] Section: Notion MCP Server Configuration
- [x] Validated: Reading updated docs prevents hardcoded credentials
```

## Example 2: Capturing a Profile-Specific Learning

**Scenario**: Found a work-specific Jira query pattern

```bash
cd ~/Projects/work
/learn
```

**Workflow**:
1. System detects: work profile
2. Prompts for category: `integrations`
3. Updates `/Users/pjbeyer/Projects/work/docs/jira-patterns.md`
4. Creates `/Users/pjbeyer/Projects/work/docs/continuous-improvement/learnings/integrations/2025-11-11-jira-query.md`

## Example 3: Implementing Learnings

**Scenario**: Monthly review of unimplemented learnings

```bash
cd ~/Projects
/implement-learnings
```

**Output**:
```
=== Learning Files Summary ===

Global: 3 files (2 implemented, 1 unimplemented)
pjbeyer: 7 files (6 implemented, 1 unimplemented)
work: 23 files (22 implemented, 1 unimplemented)
play: 0 files
home: 0 files

Total: 33 files (30 implemented, 3 unimplemented)

=== Unimplemented Learnings ===

Global:
/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/learnings/mcp-patterns/2025-11-11-server-configuration.md

pjbeyer:
/Users/pjbeyer/Projects/pjbeyer/docs/continuous-improvement/learnings/tools/2025-11-10-client-template.md

work:
/Users/pjbeyer/Projects/work/docs/continuous-improvement/learnings/integrations/2025-11-11-jira-query.md
```

**Workflow for each**:
1. Read the learning file
2. Identify documentation target
3. Update documentation
4. Mark learning as implemented:

```markdown
## ✅ CLOSED LOOP - 2025-11-11

**Documentation Updated**:
- [x] File: /Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md
- [x] Section: Notion MCP Server Configuration
- [x] Validated: Pattern prevents hardcoded credentials

**Implementation Details**:
- Date: 2025-11-11
- Changes: Added environment variable pattern to MCP registry
- Verification: Tested across pjbeyer and work profiles

**Status**: Implemented on 2025-11-11
```

## Example 4: Cross-Profile Pattern Extraction

**Scenario**: Same Notion MCP pattern appears in work and pjbeyer learnings

```bash
/implement-learnings
```

**Detection**:
```
Pattern found in:
- work/learnings/integrations/2025-10-25-notion-search.md
- pjbeyer/learnings/tools/2025-10-26-notion-database.md

Common: Notion MCP usage patterns
```

**Action**:
1. Extract common pattern to `/Users/pjbeyer/Projects/.workflow/docs/mcp/tool-registry.md`
2. Note work-specific patterns (Security database) stay in work docs
3. Note pjbeyer-specific patterns (Client databases) stay in pjbeyer docs
4. Mark both learning files as implemented with cross-reference

## Example 5: Using find-learnings.sh Script

**Find unimplemented learnings**:
```bash
/Users/pjbeyer/.claude/plugins/cache/agents-learning-system/scripts/find-learnings.sh --unimplemented
```

**Get summary**:
```bash
/Users/pjbeyer/.claude/plugins/cache/agents-learning-system/scripts/find-learnings.sh --summary
```

**JSON output for automation**:
```bash
/Users/pjbeyer/.claude/plugins/cache/agents-learning-system/scripts/find-learnings.sh --json
```

## Example 6: Quarterly Cross-Profile Review

**Scenario**: End of quarter, review all learnings

```bash
cd ~/Projects
/implement-learnings
```

**Quarterly summary creation**:
- Location: `/Users/pjbeyer/Projects/.workflow/docs/continuous-improvement/quarterly-summaries/2025-Q4-learnings.md`
- Content: Cross-profile insights, patterns extracted, comparisons
- Action items: Global documentation updates needed

**Cross-profile insights**:
- Identified 5 patterns appearing in multiple profiles
- Extracted 3 to global documentation
- Noted 2 as profile-specific variations
- Updated MCP registry with cross-profile patterns

## Best Practices from Examples

1. **Always use absolute paths** - Never relative
2. **Update docs FIRST** - Close loop immediately
3. **Choose appropriate level** - Don't force global
4. **Extract carefully** - Respect profile differences
5. **Verify implementations** - Test across profiles
6. **Use the script** - Don't search manually
7. **Quarterly reviews** - Identify cross-profile patterns
