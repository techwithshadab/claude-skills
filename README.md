# Claude Code skills

User-level skills for Claude Code. Cloned to `~/.claude/skills` they load in **every**
project on that machine; no per-project setup.

## Install on a new device

```bash
git clone git@github.com:techwithshadab/claude-skills.git ~/.claude/skills
```

If `~/.claude/skills` already exists, move it aside first — the clone needs an empty target.

## Skills

Flat layout: every top-level directory is one skill, so the clone above loads all of them. The
same tree is also an installable Claude Code plugin (`.claude-plugin/`) and works with
`npx skills@latest add techwithshadab/claude-skills`. Pin a tag per cohort.

| Skill | Use it for |
|---|---|
| `technical-architecture` | Cloud reference-style architecture figures (AWS/Azure/GCP/hybrid): official vendor icons, HTML source rendered to 2x PNG, count checking so the numbers in a figure cannot drift from the repo. |
| `tdd` | Building features or fixing bugs test-first: the failing test before the code. |
| `code-review` | Reviewing a diff against the repo's standards and against the spec that asked for it. |
| `diagnosing-bugs` | A diagnosis loop for hard bugs and regressions instead of patching on a guess. |
| `domain-modeling` | Pinning down vocabulary in `CONTEXT.md` and recording decisions as ADRs. |
| `codebase-design` | Deciding where a seam goes and how to make a module deep and testable. |
| `grilling` | Stress-testing a plan or decision with one question at a time before code. |
| `session-check` | Northwind AI Engineering course: one session's acceptance criteria, each with evidence. |
| `cost-check` | The course cost sheet and live cost signals, before and after a cloud deploy. |
| `trace-replay` | Reading one agent trajectory from its trace file and saying where it went wrong. |

`tdd`, `code-review`, `diagnosing-bugs`, `domain-modeling`, `codebase-design` and `grilling` are
adapted from `mattpocock/skills` (MIT); see `THIRD_PARTY_NOTICES.md`. The rest are original.

## How technical-architecture works

- `SKILL.md` — the rules: layout bands, wire routing, when a figure earns its place.
- `templates/figure.html` + `_design.css` — start every new figure from these.
- `templates/check_counts.py` — every number in a figure is wrapped as
  `<span data-count="key">N</span>` and verified against the repo, so a stale count fails a test.
- `scripts/render.sh` — headless Chrome to 2x PNG; `crop.py` trims whitespace.
- `scripts/fetch_icons.sh` — pulls official AWS architecture icons.
- `examples/argus-aws.html` — a complete worked figure to copy from.

Icons under `examples/icons/` are vendor marks (AWS, and project logos such as LangChain,
Docker, Prometheus) kept for reference; they remain the property of their owners.
