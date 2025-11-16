---
description: Systematically review and implement captured learnings across hierarchy levels with closed-loop tracking
---

# Implement Learnings - Apply Captured Learnings

Systematically review and implement captured learnings across all hierarchy levels with proper closed-loop tracking.

## Invocation

Use and follow the `apply-learning` skill exactly as written.

## Usage

From any location in your project hierarchy:

```bash
/implement-learnings
```

The skill will:
1. Find all unimplemented learnings across profiles
2. Identify cross-profile patterns
3. Update documentation with learnings
4. Mark learnings as implemented with "✅ CLOSED LOOP"
5. Extract patterns to appropriate hierarchy levels

## Multi-Profile Search

Searches across all profiles:
- Global: `~/Projects/docs/continuous-improvement/learnings/`
- pjbeyer: `~/Projects/pjbeyer/docs/continuous-improvement/learnings/`
- work: `~/Projects/work/docs/continuous-improvement/learnings/`
- play: `~/Projects/play/docs/continuous-improvement/learnings/`
- home: `~/Projects/home/docs/continuous-improvement/learnings/`

## Finding Learnings

The command uses `find-learnings.sh` script which provides:
- Summary statistics
- Unimplemented learning lists
- Category counts
- JSON output for programmatic use

## Closed-Loop Tracking

Each implemented learning is marked with:
```markdown
## ✅ CLOSED LOOP - [Date]

**Documentation Updated**:
- [x] File: [exact absolute file path]
- [x] Section: [what was added/changed]
- [x] Validated: Reading updated docs prevents recurrence
```

## Quarterly Review

Run this command quarterly (Jan, Apr, Jul, Oct) for:
- Cross-profile pattern identification
- Global pattern extraction
- Quarterly summary creation
- Documentation consolidation

## Related

- Skill: `apply-learning` (provides the implementation)
- Command: `/learn` (captures new learnings)
- Script: `find-learnings.sh` (discovers learning files)
