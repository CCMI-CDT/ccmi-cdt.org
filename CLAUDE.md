# CLAUDE.md

This repository is the website of the EPSRC Centre for Doctoral Training in Collaborative Computational Modelling at the Interface (CCMI), a joint UCL / Imperial College London programme, served at https://ccmi-cdt.org (custom domain via `CNAME`). It is a static [Quarto](https://quarto.org/) `website` project; almost all work is content editing. Readers are mainly prospective PhD applicants — write in British English.

## Commands

- `quarto preview` — live local preview
- `quarto render` — full build into `_site/` (this is what CI checks)

`_site/` and `.quarto/` are gitignored build output — never edit them.

## Deployment

- `.github/workflows/render.yml` renders the site on every push and PR (acts as the test).
- `.github/workflows/publish.yml` renders and publishes to the `gh-pages` branch on pushes to `main`, and daily via cron (00:01 UTC) so date-based listings such as "upcoming events" stay current.
- Changes land on `main` via pull requests.

## Structure

- `_quarto.yml` — navbar, site metadata, global HTML format (`styles.css`, footer `templates/footer.html`). `static/*` is copied as resources.
- `styles.css` — all custom styling.
- Top-level pages: `index.qmd` (homepage), `apply.qmd`, `faq.qmd`, `interview.qmd`, `team.qmd`, `student_list.qmd`, `training/*.qmd`.
- `static/` — images, PDFs (e.g. the application form), logos in `static/assets/`, photos in `static/people/{team,students}/`. Pages in subfolders reference these with `../static/...`.
- `_extensions/` — third-party Quarto extensions (`quarto-ext/fontawesome`, `mscroggs/academic-webpage`) under their own licences; don't modify.

### Listing pattern

Most sections are a list page with a `listing:` block + a folder of entry `.qmd` files + a custom EJS template in `templates/`:

| List page | Entries | Template |
|---|---|---|
| `events/event_list.qmd` | `events/posts/` | `templates/event-list-page.ejs` |
| `blog/blog_list.qmd` | `blog/posts/` | `templates/blog-list-page.ejs` |
| `student_list.qmd` | `students/` (sorted by `surname`) | `templates/student-list.ejs` |
| `phd_projects/phd_project_list.qmd` | `phd_projects/entries/` | `templates/phd_projects.ejs` |
| `team.qmd` | inline YAML `contents:` list | `templates/partials/team-card.ejs` |

The homepage `index.qmd` combines partials from `templates/partials/` (`title-block.html`, `blog-section.ejs`, `upcoming-events-section.ejs`, `key-facts-area.ejs`) fed by `blog/posts`, `events/posts` and `templates/key-facts.yml`.

The PhD projects page is not in the navbar; it is linked from `apply.qmd`/`faq.qmd`. `phd_projects/entries/_metadata.yml` sets the author/affiliation labels ("Supervisor"/"Institution").

## Adding content

Copy an existing entry of the same kind and adapt it. Front-matter fields used by the templates:

**Student** — `students/firstname_surname.qmd`; the body is only the shortcode:
```yaml
name: "Advaith"
surname: "Velavan"
image: https://github.com/<user>.png   # or ../static/people/students/<file>
github: <user>
info:
  - "One-paragraph research description."
interests: [ ... ]
education:
  - institution: ...
    location: ...
    degree: ...
    startdate: Oct 2020
    enddate: Jun 2025
```
followed by `{{< academic-webpage >}}`.

**Event / seminar** — `events/posts/YYYY_seminar_MM_DD.qmd` (or a descriptive name). Dates are **MM/DD/YYYY**; `event_date` drives the homepage "upcoming events" section, `date` is the posting date:
```yaml
title: "Seminar on ..."
author: "Timo Betcke"
event_date: "03/10/2026"
date: "03/06/2026"
summary: "One-line teaser."
categories: [News]
```
Seminar bodies start with bold `**LOCATION:**`, `**TIME:**`, `**SPEAKER:**` lines, followed by title/abstract/bio.

**Blog post** — `blog/posts/<slug>.qmd`, starting from `blog/blogpost_template.qmd`: `title`, `author`, `date` (ISO `YYYY-MM-DD` in existing posts), `summary`, `categories`.

**PhD project** — `phd_projects/entries/<Supervisor>_<topic>.qmd`: `title`, `department`, `date`, `author: {name, affiliation}`, `institution`, then a `## Project Description` body.

**Team member** — add an item (`name`, `description` HTML, `image`, `homepage`, optional `github`/`orcid`) to the `contents:` list in `team.qmd`; photo in `static/people/team/`.

**Key facts** — edit `templates/key-facts.yml`.

## Gotchas

- Application calls and deadlines appear in both the `#interest` section of `index.qmd` and the banner at the top of `apply.qmd` — update both together.
- Raw HTML sections in `index.qmd` rely on IDs/classes styled in `styles.css`; keep them intact when editing text.
