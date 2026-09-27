---
name: cost-check
description: Read the course cost sheet and the live cost signals before a cloud deploy or after one. Use when the user says "cost check", "/cost-check", "what will this cost", or is about to run make deploy-aws or make deploy-gcp.
---

# Cost check

A deploy that nobody priced is a bill that nobody expected. This skill runs before the first deploy of a tier and after any run that spent money.

## Before a deploy

1. Read `deploy/COSTS.md`. Identify the track (`NW_TRACK` in `.env`) and the tier (`TIER` on the make command, default `session`).
2. State, in one short table: the cost of the session, the idle cost per day if left running, the idle cost per month, what `stop` still pays for, and what `destroy` leaves behind.
3. Ask the user to confirm the three numbers back before proceeding. If the user cannot, they have not read the sheet.
4. Confirm a budget alarm exists in the target account: on AWS `aws budgets describe-budgets --account-id <id>`; on GCP `gcloud billing budgets list --billing-account <id>`. If none exists, say the deploy should wait until one does.

## After a run

1. AWS: `aws ce get-cost-and-usage` for the day, filtered to the account, or the Cost Explorer page; Lambda, Secrets Manager and Bedrock line items. GCP: the billing report for the project, Cloud Run and Vertex AI line items. Read the model spend from the service's `/metrics` (`nw_agent_cost_usd_total`, `nw_policy_spend_usd_total`).
2. Compare with the cost sheet's estimate for that run. If the measured figure differs by more than half, say so and propose the corrected line for `deploy/COSTS.md`.
3. Remind the user of the stop and destroy commands for the tier, with the residual cost of each.

## Rules

- Numbers come from the cost sheet or from a command's output, never from memory.
- Never run a deploy, stop or destroy command yourself from this skill.
