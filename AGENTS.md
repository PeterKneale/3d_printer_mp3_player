# Working in this repo

A parametric OpenSCAD enclosure for a personal jukebox. `jukebox.scad` is the only
source. Everything in `stl/` and `images/`, plus `preview.png` and `preview.gif`, is
generated from it. `README.md` is written by hand and has to be kept in step.

## Commands

```sh
./make-stls.sh                 # part_*.stl, the four parts in model coordinates
./make-stls.sh one-colour      # plate_one_colour.stl, one bed
./make-stls.sh two-colour      # plate_two_colour.stl + plate_lid.stl
./export_png.sh                # preview.png and images/
./export_gif.sh                # preview.gif, needs ffmpeg
```

Trailing arguments pass straight to openscad, so `./make-stls.sh parts -D 'pcb_w=77'`
works. Renders are fast, well under a second each, so regenerate freely.

After any change to the model, regenerate the STLs and the images together. A commit
carrying a geometry change and stale renders is the usual mistake here.

## OpenSCAD traps worth knowing

- **openscad is not on PATH on macOS.** `make-stls.sh` falls back to
  `/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD`. The other two scripts expect it
  on PATH, so alias it before running them.
- **A misspelt `-D` override only warns, and openscad still exits 0** with a quietly
  wrong STL. `make-stls.sh` does a `part="none"` probe first and greps the log for
  `ERROR|WARNING` so a bad override fails before any real work. Keep that guard.
- **Preview mode fills the grille holes** with whatever solid sits behind them, so every
  PNG is a full CGAL `--render`. Do not swap it for the faster preview.
- **The last assignment in a scope wins.** `include <jukebox.scad>` then `part = "none"`
  gives you the modules with the model emitting nothing of its own. `export_png.sh` uses
  this for the two colour lid view.
- Manifold status only appears in the log for CGAL results, so absence of `Status:` is
  not a failure. `make-stls.sh` already handles that distinction.

## How the model is organised

- `part = "..."` at the top, dispatched by the `if/else` chain at the bottom. Valid
  values are listed in the comment on that line.
- Parameters up top in labelled blocks, then a derived block, then modules, then the
  plate layouts, then dispatch. Nothing measured belongs below the derived block.
- **The box is sized by its contents.** `out_w`, `cav_d` and friends are computed from
  the component dimensions. Never hardcode a shell dimension; change the component
  parameter it derives from.
- The `echo()` block prints the resolved geometry on every render, and `make-stls.sh`
  reprints it at the end. That output is the thing to check after a parameter change,
  before any filament is spent.
- The model self-checks with `echo("WARNING: ...")` for shallow panels, thin seam walls,
  overhanging button relief and mismatched icon rows. Add a warning rather than a
  comment when a parameter has a range it must stay inside.

## Design decisions that constrain edits

- The shell splits so the front panel comes off. Only the walls and ledges are cut at
  the seam. The speaker mount and the front post of each pair stay whole and reach past
  it.
- Two print setups exist because a filament change is a height, not a part. On a shared
  bed the change at the label layer would also cut through the body, panel and ring, so
  the lid gets a bed of its own.
- Lid icons are additive relief, not cut. They share a normal with the face beneath, so
  they do not shade in a one colour render, which is why `images/lid.png` is drawn in
  the two print colours.
- Screw heads recess into a flat bore, not a countersink, because a countersunk M3 is not sold in a
  hobby pack in Australia. `head_style = "cone"` restores the old behaviour. `floor_t` and `lid_t`
  are 3.6 mm so the head fits with 1.0 mm to spare and both land on a layer boundary at 0.2 and
  0.3 mm.
- No supports anywhere, 0.2 mm layers. Body prints on its floor, panel on its face. Any
  new feature has to hold that.

## Conventions

- No em dashes, no Oxford commas, in the README and in comments.
- Comments explain what the geometry cannot say: a measured value's provenance, a
  reason a reader would otherwise get it wrong. Match the density already in the file.
- Commit subjects are imperative and describe the change to the object, for example
  "Split the shell, add a base insert, and cut the parameters back".
- `stl/logs/` is per render console output and is gitignored. Read it when a part fails.
