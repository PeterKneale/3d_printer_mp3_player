# Personal jukebox enclosure

Parametric OpenSCAD enclosure for a Jaycar-parts MP3 jukebox. Open `jukebox.scad` and use the
OpenSCAD Customizer (Window > Customizer), or override any variable from the CLI with `-D`.

Current size: **86.8 x 42.8 x 87 mm**. Every render echoes the real size and the resolved PCB
mount positions, so check the console after any change.

![Rotating preview](preview.gif)

Rebuild the preview with `./export_gif.sh`, or a single still with `./export_png.sh`.

## Bill of materials

| Part                                     | Jaycar code | Modelled as                              |
| ---------------------------------------- | ----------- | ---------------------------------------- |
| MP3 player module with button controls   | XC3748      | 69 x 32 mm bare board, see below         |
| All purpose speaker, 57 mm, 8 ohm        | AS3000      | 57 mm dia, 20 mm deep, 2.5 mm rim        |
| Red miniature pushbutton, SPST momentary | SP0710 x3   | 7 mm panel cutout                        |
| M3 x 10 self-tapping screws              |             | 4 off, lid                               |
| M3 x 6 self-tapping screws               |             | 4 off, speaker ring. Not 8 mm, see below |
| M2 screw                                 |             | 2 off, PCB                               |

## Building the STLs

`make-stls.sh` renders into `stl/`, keeping each render's console output in `stl/logs/`. It resolves
the parametric sizes first and prints them, refuses to build if an override is bad, and fails on any
OpenSCAD warning or a non-manifold result, so a run that reports `ok` is a run you can slice.

```sh
./make-stls.sh          # body, lid, speaker_ring  the three printed parts
./make-stls.sh plate    # all three on one bed, 177 x 112 mm, needs a 200 bed
./make-stls.sh --help
```

Trailing arguments pass straight to openscad, so variants build the same way:

```sh
./make-stls.sh -D 'pcb_w=77' -D 'pcb_d=33'
./make-stls.sh plate -D 'grille_style="rings"' -D 'pcb_flip=false'
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

Three parts: `body`, `lid` and `speaker_ring`. Beyond those, `part="print_plate"` puts all three on
one bed, `part="assembly"` is the preview and `part="none"` emits nothing so the file can be
`include`d as a library. Any single part renders on its own with
`openscad -o x.stl -D 'part="lid"' jukebox.scad`.

No supports needed: the body prints open side up, the lid and ring print flat.
0.2 mm layers, 3 perimeters. The grille bridges over 4 mm holes, which prints clean.

## Size, and how to shrink it

`want_w` / `want_d` / `want_h` are a request, not a promise: the shell grows past them whenever the
contents need the room. Two things push it past 80 x 40 x 35.

- **Width.** The board plus its jack and header overhangs is 78.7 mm of stuff in a row.
- **Height.** A 57 mm speaker needs a panel at least 63 mm across in *both* directions. On the
  front face that sets the height, and the electronics bay below it adds the rest.

| Change                                                     | Result           |
| ---------------------------------------------------------- | ---------------- |
| as shipped                                                 | 86.8 x 42.8 x 87 |
| `-D 'pcb_over_right_f=0.015'`, headers trimmed flush       | 81.1 x 42.8 x 87 |
| `-D 'speaker_d=40' -D 'speaker_depth=12'`                  | 86.8 x 42.8 x 70 |
| both of the above                                          | 81.1 x 42.8 x 70 |
| `-D 'speaker_face="top"'`, speaker fires up out of the lid | 86.8 x 88.3 x 44 |
| top-firing 40 mm speaker                                   | 86.8 x 71.3 x 36 |

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

**Through the card slot, box shut.** `sd_slot` is on by default: a 13 x 3.2 mm letterbox in the
wall the holder faces, on the card plane. `pcb_flip = true` (the default) turns the board 180
degrees so that wall is the **back**, keeping the slot off the show face and putting the jack and
USB on the right wall instead of the left. Set `pcb_flip = false` to have it the other way round,
card slot in the front face under the grille. The card ends up about 4.5 mm inside the opening, so
expect to use a fingernail or tweezers rather than fingertips. `sd_gap` sets that distance: smaller
brings the card closer to the outside but crowds the USB relief against the wall corner.

**By lifting the board out.** Lid off, two M2 screws out, board up, holder underneath. Always
works, needs no slot.

One knock-on: the holder overhangs the seat rail on the card side, so that rail is interrupted over
`sd_span` and the board is carried by the rest of it. The two screw posts land at 5.7 mm and
65.1 mm from the jack end, clear of the 15.2 to 32.3 mm the holder occupies.

## Assembly

1. Drop the speaker into the collar on the inside of the front wall, magnet inwards.
2. Lay the retaining ring over the rim and drive 4 M3 x 6 into the bosses. The ring clamps the rim
   against the wall, and `speaker_flange_t` is the measured 2.5 mm rim, so the ring lands flush on
   the boss tops and presses the rim home. **Use 6 mm, not 8 mm.** The screw head bears 5.5 mm above
   the wall's inner face and the wall is 2.4 mm thick, so 6 mm engages 3.0 mm of plastic and leaves
   1.9 mm of wall, while 8 mm reaches 0.1 mm past the outside and dimples the front face.
3. Drop the board between the two edge rails, jack and USB end towards their wall openings, and
   fix it with 2 M2 screws into the posts. The board holes scale to about 3.7 mm in the photo, so
   an M2 head will pull straight through: use a washer, or step up to M3 and set
   `pcb_screw_d = 2.6`.
4. Wire the three pushbuttons across the three tact switches you need, see below. Mount the buttons
   in the lid and fit their nuts. The lid is thinned to `button_panel_t` (2 mm) around each hole so
   the nuts still reach the thread.
5. Speaker leads go to the S-OUT pair on the header end.
6. Drop the lid onto its ledge and fix with 4 screws.

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

## Parameters

Every dimension below has been confirmed against the real parts on a printed enclosure. They are
here because they are what you change if you build this with a different board or speaker.

- `pcb_w`, `pcb_d` - 69 x 32, measured. Everything else scales off them.
- `pcb_connectors` - the two openings in the jack-end wall. Positions along the wall came off the
  product photo and the heights were estimated, since a top-down photo cannot show how high the jack
  axis or the USB shell sit, but both were confirmed on the printed part. The last field is the
  outer relief depth, which is what lets a chunky USB cable seat.
- `pcb_mount` - `both` (default) is rails plus screw posts, and the rails alone hold the board if
  the posts turn out to be wrong.
- `pcb_flip` - which wall the card slot and the connectors land on. See above.
- `speaker_flange_t` - rim thickness, measured at 2.5 mm. Too small and the ring will not clamp,
  too large and it crushes the cone.
- `button_hole_d` - 7.2 mm, from Jaycar's 7 mm cutout for this pushbutton family plus fit. Check
  yours with calipers, the SP07xx bushings vary.
- `grille_style` - `hex`, `dots`, `rings` or `slots`.
- `button_labels` - engraved 0.6 mm into the lid. Set `label_depth = 0` to drop them.
- `panel_cutouts` - extra openings in absolute box coordinates, for anything the connector list
  does not cover.
- `feet` - 4 recesses in the base for stick-on rubber feet.

## Layout

Front face carries the grille, upper middle, and nothing else. Electronics bay is the space
underneath it: board flat on the floor, jack and micro USB out the right wall, pin headers in the
clearance at the left, microSD slot in the back wall. Lid is the top face, drops onto an internal
ledge and takes the three buttons in one row across the width.
