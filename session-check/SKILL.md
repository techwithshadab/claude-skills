---
name: session-check
description: Check one session of the Northwind AI Engineering course against its acceptance criteria. Use when the user says "session check", "/session-check N", "am I done with session N", or wants to know whether a session's work is complete before committing.
---

# Session check

Nothing in this course is done because it feels done. It is done when every acceptance criterion for the session is met with evidence. This skill produces that evidence.

Argument: the session number, 1 to 6. If absent, ask.

## Process

1. **Find the criteria.** Read `sessions/session-NN/README.md` and the "Acceptance criteria" section of the session's deck under `docs/decks/session-NN.pdf` if present. The guide's step checks are the same criteria phrased as commands; the numbered list in the deck is canonical.

2. **Run the checks.** Run `make sessionNN` and `make lint`. Read the output yourself; do not summarise it from memory. For sessions with a report file, read it:
   - Session 2: `artifacts/triage/latest/report.json` (macro-F1, P0 recall, threshold)
   - Session 3: `artifacts/semantic/benchmark.json` and `export_report.json`
   - Session 4: `artifacts/policy/eval.json` (citation validity must be exactly 1.0; recall@k, refusal correctness)
   - Session 5: `artifacts/agent_eval.json` (at least 12 of 15, every injection case, zero unapproved executions) and confirm `artifacts/escalations.jsonl` does not exist
   - Session 6: the numbers the participant wrote down in the guide's steps: idle cost per day, warm and cold p95, the rollback command, cost per resolution before and after routing. Ask for them if not in the conversation.

3. **Report, one line per criterion.** Format:

   | Criterion | Met | Evidence |
   | --- | --- | --- |

   Evidence is a test name, a number from a report, or a command output line. "Tests pass" is not evidence for a criterion about a number.

4. **Say what is not met and what to do.** If a criterion is not met, name the file and function the guide says to edit, and the test that will prove it. Do not fix it yourself unless asked; this skill is a check, not a repair.

5. **Only then** say the session is done. If any criterion is not met, say the session is not done, in those words.

## Rules

- Never modify code during a check.
- Never mark a criterion met on the strength of a passing test suite alone when the criterion names a number.
- The escalation queue file existing after an agent evaluation means an irreversible action ran without approval. That fails Session 5 and Session 6 regardless of any other result.
