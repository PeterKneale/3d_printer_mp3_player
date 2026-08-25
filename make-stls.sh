#!/usr/bin/env bash
# Render the printable parts of jukebox.scad to stl/. Any extra args are passed
# through to openscad, so overrides work: ./make-stls.sh -D 'speaker_d=40'
set -uo pipefail

cd "$(dirname "$0")"

SCAD=jukebox.scad
OUT=stl

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

PARTS_ALL=(body panel lid speaker_ring)
ONE_COLOUR=(plate_one_colour)
TWO_COLOUR=(plate_two_colour plate_lid)

usage() {
  cat <<EOF
usage: $(basename "$0") [parts|one-colour|two-colour] [openscad options]

  parts        the four printed parts one STL each, in model coordinates (default)
  one-colour   one bed, all four parts, already rotated so nothing needs supports
  two-colour   two beds: everything but the lid, then the lid on its own, so a filament
               change at the label layer colours the lettering and nothing else

"plate" is accepted as an older name for one-colour.

Trailing options pass straight to openscad:
  $(basename "$0") parts -D 'pcb_w=77' -D 'pcb_d=33'
  $(basename "$0") one-colour -D 'button_icons=["prev","play","next"]'
EOF
}

case ${1:-} in
  -h|--help) usage; exit 0 ;;
esac

SEL=parts
case ${1:-} in
  parts|all)            SEL=parts; shift ;;
  one-colour|one|plate) SEL=one-colour; shift ;;
  two-colour|two)       SEL=two-colour; shift ;;
  ''|-*) ;;                     # no target given, or straight to openscad options
  *) echo "unknown target: $1" >&2; usage >&2; exit 1 ;;
esac
case $SEL in
  one-colour) PARTS=("${ONE_COLOUR[@]}") ;;
  two-colour) PARTS=("${TWO_COLOUR[@]}") ;;
  *)          PARTS=("${PARTS_ALL[@]}") ;;
esac
# The plate targets are already named plate_*. Give the single parts a prefix of their own.
PREFIX=; [[ $SEL == parts ]] && PREFIX=part_
LOGS=$OUT/logs

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
printf '\n%-18s %10s %8s  %s\n' FILE SIZE TIME STATUS
printf '%s\n' "----------------------------------------------------------------"

for part in "${PARTS[@]}"; do
  name=$PREFIX$part
  stl=$OUT/$name.stl
  log=$LOGS/$name.log
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
  printf '%-18s %10s %7ss  %s\n' "$name" "$human" "$elapsed" "$status"
done

# The model echoes resolved dimensions on every render, and they are the numbers
# worth checking before the filament is spent.
printf '\n%s\n' "resolved geometry"
sed -n 's/^ECHO: "\(.*\)"$/  \1/p' "$probe"

if (( ${#failed[@]} )); then
  printf '\n%s\n' "FAILED: ${failed[*]}  (see $LOGS/<part>.log)"
  exit 1
fi

printf '\n%s\n' "${#PARTS[@]} file(s) written to $OUT/."
printf '%s\n' "No supports anywhere, 0.2 mm layers. The body stands on its floor, the panel lies on its face."
case $SEL in
  one-colour) printf '%s\n' "One bed. Slice $OUT/plate_one_colour.stl and print it." ;;
  two-colour) printf '%s\n' "Two beds. Print $OUT/plate_two_colour.stl, then $OUT/plate_lid.stl with a filament change at the height echoed above." ;;
  *)          printf '%s\n' "These are in model coordinates, not print orientation. Lay the panel grille down before you slice it." ;;
esac
