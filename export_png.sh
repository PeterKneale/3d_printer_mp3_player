#!/usr/bin/env bash
# Parameterised OpenSCAD camera render of the jukebox.
set -euo pipefail

model="${1:-jukebox.scad}"
out="${2:-preview.png}"

scad_args=(-D 'part="assembly"' -D 'explode=20')

# image
img_w=900
img_h=700

# camera target: the point the camera looks at (model coordinates, mm)
look_x=0
look_y=0
look_z=54

# camera orientation, degrees
#   rot_x: pitch. 90 = side on, 65 = looking down at 25 degrees
#   rot_y: roll, almost always 0
#   rot_z: yaw. 0 looks at the grille face, 45 is a three-quarter view
rot_x=68
rot_y=0
rot_z=30

# camera distance from the target, mm. Bigger = zoomed out
dist=370

openscad -o "$out" \
  --imgsize="${img_w},${img_h}" \
  --camera="${look_x},${look_y},${look_z},${rot_x},${rot_y},${rot_z},${dist}" \
  "${scad_args[@]}" \
  "$model"

echo "done: $out"
