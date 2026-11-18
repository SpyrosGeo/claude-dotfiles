---
name: that-review
description: "Dual code review: runs the ponytail-review skill and the code-review skill in two parallel sub-agents, then verifies every finding against the real code and confirms or pushes back on it. Use for /that-review."
disable-model-invocation: true
---

# That Review

Two independent reviews, one judge. The sub-agents find problems. You, the main thread, decide which findings are real.

## 1. Pin the scope

- Argument given (branch, ref, commit range, PR, files): review that.
- No argument: the uncommitted changes (staged + unstaged). None? The last commit (`HEAD~1..HEAD`).

Resolve it before spawning anything:

- Confirm refs exist (`git rev-parse <ref>`).
- Confirm the diff is non-empty. Empty diff or bad ref: stop and tell the user.
- Write down the exact diff command (e.g. `git diff HEAD`, `git diff HEAD~1..HEAD`, `git diff main...HEAD`) and the list of changed files. Both sub-agents get the same ones.

## 2. Spawn both reviews in parallel

One `task` call with two items in `tasks[]`, default agent. Put the scope, diff command and changed files in the shared `context`; each `task` is self-contained.

**Task A: ponytail review**

> Read `skill://ponytail-review` and follow it. Review exactly the scope in context. Do not edit any file. Return every finding as: `path:line | severity | category | problem | why it matters | suggested fix`. List what you did not check.

**Task B: code-review skill**

> Read `skill://code-review` and follow it. Review exactly the scope in context. Adaptations: if you cannot spawn sub-agents, run the Standards and Spec axes yourself, one after the other. If the scope is uncommitted changes, use `git diff HEAD` instead of `<fixed-point>...HEAD`. If no spec or issue can be found, skip the Spec axis and say so; do not stop to ask. Do not edit any file. Return every finding as: `path:line | severity | axis | problem | why it matters | suggested fix`.

## 3. Verify every finding yourself

Do not trust either review. For each finding:

1. Open the cited file and line. Read enough context: the function, its callers, its tests.
2. Check the claim against the code. Does the bug happen with real inputs? Does the standard actually exist in the repo's docs? Is the "missing" check already done elsewhere?
3. Give a verdict:
   - **Confirmed**: the problem is real. Cite the evidence (line, caller, input that breaks it).
   - **Rejected**: the claim is wrong or does not apply. Say why, with evidence.
   - **Uncertain**: cannot settle it from the code (needs runtime data, product intent). Say what would settle it.
4. Adjust severity when the reviewer over- or under-rated it, and say so.

Merge duplicates: when both reviews report the same problem, keep one entry and mark it as found by both. Agreement raises confidence; it is not proof. Verify it anyway.

If you notice a real problem both reviewers missed while verifying, add it, marked as found by the main thread.

## 4. Report

Report only. Do not edit code.

Order: Confirmed (most severe first), then Uncertain, then Rejected.

Per finding:

```
[Confirmed|Uncertain|Rejected] <severity> path:line: <problem>
  Source: ponytail | code-review | both | main thread
  Evidence: <what you checked and found>
  Fix: <suggested fix>   (Confirmed and Uncertain only)
```

End with:

- Count per verdict and per source.
- Any area neither review covered (e.g. Spec axis skipped, files not read).
