# Personal jukebox enclosure

Parametric OpenSCAD enclosure for a Jaycar-parts MP3 jukebox. Open `jukebox.scad` and use the
OpenSCAD Customizer (Window > Customizer), or override any variable from the CLI with `-D`.

Current size: **86.8 x 42.5 x 91.6 mm**. Every render echoes the real size and the resolved PCB
mount positions, so check the console after any change.

![Rotating preview](preview.gif)

Rebuild the turntable with `./export_gif.sh`. `./export_png.sh` writes the still above and a set
of straight-on views to [images/](images): front, back, left, right, top, bottom and an exploded
three-quarter.

## Contents

- [Personal jukebox enclosure](#personal-jukebox-enclosure)
  - [Contents](#contents)
  - [Bill of materials](#bill-of-materials)
  - [Building the STLs](#building-the-stls)
  - [Board size](#board-size)
  - [Parts to print](#parts-to-print)
  - [The split shell](#the-split-shell)
  - [The base insert](#the-base-insert)
  - [Size, and how to shrink it](#size-and-how-to-shrink-it)
  - [Changing the music](#changing-the-music)
  - [Assembly](#assembly)
  - [Wiring the buttons](#wiring-the-buttons)
  - [Filling the card from YouTube](#filling-the-card-from-youtube)
  - [Parameters](#parameters)
  - [Layout](#layout)
  - [Views](#views)

## Bill of materials

| Part                                     | Jaycar code | Modelled as                              |
| ---------------------------------------- | ----------- | ---------------------------------------- |
| MP3 player module with button controls   | XC3748      | 69 x 32 mm bare board, see below         |
| All purpose speaker, 57 mm, 8 ohm        | AS3000      | 57 mm dia, 20 mm deep, 2.5 mm rim        |
| Red miniature pushbutton, SPST momentary | SP0710 x3   | 7 mm panel cutout                        |
| M3 x 10 self-tapping screws              |             | 8 off, 4 lid and 4 base                  |
| M3 x 6 self-tapping screws               |             | 4 off, speaker ring. Not 8 mm, see below |
| M2 screw                                 |             | 2 off, PCB                               |
| Second filament, any colour              |             | the raised button labels                 |

## Building the STLs

`make-stls.sh` renders into `stl/`, keeping each render's console output in `stl/logs/`. It resolves
the parametric sizes first and prints them, refuses to build if an override is bad, and fails on any
OpenSCAD warning or a non-manifold result, so a run that reports `ok` is a run you can slice.

```sh
./make-stls.sh          # the six parts loose, to stl/
./make-stls.sh plate    # the same six laid out on the bed, to stl/plate/, 177 x 191 mm
./make-stls.sh --help
```

Trailing arguments pass straight to openscad, so variants build the same way:

```sh
./make-stls.sh -D 'pcb_w=77' -D 'pcb_d=33'
./make-stls.sh plate -D 'button_labels=["<<","||",">>"]'
```

Set `OPENSCAD=/path/to/openscad` if it is not found automatically.

## Board size

The bare board is **69 x 32 mm**, measured with calipers. The catalogue 77 x 33 x 8 mm is the
envelope: the header pins overhang one end and the audio jack the other, and 8 mm is the height over
the components on a 1.6 mm PCB. Keyestudio sell the same OEM module and publish the same three
figures in a dimension diagram, which is where that convention shows.

Two product photos measured independently agreed with the calipers to 1.3%, both putting the 4-pin
UART header at 94.0 px across three 2.54 mm pitches and the board rectangle at aspect 2.14 where
77 x 33 would be 2.33. The remaining feature positions come from those photos, held as fractions of
the board outline, so they rescale with `pcb_w` and `pcb_d`. Correct those two and the rails, screw
posts, card slot and connector openings all follow.

## Parts to print

```sh
./make-stls.sh parts
```

Six parts: `body`, `panel`, `lid`, `labels`, `base` and `speaker_ring`. Each has one job. The body
is walls and openings, the panel is the show face and the speaker, the base carries the board, the
lid carries the buttons, the labels are the writing.

No supports needed. Both shell halves print on their backs, which is their largest face and puts the
grille and the card slot flat on the bed instead of up a wall. Everything else prints flat.
0.2 mm layers, 3 perimeters.

### A colour per part

`./make-stls.sh plate` writes the same six parts to `stl/plate/`, each already rotated into its
print orientation and moved to its own spot on a 177 x 191 mm bed. Load all six into the slicer at
once and they arrive as separate objects, correctly placed, so you can give the front, the back, the
lid, the base and the writing whatever filament you like. `labels` lands exactly on the lid's top
face, which makes the raised PREV/PLAY/NEXT a colour change three layers from the end rather than a
second object to align.

For a single colour it makes no difference: print the same six, or render `part="print_plate"` for
one merged solid of the whole bed.

`part="assembly"` is the preview and `part="none"` emits nothing so the file can be `include`d as a
library. Any single part renders on its own with `openscad -o x.stl -D 'part="lid"' jukebox.scad`,
and adding `-D on_plate=true` puts it where the plate would.

## The split shell

The front comes off as its own part. Without it the speaker ring is unbuildable: its 4 screws face
backwards down the length of a shut box and no screwdriver reaches them past the opposite wall. With
the panel loose you lay it face down on the bench, drop the speaker in and drive the screws straight
down.

The seam is a plane across the box, placed automatically at `split_clear` in front of the frontmost
wall opening so no connector cutout is ever cut in half. On the shipped numbers that puts it 6.9 mm
back from the front face, which the render echoes on every build:

```
split seam at y -14.35, front panel 6.9 mm deep
```

Only the walls and the lid ledge are cut. Everything standing inside keeps one part whole and
reaches past the seam into open space: the speaker mount and the front post of each pair go with the
panel. That is what holds the box together. Each corner has a lid post above and a base post below,
the front pair of both sets belongs to the panel, so the lid screw pulls the panel down from above
and the base screw pulls it in from below. Nothing else is needed, and there are no fasteners on the
show face.

## The base insert

The bottom is a plate with the same footprint and the same job as the lid: four M3 up into the base
posts. The board lives on it, on two short rails and its two M2 screws, so the board and its wiring
come out of the box as one piece.

Unlike the lid it has no ledge, and cannot have one. The board rides in on the plate from below, so
it has to pass whatever a ledge would leave, and the board sits 1.5 mm off the back wall with the
jack tip 0.3 mm off the right. Any ledge wide enough to be a ledge fouls it. The four post ends are
the seat instead, which is a cleaner stop anyway.

One thing does cost size. The base posts can only be as tall as the space under the board, because
the board and its overhangs fill the cavity in plan with nothing to spare. That is what sets
`pcb_seat_h`, 8 mm rather than the 4 mm the card holder alone would need, and it is why the box is
91.6 mm tall rather than 87. Anything hanging below the board has to miss the four corners; the card
holder does.

The rails are half the board's length so they stay clear of those corners, and the card-side one is
interrupted again where the holder hangs down, which leaves it shorter still and off to one side.
Between them and the two screws the board cannot rock, which is all they are for.

## Size, and how to shrink it

There is no requested size. The shell is whatever the contents need and nothing else, so the only
way to shrink it is to give it less to hold. Three things set it.

- **Width.** The board plus its jack and header overhangs is 79.7 mm of stuff in a row.
- **Height.** A 57 mm speaker needs a panel at least 63 mm across in *both* directions. On the
  front face that sets the height, and the electronics bay below it adds the rest.
- **Depth.** Not the board, the front panel. Every wall opening is placed off the board and the
  board off the back wall, so the deeper the box the further the openings sit from the front. The
  depth is whatever leaves the panel enough tray to hold the speaker bosses in front of the jack.

| Change                                                | Result             |
| ----------------------------------------------------- | ------------------ |
| as shipped                                            | 86.8 x 42.5 x 91.6 |
| `-D 'pcb_over_right_f=0.015'`, headers trimmed flush  | 81.1 x 42.5 x 91.6 |
| `-D 'speaker_d=40' -D 'speaker_depth=12'`             | 86.8 x 42.5 x 74.6 |
| both of the above                                     | 81.1 x 42.5 x 74.6 |
| `-D 'pcb_seat_h=5'`, shorter base posts               | 86.8 x 42.5 x 88.6 |

## Changing the music

The microSD holder is on the **underside** of the board, and the enclosure is built around what
that implies. Measured off the Keyestudio underside photo at the same 12.336 px/mm: the holder is
17.1 x 15.9 mm, sits 15.2 to 32.3 mm from the jack end, and its contact leads are along the edge
away from the card mouth, so the card slides in and out along the board's short axis. The mouth is
only **0.6 mm inside one long edge**, which means the card can come straight out through a wall
without the board moving.

So there are three ways to change music, and you will mostly use the first.

**Over micro USB, box shut.** The module presents the card to a computer over its micro USB port.
Plug in, drag files, unplug. The opening is stepped, 13 x 9 mm through the wall with a 16 x 12 mm
relief 1.4 mm deep outside, because the receptacle sits about 5.5 mm behind the outer face while a
micro-B tongue is only about 6 mm long. Without the relief a cable with a fat overmould bottoms out
before it seats. Confirmed with a real cable on the printed part. Check whether that port also
carries power: the header pins marked G and V are the documented 5 V input.

**Through the card slot, box shut.** A 13 x 3.2 mm letterbox in the
wall the holder faces. The board sits turned 180 degrees so that wall is the **back**, which keeps
the slot off the show face and puts the jack and USB out the right wall. The card ends up about
4.5 mm inside the opening, so
the mouth is funnelled: `sd_flare` opens it out 3 mm all round at the surface and tapers back to
13 x 3.2 over `sd_flare_depth`. That guides a microSD in without hunting for the slot and gets a
fingertip part of the way to the card, though the last of it still wants a fingernail. `sd_gap` sets
that distance: smaller brings the card closer to the outside but crowds the USB relief against the
wall corner.

**By taking the base off.** Four screws out of the bottom and the base plate comes away with the
board still bolted to it, holder underneath. Always works, needs no slot.

One knock-on: the holder overhangs the seat rail on the card side, so that rail is interrupted over
`sd_span` and the board is carried by the rest of it. The two screw posts land at 5.7 mm and
65.1 mm from the jack end, clear of the 15.2 to 32.3 mm the holder occupies.

## Assembly

1. Lay the panel face down on the bench and drop the speaker into the collar, magnet upwards.
2. Lay the retaining ring over the rim and drive 4 M3 x 6 into the bosses. The ring clamps the rim
   against the wall, and `speaker_flange_t` is the measured 2.5 mm rim, so the ring lands flush on
   the boss tops and presses the rim home. **Use 6 mm, not 8 mm.** The screw head bears 5.5 mm above
   the wall's inner face and the wall is 2.4 mm thick, so 6 mm engages 3.0 mm of plastic and leaves
   1.9 mm of wall, while 8 mm reaches 0.1 mm past the outside and dimples the front face.
3. Sit the board on the base plate's two rails, jack and USB end towards the right,
   and fix it with 2 M2 screws into the posts. The board holes scale to about 3.7 mm in the photo,
   so an M2 head will pull straight through: use a washer, or step up to M3 and set
   `pcb_screw_d = 2.6`. Everything from here on is wired with the board on the loose plate.
4. Wire the three pushbuttons across the three tact switches you need, see below. Mount the buttons
   in the lid and fit their nuts. The lid is thinned to `button_panel_t` (2 mm) around each hole so
   the nuts still reach the thread.
5. Speaker leads go to the S-OUT pair on the header end. Leave slack: the panel and the base plate
   have to come apart again to get the box shut.
6. Offer the panel up to the shell and hold it there. It is loose until the screws go in.
7. Bring the base plate up under both, board first into the cavity, and drive 4 M3 x 10 into the
   base posts. The front two land in the panel and pull it home.
8. Drop the lid onto its ledge and drive 4 more. The front two land in the panel again, so between
   them the lid and the base are what hold the box shut.

## Wiring the buttons

The three switches you need are the whole right-hand column of the 2 x 3 grid: PRE- at the top,
NEXT/+ in the middle, PLAY/PAUSE at the bottom. Wire each panel button in parallel across the legs
of its onboard switch. Leave the onboard switches in place, nothing here is destructive and both
will work.

**Take one wire from each side of the switch, not two from the same side.** These are standard 6 mm
tact switches: 4 legs, measured at 7.2 mm apart across the body and 4.6 mm along it, and on this
board they stick out towards the jack end and the header end. Four legs but only two terminals,
because each terminal has two legs for mechanical stability, so two of the four are already shorted
inside the switch.

```
   jack end            header end
        1 o----------o 3        1+2 are one terminal
          |  6x6mm   |          3+4 are the other
        2 o----------o 4        wire 1+4, or 2+3
```

Pick the two **diagonally opposite** legs and you cannot get it wrong: diagonal legs fall in
different terminals under either possible internal pairing, so you do not need to know which
convention your switches follow. Two legs from the same side is a permanent short, and the module
will read that button as held down from the moment it powers up.

With a multimeter it is a ten second check: the two legs on one side should beep with the button
untouched, and across the body should be open until pressed.

**Check for a common ground first.** The YX5200 pulls its button inputs up and switches them to
ground, so one side of every button is very likely a shared rail. Probe continuity between a leg of
PLAY/PAUSE and a leg of NEXT/+. If they beep, you need 4 wires rather than 6: one common return
plus three signals.

Practicalities, because the pads are 0.6 to 0.9 mm fillets:

- 28 to 30 AWG stranded or enamelled wire. Thicker wire levers the leg off the pad.
- Tin the leg, tin the wire, tack them together, do not dwell.
- Hot glue over each joint once tested. These wires get tugged every time the lid comes off, and a
  lifted pad on this board is not really repairable.
- Make the wires **150 to 200 mm**, not the 90 mm the box needs. The buttons live in the lid and the
  board is screwed to the floor, so you want enough slack to lift the lid clear and set it beside
  the box while you work.
- The SP0710 has two solder tags and no polarity, so either wire to either tag.

## Filling the card from YouTube

`yt-dlp` pulls the audio down and `rsync` is what puts it on the card without Apple metadata riding
along. Keep a staging folder on the Mac, treat the card as a copy of it, and the card never
accumulates anything you did not put there.

```sh
brew install yt-dlp ffmpeg
```

`get-music.sh` wraps the download. The public domain Famous Speeches list is a fair example,
84 tracks:

```sh
./get-music.sh -n 'https://www.youtube.com/watch?v=Y0t-RqjMH-A&list=PL4A1446D924B9C895'
./get-music.sh    'https://www.youtube.com/watch?v=Y0t-RqjMH-A&list=PL4A1446D924B9C895'
```

`-n` lists the tracks without downloading. `-i 6` or `-i 1-10` takes only those positions, `-1`
takes just the linked video rather than its playlist, `-o DIR` changes the destination from
`~/Music/mp3card` and `-m` writes title and artist tags, which YouTube sources otherwise arrive
without. `./get-music.sh -h` has the rest.

Underneath it is one yt-dlp call:

```sh
yt-dlp -x --audio-format mp3 --restrict-filenames \
  -o "$HOME/Music/mp3card/%(playlist_index&{:02d}-|)s%(title)s.%(ext)s" URL
```

A `watch?v=...&list=...` URL takes the whole playlist, because yt-dlp follows the `list` parameter
whether or not `&index=` is on the end. The conditional `playlist_index` numbers playlist tracks
and leaves a lone video unnumbered, where a plain `%(playlist_index)02d` would name it `NA-`.
`--restrict-filenames` flattens the fullwidth quotes and colons YouTube titles carry, which a
FAT32 card and an ASCII-only player are both happier without.

ID3 tags are left alone. yt-dlp writes nothing of its own beyond an encoder string, so whatever
titles and artists the source carries survive onto the card. Pass `--embed-metadata` if you want it
to fill in tags the source left empty.

**The metadata to get rid of is Apple's.** FAT32 cannot store extended attributes, so a file
carrying one lands on the card with a second `._name` file beside it, and a player that indexes
every file it finds will list those as extra silent tracks. Strip them from the staging folder,
then copy with `rsync`, which does not carry attributes across unless you ask for `-E`:

```sh
xattr -cr ~/Music/mp3card              # drop quarantine and the rest
rsync -rt --delete --exclude='.DS_Store' --exclude='._*' --exclude='*.part' \
  ~/Music/mp3card/ /Volumes/MP3S/      # copy, attributes left behind
dot_clean -m /Volumes/MP3S             # sweep any sidecar that still appeared
diskutil eject /Volumes/MP3S
```

The three excludes are all things that turn up in the staging folder and have no business on the
card. Opening the folder in Finder leaves a `.DS_Store`, and a download that gets interrupted
leaves a `.part` behind, which `--delete` alone will happily mirror across.

`--delete` makes the card an exact copy of the folder, so dropping a track locally drops it from the
card as well. Both `rsync` and `dot_clean` will say they cannot read `.Trashes`. That is a directory
macOS recreates on every mount and guards, the message is harmless and `dot_clean` still exits 0.

Plain `cp` is the one to avoid. It copies every attribute, and even `cp -X` drags
`com.apple.quarantine` across, which is enough on its own to produce a sidecar.

## Parameters

Every dimension below has been confirmed against the real parts on a printed enclosure. They are
here because they are what you change if you build this with a different board or speaker.

- `pcb_w`, `pcb_d` - 69 x 32, measured. Everything else scales off them.
- `pcb_connectors` - the two openings in the jack-end wall. Positions along the wall came off the
  product photo and the heights were estimated, since a top-down photo cannot show how high the jack
  axis or the USB shell sit, but both were confirmed on the printed part. The last field is the
  outer relief depth, which is what lets a chunky USB cable seat.
- `pcb_seat_h` - board underside above the base plate, and so the height of the base screw posts.
  Below about 5 mm the base screws have nothing to bite and the render says so.
- `pcb_rail_len_f` - rail length as a fraction of the board, 0.5. Long enough to stop the board
  rocking, short enough to miss the base posts in the corners.
- `speaker_flange_t` - rim thickness, measured at 2.5 mm. Too small and the ring will not clamp,
  too large and it crushes the cone.
- `button_hole_d` - 7.2 mm, from Jaycar's 7 mm cutout for this pushbutton family plus fit. Check
  yours with calipers, the SP07xx bushings vary.
- `button_labels` - raised `label_h` off the lid and printed as their own part, `labels`.
- `split_clear` - the gap the seam keeps in front of the nearest wall opening. `split_max_depth`
  caps how deep the panel gets and `split_fit` is the clearance where the panel's posts enter the
  shell.
- `sd_flare` - how far the funnel around the card slot opens out, and `sd_flare_depth` how far back
  it tapers. Set `sd_flare = 0` for a plain letterbox.

## Layout

Front face carries the grille, upper middle, and nothing else. It is a separate part, 6.9 mm deep,
seamed just in front of the connector openings. Electronics bay is the space behind it: board flat
on the base plate, jack and micro USB out the right wall, pin headers in the clearance at the left,
microSD slot in the back wall. Lid and base are matching inserts top and bottom, each screwing into
four posts, and the front post of each set is on the panel, so both inserts help hold the panel on.
The lid also takes the three buttons in one row across the width.

## Views

Regenerate all of these with `./export_png.sh`.

| | |
| --- | --- |
| ![Front](images/front.png) front, grille and panel | ![Back](images/back.png) back, funnelled card slot |
| ![Right](images/right.png) right, jack and micro USB | ![Left](images/left.png) left, plain |
| ![Top](images/top.png) top, lid and buttons | ![Bottom](images/bottom.png) bottom, feet and the seam |

![Exploded](images/exploded.png)
