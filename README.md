# Personal jukebox enclosure

A printed box for an MP3 module, a 57 mm speaker and three buttons. It has five printed parts.

> **AI wrote this project.** Claude made the OpenSCAD model, the scripts and this README. Measure
> your parts. Compare them to the dimensions in this README before you print.

![Rotating preview](preview.gif)

| | |
| --- | --- |
| ![Front](images/front.png) **Front**: the grille | ![Back](images/back.png) **Back**: the microSD slot |
| ![Right](images/right.png) **Right**: the jack and the micro USB port | ![Left](images/left.png) **Left**: no openings |
| ![Top](images/top.png) **Top**: the lid and three buttons | ![Bottom](images/bottom.png) **Bottom**: the base plate and four screws |

![Exploded](images/exploded.png)

The box is **86.8 x 42.5 x 91.6 mm**. It stands upright. The speaker points forward.

## Contents

- [Bill of materials](#bill-of-materials)
- [Screws](#screws)
- [Feet](#feet)
- [Print the parts](#print-the-parts)
- [How the box comes apart](#how-the-box-comes-apart)
- [Assemble the box](#assemble-the-box)
- [Wire the buttons](#wire-the-buttons)
- [Change the music later](#change-the-music-later)
- [Put music on the card](#put-music-on-the-card)
- [Build the STL files](#build-the-stl-files)
- [Use different parts](#use-different-parts)
- [Make the renders again](#make-the-renders-again)

## Bill of materials

| Part | Jaycar code | Qty | AUD |
| --- | --- | --- | --- |
| Arduino Compatible MP3 Audio Player | XC3748 | 1 | 17.50 |
| 57 mm All Purpose Replacement Speaker | AS3000 | 1 | 4.95 |
| Red Miniature Pushbutton, SPST momentary | SP0710 | 3 | 6.00 |
| Rubber Feet, small, stick on, pack of 4 | HP0815 | 1 | 2.50 |
| | | | **30.95** |

These prices are the Jaycar list prices in August 2026. The prices change.

You also need a microSD card and 2 m of wire. Use wire of 28 AWG to 30 AWG. You also need
approximately 101 g of filament.

## Screws

The model needs 14 screws. The head type is as important as the length. Jaycar does not sell the
correct heads, so buy these screws from a fastener supplier.

| Qty | Size | Head | Use |
| --- | --- | --- | --- |
| 8 | M3 x 10 | countersunk, 90 degrees | 4 in the lid, 4 in the base |
| 4 | M3 x 6 | pan | the speaker ring |
| 2 | M2 x 8 | pan | the board |

The lid and the base have a conical recess at each screw. A countersunk head seats in this recess
approximately 1 mm below the surface. A pan head cannot seat in a cone. A pan head stands
approximately 1.6 mm above the surface. This is a problem at the base, because a rubber foot goes
over each screw. A foot cannot stick to a surface that has a screw head above it.

The speaker ring and the board both have a plain hole at each screw. The head must bear on a flat
face, so use a pan head.

All four sizes cut their own thread in the plastic. The holes in the model are the correct pilot
diameters. Screws for plastic hold better than machine screws, but machine screws also work.

## Feet

The bottom of the base plate is flat. There are no recesses for the feet.

Put one rubber foot over each of the four base screws. The foot is 12 x 12 mm and the screw head is
5.8 mm, so the foot hides the screw. The screw head must be flush. Refer to the section above.

The feet do two things. They stop the box when it slides. They also separate the box from the bench,
so the bench does not amplify the vibration of the speaker.

The feet do not stop the box when it falls over. The box is 91.6 mm tall and 42.5 mm deep. The
speaker is the heaviest part and its centre is 54 mm above the bench. The box falls over at
approximately 21 degrees from vertical. A pull on a headphone cable is enough. Put the box against a
wall, or add mass inside the base.

## Print the parts

```sh
./make-stls.sh plate
```

This command writes `stl/print_plate.stl`. The file contains all five parts. The script rotates each
part and puts it in position on a bed of **177 x 191 x 36 mm**. Any bed of 200 mm is large enough.

- **No part needs support material.** Both halves of the shell lie on their backs. This is the
  largest face of each half. It also puts the grille and the card slot flat on the bed.
- **Use 0.2 mm layers and 3 perimeters.** The plate is then 178 layers and approximately 101 g.
- **Use one colour.** No part needs a second colour.

You can also use 0.3 mm layers. No part on the plate needs 0.2 mm. The bed makes the finish of both
visible faces, because both faces lie against the bed. The only small vertical detail is the
lettering of 0.8 mm. At 0.3 mm the plate is 119 layers. First set `label_h = 0.9`. The letters are
then exactly three layers.

To get one STL file for each part, use `./make-stls.sh`.

| Part | Function | Volume |
| --- | --- | --- |
| `body` | the back wall, the side walls and all the openings | 36.2 cm³ |
| `panel` | the front face, the grille and the speaker mount | 23.3 cm³ |
| `base` | the bottom plate. It holds the board | 9.9 cm³ |
| `lid` | the top, the buttons and the labels | 8.5 cm³ |
| `speaker_ring` | it clamps the rim of the speaker | 3.4 cm³ |

## How the box comes apart

**The front is a separate part.** The four screws of the speaker ring point to the rear. In a closed
box, no screwdriver can reach them. Put the loose panel face down on the bench. Then you can turn
the screws from above.

**The lid and the base are a matched pair.** Each one has four screws. Each screw goes into a post in
a corner. Each corner has one post above and one post below. The front post of each pair is part of
the panel. Therefore the lid screw pulls the panel down. The base screw pulls the panel in.

**The board is bolted to the base plate.** Remove the base and the board and its wires come out
together. Two M2 screws and two short rails hold the board. The rails prevent movement of the board.

## Assemble the box

1. Put the panel face down on the bench. Put the speaker into the collar. The magnet must point up.

2. Put the speaker ring on the rim of the speaker. Install four M3 x 6 screws. The ring clamps the
   rim against the wall. **Do not use a longer screw. A longer screw comes through the front face.**

3. Put the board on the two rails of the base plate. The jack must point to the right. Install two
   M2 screws. The holes in the board are approximately 3.7 mm, so an M2 head can pull through the
   board. Use a washer, or change `pcb_screw_d` to 2.6 and use an M3 screw. Do all of the wire work
   with the board on the loose plate.

4. Wire the three buttons. Refer to the next section. Install the buttons in the lid. Install the
   nuts on the outside face. The lid is 2 mm thick at each hole, so the thread is long enough.

5. Solder the speaker wires to the S-OUT pair. This pair is at the header end of the board. Make
   these wires 150 mm to 200 mm long. You must separate the panel and the base plate again.

6. Hold the panel against the shell. It is loose until you install the screws.

7. Move the base plate up under the panel and the shell. Put the board into the cavity first.
   Install four M3 x 10 screws. The two front screws go into the panel and pull it into position.
   **Do not use a longer screw. A longer screw touches the board.**

8. Put the lid on the ledge. Install four more M3 x 10 screws. The two front screws go into the panel
   again. The lid and the base hold the box closed.

## Wire the buttons

The board has six tact switches in a grid of 2 x 3. Use the three switches in the right column.
**PRE-** is at the top. **NEXT/+** is in the middle. **PLAY/PAUSE** is at the bottom. Connect each
panel button in parallel with the legs of its switch. Do not remove the switches from the board.
Both switches then operate.

Each switch has four legs but only two terminals. Two legs connect to each terminal. Therefore two
of the four legs are already connected together in the switch.

```
   jack end            header end
        1 o----------o 3        1+2 are one terminal
          |  6x6mm   |          3+4 are the other
        2 o----------o 4        wire 1+4, or 2+3
```

**Connect one wire to each side of the switch. Do not connect two wires to the same side.** Use the
two legs that are diagonally opposite. These two legs are always in different terminals. Two wires on
the same side make a permanent short circuit. The module then reads that button as pressed.

Use a multimeter to check the switch. The two legs on one side show continuity. The two legs across
the body show an open circuit until you press the switch.

**Check for a common ground first.** The YX5200 connects each button input to ground. One side of
every button is probably a common rail. Check the continuity between a leg of PLAY/PAUSE and a leg of
NEXT/+. If they show continuity, you need four wires and not six. Use one common return and three
signal wires.

The pads are small. They are 0.6 mm to 0.9 mm.

- Use wire of 28 AWG to 30 AWG. Thicker wire can break the leg off the pad.
- Tin the leg. Tin the wire. Then solder them together. Do not apply heat for a long time.
- Put hot glue on each joint after you test it. You pull these wires each time you remove the lid.
  You cannot repair a pad that comes off this board.
- The button has two solder tags and no polarity. Connect either wire to either tag.

## Change the music later

There are three methods. You will use the first method most.

**Use the micro USB port. The box stays closed.** The module gives a computer access to the card
through this port. Connect the cable. Copy the files. Disconnect the cable. The opening has a step.
It is larger and shallower on the outside face, so a cable with a large moulding also seats. Check if
this port also supplies power to your module. The header pins marked G and V are the 5 V input.

**Use the card slot. The box stays closed.** The slot is in the back wall. It is 13 x 3.2 mm. The
mouth has a taper of 3 mm on all four sides, so a microSD card enters the slot easily. The card stops
4.5 mm inside the opening. Use a fingernail for the last part.

**Remove the base.** Lift off the four rubber feet. Remove four screws from the bottom. The plate,
the board and the card holder come out together. This method always works.

## Put music on the card

`yt-dlp` downloads the audio. `rsync` copies the files to the card. `rsync` does not copy the Apple
metadata. Keep a folder on the Mac. Make the card a copy of this folder. The card then holds only the
files that you put in the folder.

```sh
brew install yt-dlp ffmpeg
```

`get-music.sh` controls the download. This public domain playlist is an example. It has 84 tracks.

```sh
./get-music.sh -n 'https://www.youtube.com/watch?v=Y0t-RqjMH-A&list=PL4A1446D924B9C895'   # list only
./get-music.sh    'https://www.youtube.com/watch?v=Y0t-RqjMH-A&list=PL4A1446D924B9C895'   # download
```

Use `-i 6` or `-i 1-10` to select playlist positions. Use `-1` to get only the linked video. Use
`-o DIR` to change the destination from `~/Music/mp3card`. Use `-m` to write the title and artist ID3
tags, because YouTube files do not have them. Use `./get-music.sh -h` for the other options.

**You must remove the Apple metadata.** A FAT32 card cannot hold extended attributes. The card
therefore gets a second file with the name `._name` beside each file that has an attribute. A player
reads every file, so it shows these files as silent tracks.

```sh
xattr -cr ~/Music/mp3card              # remove the attributes
rsync -rt --delete --exclude='.DS_Store' --exclude='._*' --exclude='*.part' \
  ~/Music/mp3card/ /Volumes/MP3S/      # copy the files
dot_clean -m /Volumes/MP3S             # remove any file that remains
diskutil eject /Volumes/MP3S
```

`--delete` makes the card an exact copy of the folder. If you remove a track from the folder, the
next copy removes it from the card. The three excludes are files that occur in the folder. The card
does not need them. `rsync` and `dot_clean` both report that they cannot read `.Trashes`. macOS makes
this directory at each mount and protects it. This message is not a fault.

**Do not use `cp`.** It copies every attribute. `cp -X` also copies `com.apple.quarantine`. This
attribute alone makes a second file on the card.

## Build the STL files

You need this section only if you change the model. The `stl/` directory already has the files.

```sh
./make-stls.sh          # one STL file for each of the five parts
./make-stls.sh plate    # all five parts on one bed, in one STL file
./make-stls.sh --help
```

The script first calculates the dimensions and prints them. It stops if an override is not valid. It
also stops at an OpenSCAD warning, or if a part is not manifold. Therefore a part with the status
`ok` is correct. The script writes the output of each render to `stl/logs/`.

The script sends the arguments after the target to openscad:

```sh
./make-stls.sh -D 'pcb_w=77' -D 'pcb_d=33'
./make-stls.sh plate -D 'button_labels=["<<","||",">>"]'
```

Set `OPENSCAD=/path/to/openscad` if the script cannot find openscad. You can also open
`jukebox.scad` in the OpenSCAD application and use the Customizer. It is in the Window menu.

## Use different parts

The shell has no requested size. The size is the size that the contents need. To change the size,
change the contents. Three items control the dimensions.

- **Width.** The board, the jack and the header pins are 79.7 mm in a row.
- **Height.** A speaker of 57 mm needs a panel of 63 mm in both directions. This sets the height of
  the front face. The bay for the electronics adds the rest of the height.
- **Depth.** The front panel controls the depth, and not the board. The panel must hold the speaker
  bosses. It must also stay clear of the jack opening behind it.

| Change | Result |
| --- | --- |
| no change | 86.8 x 42.5 x 91.6 |
| `-D 'pcb_over_right_f=0.015'`, header pins cut flush | 81.1 x 42.5 x 91.6 |
| `-D 'speaker_d=40' -D 'speaker_depth=12'` | 86.8 x 42.5 x 74.6 |
| both of the changes above | 81.1 x 42.5 x 74.6 |
| `-D 'pcb_seat_h=5'`, shorter posts in the base | 86.8 x 42.5 x 88.6 |

**Start with the board.** The model uses a bare board of **69 x 32 mm**. The catalogue gives
77 x 33 mm. This is the envelope. It includes the header pins at one end and the jack at the other
end. The model holds each board feature as a fraction of the board outline. Therefore a correction to
`pcb_w` and `pcb_d` also moves the rails, the posts, the card slot and the connector openings.

These are the most useful parameters.

- `pcb_w`, `pcb_d`. The board is 69 x 32 mm. All other dimensions scale from these two.
- `pcb_connectors`. The two openings in the right wall. Each row gives the position along the wall,
  the height above the board, the size, the corner radius and the depth of the outer relief.
- `pcb_seat_h`. The height of the board above the base plate. This is also the maximum height of the
  posts in the base. Below approximately 5 mm the screws are too short and the render gives a warning.
- `pcb_rail_len_f`. The length of each rail as a fraction of the board. It is 0.5. The rails are long
  enough to hold the board and short enough to clear the posts in the corners.
- `speaker_flange_t`. The thickness of the rim, 2.5 mm. If the value is too small, the ring does not
  clamp the rim. If the value is too large, the ring damages the cone.
- `ring_t`. The thickness of the ring, 3 mm. The ring sits on the bosses, so this value sets the
  height of the screw head above the wall. If you change it, change the screw length.
- `button_hole_d`. The diameter of the hole, 7.2 mm. Measure your buttons. The bushing diameter is
  not the same on all buttons of this family.
- `button_nut_d`. The diameter of the nut. The nut sits on the **outside** face. `button_body_d` is
  the clearance below the lid. The model puts the lettering clear of the nut and not clear of the
  hole, because the nut is larger than the hole. A driver on the nut is larger again.
- `split_clear`. The distance between the seam and the nearest opening in a wall. No opening is ever
  cut in two. `split_fit` is the clearance where the posts of the panel enter the shell.
- `sd_flare`. The width of the taper at the card slot. `sd_flare_depth` is its depth. Set
  `sd_flare = 0` for a slot with no taper.

Each render prints the calculated dimensions. Read the console after each change.

```
outer  86.8433 x 42.5 x 91.6 mm
cavity 82.0433 x 37.7 x 85.6 mm
pcb 69 x 32, jack out 3.9537, headers out 6.7896 mm
pcb screw posts at [[-28.0485, -0.4896], [32.1264, 1.6096]] from board centre
sd card sits 4.5 mm inside the back wall
split seam at y -14.35, front panel 6.9 mm deep
print plate 176.537 x 191.2 mm
```

## Make the renders again

```sh
./export_png.sh     # preview.png and the six straight views in images/
./export_gif.sh     # the turntable, 36 frames. It needs ffmpeg
```

Both scripts make a full CGAL render. The OpenSCAD preview fills the holes of the grille with the
part behind them. A straight view of the front is then not usable.
