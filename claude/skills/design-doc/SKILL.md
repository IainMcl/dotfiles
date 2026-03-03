---
name: design-doc
description: Produce a structured design document covering problem statement, goals, proposed solution, alternatives, and risks. Use when planning significant features or technical changes that need sign-off or shared understanding.
---

# Design Doc Creator

Produces clear, well-structured design documents for technical decisions, communicating to a mixed audience and facilitating alignment before implementation.

## Audience

Default: engineers, engineering managers, product managers, and designers. If a specific audience is provided, note it at the top. Avoid jargon — where technical concepts are unavoidable, explain them plainly.

## Document structure

### Always included

1. **Target audience** — only if specific; omit for the default mixed audience
2. **TL;DR / Abstract** — concise summary of the problem, solution, and key decisions. Readable in under a minute.
3. **Overview** — problem statement, goals, non-goals. What are we solving, why does it matter, what does success look like, what is explicitly out of scope?
4. **Testing, Rollout & Rollback** — how will this be tested? Rollout plan (phased, feature flagged, etc.)? Rollback plan?
5. **Metrics, Monitoring & SLAs** — how will we know this is working? Metrics, SLAs, alerts, dashboards.
6. **Alternatives Considered** — other approaches evaluated and why they were not chosen.
7. **Open Questions** — decisions or unknowns to resolve before or during implementation.
8. **References** — all external links and sources.
9. **Acronyms** — table of all acronyms used.

### Included if relevant

Include only if relevant. If considered and excluded, add a brief note explaining why.

- **Tech Stack** — technologies, languages, frameworks, and services involved.
- **System Scalability** — performance under load, bottlenecks, scaling concerns.
- **Security & Privacy Considerations** — security threats, data sensitivity, compliance, PII handling.
- **Mobile Impact** — impact on mobile clients or experiences.
- **Business Impact Considerations** — effect on revenue, customers, or operations.
- **UI/UX & Accessibility Considerations** — user-facing changes, design decisions, accessibility requirements.
- **Timeline & Roadmap** — phasing, milestones, and dependencies.

## Acronym rules

- On **first use**, write in full with acronym in parentheses: e.g. "Application Programming Interface (API)".
- Subsequent uses may use the acronym alone.
- All acronyms must appear in the Acronyms table at the end.

Acronym table format:
| Acronym | Definition |
|---|---|
| API | Application Programming Interface |

## References

- Link references inline where cited.
- Collect all in a References section before the Acronyms table.

## Output

- Default: write as a markdown file in the appropriate project location.
- If Notion is the target, use the Notion MCP to create or update the page.

## Constraints

- Do not begin writing until the problem and proposed solution are sufficiently understood — ask clarifying questions first.
- Only document what is necessary — do not pad.
- Keep the TL;DR genuinely brief.
- Flag any open questions that could significantly change the design.
