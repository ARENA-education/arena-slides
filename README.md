# arena-slides

Beamer decks for [ARENA](https://arena.education/) talks. Folder layout
mirrors [`ARENA_3.0`](https://github.com/callummcdougall/ARENA_3.0).

> **📄 Built PDFs:** **[github.com/ARENA-education/arena-slides/releases/latest](https://github.com/ARENA-education/arena-slides/releases/latest)**

## Add a new deck

1. `cp template.tex chapter<N>_<chapter>/part<M>_<topic>/main.tex`
2. Drop any images into a sibling `img/` folder.
3. Push to `main`.

CI auto-discovers any `chapter*/part*/main.tex` and publishes **two** PDFs
per deck — a handout (no `\pause` reveals, compact) and a presentation
(every `\pause` becomes a separate page, for live talks):

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

## Releases

Every push to `main` overwrites a single rolling `latest` release with the
freshly-built PDFs. PRs and non-`main` branches build but don't publish.
Stable download URLs:

```
https://github.com/<owner>/arena-slides/releases/latest/download/<slug>.pdf
https://github.com/<owner>/arena-slides/releases/latest/download/<slug>-present.pdf
```
