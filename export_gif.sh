#!/usr/bin/env bash
# Renders the jukebox from a full turntable sweep and builds a looping GIF.
# A 360 degree sweep wraps on itself, so no ping-pong reversal is needed.
# Intermediate frames go in a local temp folder that is cleaned up on exit.
#
# Usage:
#   ./export_gif.sh                      # defaults below
#   ./export_gif.sh jukebox.scad my.gif
#
# Requires: openscad, ffmpeg (brew install ffmpeg)

set -euo pipefail

model="${1:-jukebox.scad}"
out="${2:-preview.gif}"

scad_args=(-D 'part="assembly"' -D 'explode=20')

# ---------- image ----------

img_w=700
img_h=560

# ---------- camera ----------

# look-at point, model coordinates in mm. Half the box height so the sweep
# pivots around the product rather than the bed.
look_x=0
look_y=0
look_z=54

# pitch: degrees looking down at the model (90 = side-on, 68 = slightly above)
rot_x=68
rot_y=0

# yaw: one full turn at a fixed step, so the last frame leads back to the first
step=5
dist=370
fps=15

# ---------- checks ----------

command -v openscad >/dev/null || {
    echo "openscad not on PATH. On macOS try:" >&2
    echo '  alias openscad=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD' >&2
    exit 1
}
command -v ffmpeg >/dev/null || {
    echo "ffmpeg not found: brew install ffmpeg" >&2
    exit 1
}
[[ -f "$model" ]] || { echo "model not found: $model" >&2; exit 1; }

tmpdir="$(mktemp -d ./turntable_frames.XXXXXX)"
trap 'rm -rf "$tmpdir"' EXIT

# ---------- render ----------

n=$((360 / step))
echo "rendering $n frames of $model into $tmpdir ..."

i=0
while [[ $i -lt $n ]]; do
    yaw=$((i * step))
    frame="$(printf '%s/frame_%03d.png' "$tmpdir" "$i")"
    openscad -o "$frame" \
        --imgsize="${img_w},${img_h}" \
        --camera="${look_x},${look_y},${look_z},${rot_x},${rot_y},${yaw},${dist}" \
        "${scad_args[@]}" \
        "$model" 2>/dev/null
    printf '  frame %d (yaw %d)\n' "$i" "$yaw"
    i=$((i + 1))
done

# ---------- assemble ----------

# split + palettegen/paletteuse gives an optimised 256 colour palette so the
# flat shaded faces do not band. stats_mode=diff weights the moving pixels.
echo "building $out ..."
ffmpeg -v error -framerate "$fps" -i "$tmpdir/frame_%03d.png" \
    -filter_complex "[0:v]split[g1][g2];[g1]palettegen=stats_mode=diff[pal];[g2][pal]paletteuse" \
    -loop 0 -y "$out"

echo "done: $out ($n frames)"
