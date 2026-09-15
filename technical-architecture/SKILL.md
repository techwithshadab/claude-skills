---
name: technical-architecture
description: Build or revise a technical architecture figure (cloud reference style for AWS, Azure, Google Cloud or hybrid; official icons for every service and tool; HTML source rendered to PNG). Use whenever asked to create, update, audit or fix an architecture diagram, "technical architecture", solution diagram, or when a diagram gets review comments about overlaps, arrows, labels or layout.
---

Produce an architecture figure the way a solutions architect would: one HTML source rendered by
headless Chrome to a 2x PNG, official icons, a grid, and connectors that never cross anything.
The rules are provider-neutral; the examples are AWS because that is where they were learned.
Everything below came out of review rounds on a real figure; each rule exists because its
violation was pointed out.

## Files in this skill (use them, do not rebuild them)

| Path | Use |
|---|---|
| `templates/figure.html` | Start every new figure from this: the CSS tokens, the plan comment block, one group, two nodes, one wire, the legend. Copy it next to `templates/_design.css` into the project's `docs/diagrams/src/`. |
| `templates/check_counts.py` | Copy and edit: every number typed into a figure is `<span data-count="key">N</span>`; the script derives each key from the repo and fails on drift. Wire it into the test suite. |
| `scripts/render.sh` | `sh render.sh <source.html> <width> <height> [out.png]`, headless Chrome at device scale 2 (`CHROME=` overrides the binary). |
| `scripts/crop.py` | `python crop.py figure.png outdir [x1,y1,x2,y2 ...]`, the four full-resolution quadrants plus any region in 1x coordinates; read every crop before publishing (needs Pillow). |
| `scripts/fetch_icons.sh` | Copy into the project's `icons/` and edit the lists: Simple Icons by slug, project marks by URL, the AWS pack by path (pass the release URL as `$1`). Every icon the figure uses must be a line in it. |
| `examples/argus-aws.html` (+ `examples/icons/`, `_design.css`) | A finished 70-node AWS figure that renders standalone with `render.sh examples/argus-aws.html 1900 840`; read it for the markup of a trunk with junction dots, a trust-boundary pill, a two-column monitoring box, notes inside boxes. |

Project layout that works: `docs/diagrams/src/<name>.html`, `_design.css`, `icons/`, `render.sh`,
`check_counts.py`, rendered `docs/diagrams/<name>.png` committed next to the source, and a
`docs/diagrams/README.md` row per figure (what it shows, version, icon pack release).

## Workflow (do all of it, every time)

1. **Inventory first.** List every node, group and call from the code and IaC before drawing.
   Every node and every arrow must be backed by something real (a service, a task, a call in
   the code). Never draw a service in a box it does not live in, even if asked; explain and
   offer the honest alternative (e.g. a self-hosted Grafana task lives inside the VPC, so it
   gets a "Monitoring · self-hosted" box in the VPC next to the AWS-side "Monitoring · AWS").
2. **Plan coordinates on paper** (a comment block in the source): row centres, column centres,
   box extents, then wires. Change the plan, not individual pixels, when something collides.
3. **Render** with `scripts/render.sh` (headless Chrome, device scale 2).
4. **Audit at full resolution** with `scripts/crop.py`: read the four quadrants, then crop every
   region you changed and read those too. A downscaled preview hides broken images, label collisions
   and short arrow stubs. Do not publish on a downscaled look.
5. **Fix, re-render, re-crop** until the checklist below is clean. Bump the version number in
   the source comment and the diagrams README; update alt text where the figure is embedded.
6. **Keep counts honest**: any number typed into a figure is `<span data-count="key">N</span>`
   and a script derives the key from the repo and fails on drift.

## Layout rules

- **Grid.** Fixed row centres for icons across the whole figure (rows aligned across boxes) and
  fixed column centres per box. Icons 44 px; node = icon + one label below. Row pitch ≥ 120 px
  when labels can be two lines; leave ≥ 12 px between a label's bottom and the box's bottom.
- **One icon and one name per node.** No sub-text under nodes; put explanations in a short note
  inside the box or in the README. Name nodes by what they are ("Job workers", "SQS job
  queues"), plural when there are several.
- **Boxes sized to content, with margins.** ≥ 16 px between neighbouring boxes and ≥ 14 px
  inside the parent box; a child box never touches the parent's edge. No box with a large empty
  area: resize it, move a node in, or fill with a factual note.
- **Titles (chips on the top border)** must not collide with the box above, a wire, or a
  neighbouring chip. If a wire must pass where the title sits, shorten the title ("VPC", not
  "VPC · two zones · flow logs on") or right-align the chip; never let a wire run behind a chip.
- **Outer actors** (users, external feeds) form a full-height column outside the cloud box,
  aligned to the cloud box's top and bottom edges; feeds as icon nodes like everything else,
  joined by a trunk with junction dots, not a text list.
- **Group by purpose**: edge (WAF, sign-in), jobs and scheduling, deployment, identity and
  secrets along the top; network tiers (VPC subnets, VNet, project) by trust level; managed
  control-plane services beside the network; monitoring as its own column. The same shape
  works on Azure (subscription → VNet → subnets) and Google Cloud (project → VPC → subnets). Keep the trust boundary (no NAT / VPC endpoints only) as a dashed vertical
  pill between the platform and the isolated tier, placed where no wire runs.
- **Canvas** wide enough that nothing needs to be squeezed (1900×840 was needed for ~70 nodes);
  widening is cheaper than every collision it prevents.

## How to think about the layout (before any coordinate)

1. **Read it as a story, left to right.** Actors and external inputs outside on the left; the
   entry edge; the platform; the isolated or specialised tier; the managed control plane; the
   monitoring column on the right. A reader should follow a request from the user's icon to the
   data and back without turning around.
2. **Rows are stages, columns are tiers.** Decide 3–4 rows (e.g. request path, ingest and
   internal traffic, data, telemetry) and give every box the same row centres so icons line up
   across the whole figure. Put cross-cutting services (edge, scheduling, deployment, identity
   and secrets) in one band along the top, not scattered.
3. **Boxes follow the real boundaries**: cloud, VPC, subnet tiers, managed services outside the
   VPC. A node goes where it runs, not where it "belongs" conceptually. Draw the trust boundary
   once, as a labelled pill, where it is crossed.
4. **Count first, then size.** Count nodes per box → columns needed → column pitch (≥ 88 px for
   84 px nodes, 100 px for wide labels) → box width; rows → box height. Sum the widths plus
   margins → canvas width. Widen the canvas rather than crowd; 1900 px wide fit about 70 nodes.
5. **Reserve corridors.** Leave ≈ 20 px between boxes horizontally and vertically before placing
   anything; those gaps are where horizontal wires and their labels will run. Decide which wires
   need a corridor (anything spanning two boxes) and which are neighbour-to-neighbour.
6. **Plan every wire on the grid** before writing HTML: source edge, bends, target edge, label
   position. If a wire would have to pass a label, a chip or an icon, move the node or reorder
   the column, do not bend around it. Chains inside a column go straight down; fan-outs use a
   trunk with junction dots; two columns beat one column with detours.
7. **Then write the source** with the plan as a comment block (row centres, column centres),
   so later fixes edit the plan.

## Spacing numbers that worked

| Item | Value |
|---|---|
| Icon | 44 px (service marks 40 px inside the 44 px slot) |
| Label | 10.5 px semibold, 10 px below the icon, plain text, max two lines |
| Row pitch | 120 px (144 px when a corridor with a label runs between two rows) |
| Column pitch | 88 px (84 px nodes), 100–123 px for 100 px nodes with long labels |
| Box padding | ≥ 14 px inside; ≥ 12 px from a label's bottom to the box's bottom |
| Box gap | ≥ 16 px between siblings; 20 px when a wire and its label run through the gap |
| Title chip | on the top border, top-left by default; 8 px clear of the box above |
| Wire | 2 px, arrowhead 6 px marker; ≥ 24 px visible shaft before the head |
| Wire label | 9 px mono pill, 13 px tall, 4–6 px off the wire, ≥ 4 px from any border |
| Note text | 9.5 px, ≤ 60 characters per line, ≥ 16 px from any wire |

## Icons (any provider, any tool)

Rule: every node uses the icon its owner publishes, from the owner's **latest** official
pack, fetched by a script that is checked in next to the figure so the set can be refreshed
and audited. Never hand-draw, never emoji, never a generic shape when an official mark exists,
never a coloured tile or background behind a mark, never mix an old-style and a new-style icon
of the same provider in one figure. Record the pack name and release date in the diagrams
README.

| Provider / kind | Source | Notes |
|---|---|---|
| AWS | AWS Architecture Icons package, https://aws.amazon.com/architecture/icons/ | Link changes per release, pass it to the fetch script. Service icons (64) for services, resource icons (48) for sub-resources (NAT, ALB, flow logs, parameter store), general icons for actors (users, email, magnifying glass), group icons for cloud/VPC/subnet boxes |
| Azure | Azure Architecture Icons, https://learn.microsoft.com/azure/architecture/icons/ | SVG per service; keep Microsoft's naming; group boxes use the subscription / resource group / VNet icons from the same pack |
| Google Cloud | Google Cloud architecture icons, https://cloud.google.com/icons | Official SVG set; use their product names verbatim |
| Kubernetes | https://github.com/kubernetes/community/tree/master/icons | Resource icons (pod, deployment, service, ingress) with labels; the helm mark from the Helm project |
| Other clouds / SaaS (Cloudflare, Datadog, Snowflake, Databricks, Confluent, MongoDB Atlas, Vercel, Auth0, Okta, GitHub, GitLab) | The vendor's brand or press page first; Simple Icons (https://simpleicons.org, `https://cdn.simpleicons.org/<slug>`) when the vendor publishes no SVG | Respect the vendor's colour and clear-space rules; monochrome Simple Icons take the figure's text colour |
| Open-source tools (Grafana, Prometheus, Tempo, Loki, PostgreSQL, Redis/Valkey, nginx, FastAPI, Python, OpenTelemetry, LangChain, LangGraph, MCP, Docker, Terraform) | The project's own repository or site (logo in `docs/` or a brand page); Simple Icons as the fallback | Some projects ship only PNG (Loki, Tempo): keep them at 2x and mark them in the README |
| AI model providers and frameworks (Bedrock, Nova, Claude/Anthropic, OpenAI, Gemini, Strands) | Provider's pack (Bedrock and Nova are in the AWS pack); vendor brand page; the project's GitHub avatar as the last resort | Do not invent a mark for a model; if none exists, use the provider's mark and the model name as the label |
| Actors and generic things (users, operators, browser, email, documents, feeds, internet, camera) | The cloud provider's general/resource icon set of the figure's main provider, so the style matches | Keep line-art icons the figure's text colour; do not mix filled and outlined styles in one box |

Multi-cloud or hybrid figures: one provider's group icons per cloud box, the tool marks
shared; keep each provider's icons at the size the pack intends (64 px service icons scaled
to the figure's 44 px slot, resource icons likewise) so weights match across providers.

Keep a `fetch.sh` that downloads every icon by its pack path or URL (one line per icon) and
add every new icon to it before using it; a missing file renders as a blank square, so the
fetch script is also the inventory.
- Node labels are plain text: no chip/background behind them (chips look inconsistent on a
  gradient and were only ever hiding wires that should not have run there).

## Wire rules

- Orthogonal only, 2 px, one arrowhead at the target. Icon edge to icon edge: leave from the
  icon's side or top, enter the target icon's top or side.
- **Never through a label.** A wire arriving from below must not cross the node's label: end it
  just under the label (arrowhead pointing at the node) or enter from the side. In a vertical
  stack, start each wire just below the source label and end at the next icon's top, straight.
- **Minimum visible shaft**: ≥ 24 px between the last bend and the arrowhead. An arrowhead with
  no shaft ("just the head is visible") is a defect; move the horizontal into the gap between
  boxes to lengthen the vertical.
- **No crossings**: wires never cross another wire, an icon, a label, a title chip or a note.
  Route through gaps between boxes; use one trunk with junction dots (r = 3) when several
  sources or targets share a path. Avoid bends that exist only because two nodes are stacked;
  reorder or use a second column so the chain is straight.
- **Wire labels** are small monospace pills beside the wire (above a horizontal, right of a
  vertical), never on a box border, never over an icon, never touching a title chip. When there
  is no clean place for a label, drop the label rather than overlap.
- **Gaps between boxes** (≈ 20 px) are the routing corridors: put horizontals there, keep
  labels inside a box or in a corridor wide enough for them, and never let a label straddle
  the border between the two.
- Keep the edge-to-edge geometry honest when a node moves: recompute every wire that touches it.
- **Connecting arrows, case by case:** neighbour in the same row → straight horizontal from the
  right edge to the left edge; node in the row below → straight vertical from the icon bottom
  (only if nothing but empty box sits between; a label below the icon means enter the target
  from the side or end the arrow under the label); node in another box → out through the
  nearest gap, along the corridor, in through the target's top; several targets from one
  source → one trunk with dots, one arrowhead per target; several sources into one target →
  stubs into a trunk, one arrowhead at the target; two arrows into the same edge → ≥ 16 px
  apart with their labels on opposite sides.
- **Arrow direction means data or call flow** (legend says so). Do not draw bidirectional
  arrows; pick the direction that answers "who initiates".
- **The SVG wire layer sits under the nodes** (z-index 0 vs 1) so a wire that does end under a
  label reads correctly, but rely on geometry, not layering, to keep wires and text apart.

## Semantics to get right

- Writer vs reader: an ingest/replay task writes to the database and the event stream; the
  tool server that answers agents reads. Show the writes (arrows into the data row) and the
  reads (arrows out of it) as separate wires.
- Show where each external actor enters (browser over HTTPS at the balancer, operator tooling
  with an IAM token at the same balancer, feeds through NAT).
- Two monitoring systems are two boxes with matching names ("Monitoring · self-hosted" in the
  VPC, "Monitoring · AWS" outside); say in a note which telemetry goes where.
- Pilots and optional pieces are labelled as such ("(pilot)"); nothing on the figure should
  claim more than the code does.

## Audit checklist (read every quadrant at full resolution)

- Arrowhead-only stubs; arrows through labels; two arrowheads on top of each other.
- Label or note text crossing a box line; title chips touching a neighbour box; boxes touching.
- Wire labels on borders or over icons; wires behind chips; unlabeled bends that exist only to
  route around a node in the same column.
- Empty regions inside a box; text overflow past a box; mixed icon styles; broken images
  (a missing icon renders as a blank square); dashed arrowheads from a CSS leak.
- Counts that no longer match the repo; alt text and README that describe an older version.

## Do not

- Do not use Mermaid or ASCII art for a deliverable figure.
- Do not put two names on a node, or icon tiles behind marks, or sub-text under nodes.
- Do not move nodes to satisfy a comment if the move breaks a rule above; explain and offer
  the alternative (e.g. "moved right, not left, because the title sits in the top-left corner").
- Do not publish after fixing one region without re-cropping that region; fixes shift wires.
- Do not describe a figure as clean without having read its full-resolution crops.
