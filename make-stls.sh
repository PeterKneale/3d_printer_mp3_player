#!/usr/bin/env bash
# Render the printable parts of jukebox.scad to stl/. Any extra args are passed
# through to openscad, so overrides work: ./make-stls.sh -D 'speaker_d=40'
set -uo pipefail

cd "$(dirname "$0")"

SCAD=jukebox.scad
OUT=stl
LOGS=$OUT/logs

OPENSCAD=${OPENSCAD:-$(command -v openscad || true)}
if [[ -z $OPENSCAD ]]; then
  for c in /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD /opt/homebrew/bin/openscad; do
    [[ -x $c ]] && OPENSCAD=$c && break
  done
fi
if [[ -z ${OPENSCAD:-} ]]; then
  echo "openscad not found. brew install --cask openscad, or set OPENSCAD=/path/to/openscad" >&2
  exit 1
fi

GAUGES=(pcb_gauge end_gauge)
BODY=(body lid speaker_ring)
PLATE=(print_plate)

usage() {
  cat <<EOF
usage: $(basename "$0") [gauges|parts|all] [openscad options]

  gauges   pcb_gauge, end_gauge          check these against the board first
  parts    body, lid, speaker_ring       the enclosure itself
  all      both (default)
  plate    print_plate                   all five on one bed, 201 x 112 mm

Trailing options pass straight to openscad:
  $(basename "$0") parts -D 'pcb_w=77' -D 'pcb_d=33'
  $(basename "$0") all -D 'grille_style="rings"' -D 'pcb_flip=false'
EOF
}

case ${1:-} in
  -h|--help) usage; exit 0 ;;
esac

SEL=all
case ${1:-} in
  gauges|parts|all|plate) SEL=$1; shift ;;
esac
case $SEL in
  gauges) PARTS=("${GAUGES[@]}") ;;
  parts)  PARTS=("${BODY[@]}") ;;
  plate)  PARTS=("${PLATE[@]}") ;;
  all)    PARTS=("${GAUGES[@]}" "${BODY[@]}") ;;
esac

mkdir -p "$LOGS"
failed=()
probe=$LOGS/params.log

# Resolve the sizes once up front. This also catches a bad override before any real work, because
# openscad only warns about an undefined variable and still exits 0 with a quietly wrong STL.
"$OPENSCAD" -o "$LOGS/probe.stl" -D 'part="none"' "$@" "$SCAD" >"$probe" 2>&1
rm -f "$LOGS/probe.stl"
if grep -qE 'ERROR|WARNING' "$probe"; then
  echo "bad parameters:" >&2
  grep -E 'ERROR|WARNING' "$probe" | head -4 >&2
  exit 1
fi

printf '%s\n' "openscad: $OPENSCAD"
[[ $# -gt 0 ]] && printf '%s\n' "overrides: $*"
printf '\n%-14s %10s %8s  %s\n' PART SIZE TIME STATUS
printf '%s\n' "------------------------------------------------------------"

for part in "${PARTS[@]}"; do
  stl=$OUT/$part.stl
  log=$LOGS/$part.log
  start=$SECONDS

  if ! "$OPENSCAD" -o "$stl" -D "part=\"$part\"" "$@" "$SCAD" >"$log" 2>&1; then
    status=FAILED
  elif grep -qE 'ERROR|WARNING' "$log"; then
    status=WARNED
  # A CGAL result reports its status; a plain polyset has none to report.
  elif grep -q 'Status:' "$log" && ! grep -q 'Status:[[:space:]]*NoError' "$log"; then
    status='NOT MANIFOLD'
  else
    status=ok
  fi
  [[ $status == ok ]] || failed+=("$part")

  elapsed=$((SECONDS - start))
  if [[ -f $stl ]]; then
    human=$(( $(wc -c <"$stl" | tr -d ' ') / 1024 ))K
  else
    human=-
  fi
  printf '%-14s %10s %7ss  %s\n' "$part" "$human" "$elapsed" "$status"
done

# The model echoes resolved dimensions on every render, and they are the numbers
# worth checking before the filament is spent.
printf '\n%s\n' "resolved geometry"
sed -n 's/^ECHO: "\(.*\)"$/  \1/p' "$probe"

if (( ${#failed[@]} )); then
  printf '\n%s\n' "FAILED: ${failed[*]}  (see $LOGS/<part>.log)"
  exit 1
fi

printf '\n%s\n' "${#PARTS[@]} parts written to $OUT/."
if [[ $SEL == gauges ]]; then
  printf '%s\n' "Check both against the board, then: $(basename "$0") parts"
else
  printf '%s\n' "No supports, 0.2 mm layers, body open side up, rest flat."
fi
