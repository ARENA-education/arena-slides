# arena-slides

Beamer decks for [ARENA](https://arena.education/) talks. Folder layout
mirrors [`ARENA_3.0`](https://github.com/callummcdougall/ARENA_3.0).

## Add a new deck

1. `cp template.tex chapter<N>_<chapter>/part<M>_<topic>/main.tex`
2. Drop any images into a sibling `img/` folder.
3. Push to `main`.

CI auto-discovers any `chapter*/part*/main.tex` and publishes a PDF named
after the folder:

| Folder | PDF |
|---|---|
| `chapter0_fundamentals/part2_cnns/` | `0.2-cnns.pdf` |
| `chapter1_transformer_interp/part3_1_ioi/` | `1.3.1-ioi.pdf` |

## Build locally

```sh
cd chapter<N>_*/part<M>_*
pdflatex main.tex                 # or: latexmk -pdf main.tex
```

`main.tex` includes the shared preamble via `\input{../../arena_beamer.sty}`.

## Releases

Every push to `main` overwrites a single rolling `latest` release with the
freshly-built PDFs. PRs and non-`main` branches build but don't publish.
Stable download URL:

```
https://github.com/<owner>/arena-slides/releases/latest/download/<slug>.pdf
```
