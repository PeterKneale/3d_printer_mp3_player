#!/usr/bin/env bash
# Parameterised OpenSCAD camera renders of the jukebox.
#
# Writes a three-quarter hero shot to preview.png, which is what the README embeds, then a set of
# straight-on views to images/, then a tilted view of the lid on its own. Every view auto-frames, so
# only the angles below matter and nothing needs retuning when a component dimension changes the size
# of the box.
#
# Usage:
#   ./export_png.sh                      # defaults below
#   ./export_png.sh jukebox.scad         # a different model
#
# Every view is a full CGAL render. The OpenCSG preview fills the grille holes with whatever solid
# sits behind them, which makes the straight-on front view useless.
#
# Requires: openscad
set -euo pipefail

model="${1:-jukebox.scad}"
hero="${2:-preview.png}"
outdir="${3:-images}"

# image
img_w=900
img_h=700

# camera orientation, degrees
#   rot_x: pitch. 90 = side on, 0 = straight down, 180 = straight up, 65 = down at 25 degrees
#   rot_y: roll, almost always 0
#   rot_z: yaw. 0 looks at the grille face, 45 is a three-quarter view
rot_x=68
rot_y=0
rot_z=30

# The lid view. Tilted far enough for the icon walls to catch the light, not so far that the row
# nearest the camera foreshortens into a line.
lid_rot_x=38
lid_rot_z=0

# name rot_x rot_z, one straight-on view each. Perspective rather than orthographic on purpose: a
# true elevation looks straight down the axis of every recess, so the jack and USB openings vanish
# into the wall. A little parallax puts them back.
views=(
  front:90:0
  back:90:180
  right:90:90
  left:90:270
  top:0:0
  bottom:180:0
)

mkdir -p "$outdir"

# The hero is the only exploded view: the straight-on set is the box as it sits on the shelf.
openscad --render -o "$hero" \
  --imgsize="${img_w},${img_h}" \
  --viewall --autocenter \
  --camera="0,0,0,${rot_x},${rot_y},${rot_z},0" \
  -D 'part="assembly"' -D 'explode=20' \
  "$model"
echo "done: $hero"

openscad --render -o "$outdir/exploded.png" \
  --imgsize="${img_w},${img_h}" \
  --viewall --autocenter \
  --camera="0,0,0,${rot_x},${rot_y},${rot_z},0" \
  -D 'part="assembly"' -D 'explode=34' \
  "$model"
echo "done: $outdir/exploded.png"

for view in "${views[@]}"; do
  IFS=: read -r name rx rz <<<"$view"
  openscad --render -o "$outdir/$name.png" \
    --imgsize="${img_w},${img_h}" \
    --viewall --autocenter \
    --camera="0,0,0,${rx},${rot_y},${rz},0" \
    -D 'part="assembly"' -D 'explode=0' \
    "$model"
  echo "done: $outdir/$name.png"
done

# The lid on its own, tilted. One colour hides the subject here: the icons stand 0.8 mm proud and
# share a normal with the face beneath them, so nothing shades and they read as hairlines. Drawn in
# the two colours the part is actually printed in instead. part is reassigned after the include
# because the last assignment in a scope wins, which leaves the model emitting nothing of its own.
model_abs="$(cd "$(dirname "$model")" && pwd)/$(basename "$model")"
lid_scad="$(mktemp -t lid_view).scad"
trap 'rm -f "$lid_scad"' EXIT
cat > "$lid_scad" <<EOF
include <$model_abs>
part = "none";
color("#e0b02a") lid_plate();
color("#1f1f1f") lid_icons();
EOF

openscad --render -o "$outdir/lid.png" \
  --imgsize="${img_w},${img_h}" \
  --viewall --autocenter \
  --camera="0,0,0,${lid_rot_x},${rot_y},${lid_rot_z},0" \
  "$lid_scad"
echo "done: $outdir/lid.png"
