---
name: trace-replay
description: Replay one agent trajectory from its trace file and explain where it went wrong or where the money went. Use when the user says "trace replay", "/trace-replay <run id>", "why did this run fail", or wants to read an agent run step by step.
---

# Trace replay

An agent failure you cannot replay is an anecdote. Every run in this course writes a trace under `artifacts/traces/<run_id>.json`; this skill reads one and explains it.

Argument: a run id, or a path to a trace file. If absent, list the five most recent traces with `ls -t artifacts/traces | head -5` and ask which one.

## Process

1. Print the transcript: `uv run python -m nw.agent.trace artifacts/traces/<run_id>.json`. Read every step.
2. Classify the outcome from `terminated`: `answer`, `max_steps`, `budget`, or `error`.
3. Walk the steps and name, for each tool call: was the tool the right one for what the model was trying to learn; were the arguments valid (an `invalid_arguments` observation means the model guessed at the schema); did the observation change the next decision or was it ignored.
4. If there are proposed actions, state whether each was warranted by the priority or the policy the trace shows, and confirm none was executed (the trace says `PENDING APPROVAL`; the file `artifacts/escalations.jsonl` must not exist unless a human approved).
5. If the run was scored by `nw/agent/evaluate.py`, read its failures from `artifacts/agent_eval.json` and tie each failure to the step that caused it.
6. Sum the cost by step and say where the money went: which step's tokens dominate, and whether an earlier answer was possible.

## Verdict

One paragraph: the single root cause (tool design, prompt, the case itself, or the model), the step where it went wrong, and the smallest change that would have fixed it. Then the cost line.

## Rules

- Read the trace file; do not reconstruct the run from the conversation.
- Do not re-run the agent from this skill. Replay is free; runs cost money.
