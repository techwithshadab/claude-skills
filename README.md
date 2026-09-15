# Claude Code skills

User-level skills for Claude Code. Cloned to `~/.claude/skills` they load in **every**
project on that machine; no per-project setup.

## Install on a new device

```bash
git clone git@github.com:techwithshadab/claude-skills.git ~/.claude/skills
```

If `~/.claude/skills` already exists, move it aside first — the clone needs an empty target.

## Skills

| Skill | Use it for |
|---|---|
| `technical-architecture` | Cloud reference-style architecture figures (AWS/Azure/GCP/hybrid): official vendor icons, HTML source rendered to 2x PNG, count checking so the numbers in a figure cannot drift from the repo. |

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
