# arena-slides

Beamer decks for [ARENA](https://arena.education/) talks. Folder layout
mirrors [`ARENA_3.0`](https://github.com/callummcdougall/ARENA_3.0).

> **🌐 Live site:** **[arena-education.github.io/arena-slides](https://arena-education.github.io/arena-slides/)** — every deck's handout and presentation PDF, open inline in the browser.

## Add a new deck

1. `cp template.tex chapter<N>_<chapter>/part<M>_<topic>/main.tex`
2. Drop any images into a sibling `img/` folder.
3. Push to `main`.

That's the whole workflow. CI auto-discovers any `chapter*/part*/main.tex`,
builds **two** PDFs per deck — a handout (no `\pause` reveals, compact)
and a presentation (every `\pause` becomes a separate page, for live talks) —
and republishes the live site. Nothing else to configure, no commands to run.

| Folder | Handout | Presentation |
|---|---|---|
| `chapter0_fundamentals/part2_cnns/` | `0.2-cnns.pdf` | `0.2-cnns-present.pdf` |
| `chapter1_transformer_interp/part3_1_ioi/` | `1.3.1-ioi.pdf` | `1.3.1-ioi-present.pdf` |

## Build locally

```sh
cd chapter<N>_*/part<M>_*
pdflatex main.tex
```

The deck's first line is `\providecommand{\HANDOUT}{1}` — flip `1` ↔ `0`
to change what bare `pdflatex main.tex` produces. The CI ignores it (always
builds both via the `-usepretex` overrides above) so you can leave it set
to whichever mode you happen to want locally.

`main.tex` loads the shared preamble via `\input{../../arena_beamer.sty}`,
which is also where the actual `\documentclass` call lives.

## Hosting

Every push to `main` rebuilds every deck and replaces the live site at
**[arena-education.github.io/arena-slides](https://arena-education.github.io/arena-slides/)**.
The index page lists all decks grouped by chapter; clicking any link opens
the PDF inline in your browser's built-in viewer (no download).

Stable per-deck URLs:

```
https://arena-education.github.io/arena-slides/<slug>.pdf          # handout
https://arena-education.github.io/arena-slides/<slug>-present.pdf  # presentation
```

PRs and non-`main` branches build (to catch errors early) but don't deploy.

PDFs are **not** committed to this repo and previous versions are **not**
archived — the LaTeX on `main` is the only source of truth. The repo stays
flat; old PDFs are replaced on every deploy.

## Where things live

The repo holds *source* only. Everything visible on the live site is
regenerated on each push.

| To change... | Edit... |
|---|---|
| Slide content / math / figures | the deck's `main.tex` |
| Slide images | the deck's sibling `img/` folder |
| Shared LaTeX preamble, theme, custom macros | `arena_beamer.sty` |
| The index page's look (HTML / CSS) | `.github/workflows/build-slides.yml`, step **"Generate public/index.html (chapter-grouped)"** — the heredoc + `<li>` template |
| Pretty chapter names on the index page | same file, the `case "$chap_dir" in ...` block (add a row when a new `chapterN_*` lands) |
| A deck's title as shown on the index page | the `{{[X.Y] Title}}` line near the top of that deck's `main.tex` |
| Build/CI behaviour (when to build, deploy gating, etc.) | `.github/workflows/build-slides.yml` (other steps) |
| Local-build defaults (handout vs. presentation) | `\providecommand{\HANDOUT}{1}` at the top of each deck's `main.tex` |

What you do **not** edit (because it isn't checked in): the generated
`index.html` and the built PDFs. Those live only in GitHub's Pages
artifact storage and are replaced every deploy.
