#!/usr/bin/env bash
# Compile every chapter*/part*/main.tex with latexmk and report pass/fail.
# Builds run in parallel (4 workers). Build artefacts land in a temp dir so
# the repo stays clean. Mirrors CI's latexmk invocation closely enough to
# catch the same failures locally before pushing.
#
# Usage:  ./check-builds.sh [--present]
#   default     build in handout mode (\HANDOUT=1)
#   --present   build in presentation mode (\HANDOUT=0)
# Exit code: 0 if every deck compiles, 1 otherwise.

set -uo pipefail

WORKERS=4

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

handout=1
case "${1:-}" in
    "")          ;;
    --present)   handout=0 ;;
    -h|--help)   sed -n '2,12p' "$0"; exit 0 ;;
    *)           echo "usage: $0 [--present]" >&2; exit 2 ;;
esac

mapfile -t decks < <(find "$repo_root" -path "$repo_root/chapter*/part*/main.tex" | sort)

if [[ ${#decks[@]} -eq 0 ]]; then
    echo "no decks found under chapter*/part*/main.tex"
    exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Each background job writes its result line to stdout and, on success,
# touches a sentinel file. We collect failures by walking the sentinels
# after `wait`, which keeps the per-deck log paths inspectable.
build_one() {
    local tex="$1" rel="$2" outdir="$3"
    if latexmk -pdf -cd -file-line-error -halt-on-error -interaction=nonstopmode \
               -usepretex="\\def\\HANDOUT{$handout}" \
               -outdir="$outdir" \
               "$tex" >"$outdir/latexmk.log" 2>&1; then
        : > "$outdir/.ok"
        printf '  [OK]   %s\n' "$rel"
    else
        printf '  [FAIL] %s\n' "$rel"
    fi
}

echo "Building ${#decks[@]} deck(s) with $WORKERS parallel workers..."
active=0
rels=()
outdirs=()
for i in "${!decks[@]}"; do
    tex="${decks[$i]}"
    rel="${tex#"$repo_root"/}"
    outdir="$tmp/${rel//\//_}"
    mkdir -p "$outdir"
    rels[i]="$rel"
    outdirs[i]="$outdir"

    build_one "$tex" "$rel" "$outdir" &
    active=$((active + 1))
    if (( active >= WORKERS )); then
        wait -n
        active=$((active - 1))
    fi
done
wait

echo
fails=()
for i in "${!decks[@]}"; do
    if [[ ! -e "${outdirs[$i]}/.ok" ]]; then
        fails+=("${rels[$i]}")
    fi
done

if [[ ${#fails[@]} -eq 0 ]]; then
    echo "All ${#decks[@]} deck(s) compiled."
    exit 0
fi

for f in "${fails[@]}"; do
    outdir="$tmp/${f//\//_}"
    echo "---- $f: last 30 lines of latexmk.log ----"
    tail -n 30 "$outdir/latexmk.log" | sed 's/^/  /'
    echo "---- end ----"
done

echo
echo "${#fails[@]} of ${#decks[@]} deck(s) failed:"
for f in "${fails[@]}"; do echo "  - $f"; done
exit 1
