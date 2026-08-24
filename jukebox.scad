// Parametric personal jukebox enclosure.
// Fits Jaycar XC3748 MP3 module (77 x 33 x 8), AS3000 57 mm speaker, 3 x SP0710 pushbuttons.
// The shell is sized by its contents: there is nothing to ask for, only components to describe.

/* [Output] */
part = "assembly";        // [assembly, body, panel, lid, speaker_ring, print_plate, none]
explode = 30;             // lid lift in the assembly view

/* [Shell] */
wall = 2.4;
floor_t = 3.0;            // integral floor, the closed end of the shell
lid_t = 3.0;
corner_r = 5;
ledge_w = 2.0;            // shelf width the lid drops onto
ledge_h = 3.0;
lid_fit = 0.35;           // clearance all round the lid
post_d = 9;               // lid screw boss
post_h = 14;
lid_screw_d = 2.6;        // M3 self-tapping pilot
lid_head_d = 5.8;
lid_head_h = 1.8;

/* [PCB - XC3748] */
// BARE BOARD, measured with calipers. Not the catalogue 77 x 33 x 8, which is the envelope
// including the header pins. Every feature below is a fraction of these two, so correcting them
// moves the rails, posts, card slot and connector openings with them.
pcb_w = 69;               // long axis, jack end to header end
pcb_d = 32;               // short axis
pcb_t = 1.6;
pcb_comp_h = 8;           // tallest part standing off the board
pcb_fit = 0.8;
pcb_seat_h = 8;           // board underside above the base plate, and so the base post height
pcb_rail_w = 2.5;         // how far the seat rails reach under the long edges
pcb_rail_len_f = 0.5;     // rail length as a fraction of the board, centred. Short enough to
                          // stay clear of the base screw posts in the corners
pcb_post_d = 5.5;
pcb_screw_d = 1.7;        // M2 self-tapping pilot
// The board sits turned 180 degrees, which puts the card slot against the back wall and the jack
// and USB out the right wall, off the show face.
// [fraction along the long axis from the jack end, fraction across from the back edge]
pcb_hole_at = [[0.0935, 0.5153], [0.9656, 0.4497]];
pcb_over_left_f = 0.0573;   // audio jack past the jack-end edge
pcb_over_right_f = 0.0984;  // pin headers past the header-end edge

/* [Speaker - AS3000] */
speaker_d = 57;
speaker_depth = 20;       // magnet depth behind the panel
speaker_flange_t = 2.5;   // rim thickness the ring clamps, measured
speaker_fit = 0.6;
speaker_seat_h = 1.5;     // locating collar height
speaker_boss_d = 7;
speaker_boss_gap = 2;     // boss ring clear of the rim
speaker_screw_d = 2.6;
ring_t = 3;
ring_grip = 3;            // how far the ring overlaps the rim

/* [Grille] */
grille_margin = 4;        // grille smaller than the rim
grille_hole = 4;
grille_gap = 1.6;

/* [Buttons - SP0710] */
button_hole_d = 7.2;      // 7 mm cutout plus fit
button_body_d = 10.5;     // body and shoulder clearance under the lid
button_nut_d = 12;        // nut across corners, and it sits on the outside face
button_panel_t = 2.0;     // local lid thickness at each button
button_pitch = 22;
button_row_y = 3;         // row offset from the lid centre
button_labels = ["PREV", "PLAY", "NEXT"];
label_size = 4.5;
label_h = 0.8;            // how far the lettering stands proud of the lid
label_gap = 3.0;          // lettering clear of the nut above it. Generous on purpose: the letters
                          // stand proud, and a driver on the nut is wider than the nut

/* [Connector openings] */
// Openings in the jack-end wall. [fraction across the board from the back edge,
//  height above the board top face, width, height, corner radius]. Only the heights are
//  guesses: a top-down photo cannot show them.
//  Trailing field is an outer relief depth: the opening is stepped wider on the outside by
//  plug_relief_grow so a fat plug overmould can nest into the wall and seat fully.
pcb_connectors = [[0.2125, 3.0, 10,  9, 4.5, 0.0],    // 3.5 mm audio jack
                  [0.7286, 1.5, 13,  9, 2.0, 1.4]];   // micro USB, the card-access port
plug_relief_grow = 3;

/* [SD card] */
// Holder is on the board underside, 17.1 x 15.9 mm, with its mouth 0.6 mm inside one long edge,
// so the card slides straight out through that wall. Fractions run along the long axis from the
// jack end. The seat rail is interrupted over sd_span so the holder does not foul it.
sd_at = 0.3555;             // card slot centre
sd_span = [0.2275, 0.4835]; // holder footprint along the board
sd_from_edge = 0.6;         // holder mouth inside the board edge
sd_gap = 1.5;               // board edge to the inner wall on the card side
sd_slot_w = 13;
sd_slot_h = 3.2;
sd_card_drop = 1.0;         // card plane below the board underside
sd_flare = 3.0;             // funnel around the mouth, so a fingertip can reach the card
sd_flare_depth = 2.0;

/* [Split] */
// The shell is two parts. The front comes off so the speaker can be fitted to a loose panel rather
// than down the length of a shut box. The floor stays with the back: closing one end of the shell is
// what stops the box flexing, and it costs no visible colour because nobody looks at the underside.
// Only the walls and the two ledges are cut at the seam: the speaker mount and the front post of
// each pair stay whole and reach past it into open space, which is what lets the lid screw clamp the
// panel down and the floor screw pull its bottom in.
split_clear = 1.5;        // seam this far in front of the frontmost wall opening
split_max_depth = 10;     // cap on how deep the front panel gets
split_fit = 0.25;
// Half lap down each side seam, so the halves guide each other together instead of butting.
lip_share = 0.5;          // the tongue's share of the wall, the panel's outer strap takes the rest
lip_len = 3.0;            // how far the tongue reaches into the panel, clamped by the panel depth
lip_lead = 0.6;           // thinner over its last lip_lead, so the tip finds the groove
lip_land = 1.5;           // panel side wall left whole between the groove and the front wall

/* [Quality] */
$fa = 3;
$fs = 0.4;

/* ---------------- derived ---------------- */
eps = 0.02;
speaker_edge = 3;

pcb_over_left = pcb_over_left_f * pcb_w;
pcb_over_right = pcb_over_right_f * pcb_w;
pcb_hole_pts = [for (h = pcb_hole_at) [(h[0] - 0.5) * pcb_w, (0.5 - h[1]) * pcb_d]];

pcb_gap_left = pcb_over_left + 0.3;         // jack clears the wall, so the board drops in
pcb_clear_right = pcb_over_right + 2;
pcb_env_w = pcb_gap_left + pcb_w + pcb_clear_right;
pcb_env_d = pcb_d + pcb_fit + 2;
pcb_zone_h = pcb_seat_h + pcb_t + pcb_comp_h + 2;

spk_panel = speaker_d + 2 * speaker_edge;
spk_pcd = speaker_d + 2 * speaker_boss_gap + speaker_boss_d;
grille_d = speaker_d - 2 * grille_margin;

button_count = len(button_labels);
// Clear of the nut, not of the hole. text() gives no metrics, so the block is taken as label_size
// tall, which overstates it by about 5% and errs the right way.
label_offset = button_nut_d / 2 + label_gap + label_size / 2;
btn_req_w = (button_count - 1) * button_pitch + button_body_d + 6;

// Depth is set by the front panel, not the board. Every wall opening is placed off the board and
// the board off the back wall, so the deeper the box the further the openings sit from the front,
// and the panel needs speaker_flange_t of tray plus split_clear in front of the frontmost one.
panel_min = speaker_flange_t + 2;
conn_reach = [for (c = pcb_connectors)
              sd_gap + pcb_d / 2 - (c[0] - 0.5) * pcb_d
              + (c[2] + (c[5] > 0 ? plug_relief_grow : 0)) / 2];

cav_w = max(spk_panel, pcb_env_w, btn_req_w);
cav_d = max(speaker_depth + 3, pcb_env_d, panel_min + split_clear + max(conn_reach));
cav_h = spk_panel + pcb_zone_h + ledge_h;

out_w = cav_w + 2 * wall;
out_d = cav_d + 2 * wall;
out_h = floor_t + cav_h + lid_t;

lid_w = cav_w - lid_fit;
lid_d = cav_d - lid_fit;
lid_z = out_h - lid_t;

px = cav_w / 2 - post_d / 2;
py = cav_d / 2 - post_d / 2;
corner_ri = max(corner_r - wall, 0.5);   // cavity corner fillet, and its arc centre
corner_cx = cav_w / 2 - corner_ri;
corner_cy = cav_d / 2 - corner_ri;
// A post drawn about the corner's own arc centre, big enough to still carry the screw at px, py.
post_r = norm([px - corner_cx, py - corner_cy]) + post_d / 2;
// Cone height under a back lid post. It is struck from the point on the corner fillet rather than the
// post's own axis, so it has to reach the far side of the post: post_r past the arc centre.
post_taper = post_r + corner_ri + 0.5;
base_post_h = pcb_seat_h;      // the board underside is as high as a base post may reach
plate_gap = 8;
ring_w = speaker_d + 4;
plate_w = out_w + plate_gap + max(lid_w, ring_w);
plate_h = max(out_d + plate_gap + out_h, lid_d + plate_gap + ring_w);

btn_y = button_row_y;

spk_cz = cav_h - ledge_h - speaker_d / 2 - speaker_edge;  // speaker centre above the base plate

pcb_x = cav_w / 2 - pcb_gap_left - pcb_w / 2;
pcb_y = cav_d / 2 - sd_gap - pcb_d / 2;
sd_reach = wall + sd_gap + sd_from_edge;

conn_edges = [for (c = pcb_connectors)
              pcb_y + (c[0] - 0.5) * pcb_d
              - (c[2] + (c[5] > 0 ? plug_relief_grow : 0)) / 2 - split_clear];
seam_y = min(concat(conn_edges, [-cav_d / 2 + split_max_depth]));
face_d = seam_y + cav_d / 2 + wall;       // front panel depth, outer face to seam
lip_t = (wall - split_fit) * lip_share;     // tongue thickness
lip_strap = wall - split_fit - lip_t;       // panel wall left outboard of the groove
lip_reach = min(lip_len, face_d - wall - lip_land - split_fit);

echo(str("outer  ", out_w, " x ", out_d, " x ", out_h, " mm"));
echo(str("cavity ", cav_w, " x ", cav_d, " x ", cav_h, " mm"));
echo(str("pcb ", pcb_w, " x ", pcb_d, ", jack out ", pcb_over_left,
         ", headers out ", pcb_over_right, " mm"));
echo(str("pcb screw posts at ", pcb_hole_pts, " from board centre"));
echo(str("sd card sits ", sd_reach, " mm inside the back wall"));
echo(str("split seam at y ", seam_y, ", front panel ", face_d, " mm deep"));
echo(str("seam half lap: tongue ", lip_t, " x ", lip_reach, ", panel strap ", lip_strap, " mm"));
echo(str("print plate ", plate_w, " x ", plate_h, " mm"));
if (face_d - wall < speaker_flange_t + 1)
    echo("WARNING: front panel too shallow for the speaker bosses");
if (lip_reach < lip_lead + 1) echo("WARNING: front panel too shallow for the seam lip");
if (min(lip_t, lip_strap) < 0.9) echo("WARNING: seam half lap leaves a wall under 0.9 mm");
if (base_post_h < 5) echo("WARNING: pcb_seat_h too low for the base screws to bite");

/* ---------------- helpers ---------------- */
module rrect(w, d, r) {
    rr = min(r, w / 2 - eps, d / 2 - eps);
    offset(r = rr) square([w - 2 * rr, d - 2 * rr], center = true);
}

module rbox(w, d, h, r) { linear_extrude(h) rrect(w, d, r); }

/* ---------------- grille ---------------- */
module grille2d(d) {
    pitch = grille_hole + grille_gap;
    rmax = d / 2 - grille_hole * 0.6;
    n = ceil(d / pitch) + 1;
    for (j = [-n:n], i = [-n:n]) {
        x = (i + (j % 2) / 2) * pitch;
        y = j * pitch * sin(60);
        if (sqrt(x * x + y * y) <= rmax)
            translate([x, y]) rotate(30) circle(d = grille_hole / cos(30), $fn = 6);
    }
}

/* ---------------- speaker mount ---------------- */
// Built with the panel inner face at z = 0, features growing +Z.
module spk_solids() {
    difference() {
        cylinder(d = speaker_d + 2 * speaker_edge, h = speaker_seat_h);
        translate([0, 0, -1]) cylinder(d = speaker_d + speaker_fit, h = speaker_seat_h + 2);
    }
    for (a = [45:90:315])
        rotate([0, 0, a]) translate([spk_pcd / 2, 0, 0])
            cylinder(d = speaker_boss_d, h = speaker_flange_t);
}

module spk_cuts(panel_t) {
    translate([0, 0, -panel_t - 1]) linear_extrude(panel_t + 2) grille2d(grille_d);
    for (a = [45:90:315])
        rotate([0, 0, a]) translate([spk_pcd / 2, 0, -panel_t * 0.7])
            cylinder(d = speaker_screw_d, h = speaker_flange_t + panel_t);
}

module place_spk_front() {
    translate([0, -cav_d / 2, floor_t + spk_cz]) rotate([-90, 0, 0]) children();
}

module speaker_ring() {
    linear_extrude(ring_t) difference() {
        union() {
            circle(d = speaker_d + 4);
            for (a = [45:90:315]) rotate(a) hull() {
                translate([speaker_d / 2, 0]) circle(d = speaker_boss_d + 3);
                translate([spk_pcd / 2, 0]) circle(d = speaker_boss_d + 3);
            }
        }
        circle(d = speaker_d - 2 * ring_grip);
        for (a = [45:90:315]) rotate(a) translate([spk_pcd / 2, 0]) circle(d = speaker_screw_d + 0.9);
    }
}

/* ---------------- pcb ---------------- */
// Rails run the long edges only: both short ends are full of connectors.
// Two seats under the board's long edges. The two M2 screws already fix where the board sits, so
// these only have to stop it rocking, which a short pair does as well as a long one.
module pcb_rails() {
    bd = pcb_d + pcb_fit;
    rl = pcb_rail_len_f * pcb_w;
    sx0 = (sd_span[0] - 0.5) * pcb_w - 1;
    sx1 = (sd_span[1] - 0.5) * pcb_w + 1;
    for (sy = [-1, 1]) translate([0, 0, -eps]) linear_extrude(pcb_seat_h + eps) difference() {
        translate([0, sy * (bd / 2 - pcb_rail_w / 2)]) square([rl, pcb_rail_w], center = true);
        if (sy == -1) translate([(sx0 + sx1) / 2, -bd / 2])
            square([sx1 - sx0, bd], center = true);
    }
}

module pcb_posts() {
    for (p = pcb_hole_pts) translate([p[0], p[1], -eps]) difference() {
        cylinder(d = pcb_post_d, h = pcb_seat_h + eps);
        translate([0, 0, -1.5]) cylinder(d = pcb_screw_d, h = pcb_seat_h + 1.5 + 2 * eps);
    }
}

// Rails carry the board's long edges, the two posts take its screws. Both stand on the floor.
module pcb_mount_geo() {
    translate([pcb_x, pcb_y, floor_t]) rotate([0, 0, 180]) { pcb_rails(); pcb_posts(); }
}

/* ---------------- shell details ---------------- */
// Only the lid gets a ledge. The other end of the shell is the floor, which needs none.
module lid_ledge() {
    translate([0, 0, lid_z - ledge_h]) difference() {
        rbox(cav_w, cav_d, ledge_h, corner_ri);
        translate([0, 0, -1]) rbox(cav_w - 2 * ledge_w, cav_d - 2 * ledge_w, ledge_h + 2,
                                   max(corner_ri - ledge_w, 0.5));
    }
}

module cavity_clip() {
    translate([0, 0, floor_t])
        rbox(cav_w, cav_d, cav_h - ledge_h, corner_ri);
    translate([0, 0, lid_z - ledge_h])
        rbox(cav_w - 2 * ledge_w, cav_d - 2 * ledge_w, ledge_h,
             max(corner_ri - ledge_w, 0.5));
}

// Posts fill the corner rather than standing off it. A cylinder tangent to two walls is joined to
// them along a line each and leaves a void behind it in the fillet; drawn about the corner's own
// arc centre and clipped to the cavity, the same post meets the walls over an area instead.
module post_profile(sx, sy, g = 0) {
    offset(g) intersection() {
        translate([sx * corner_cx, sy * corner_cy]) circle(r = post_r);
        rrect(cav_w, cav_d, corner_ri);
    }
}

// side 0 both, -1 the front pair that goes with the panel, 1 the back pair. g grows the post into
// the clearance the shell needs, because the panel's pair reaches back past the seam.
module lid_posts(side = 0, g = 0) {
    for (sx = [-1, 1], sy = [-1, 1]) if (side == 0 || sy == side)
        translate([0, 0, lid_z - post_h - g])
            linear_extrude(post_h + g) post_profile(sx, sy, g);
}

module lid_post_holes(side = 0) {
    for (sx = [-1, 1], sy = [-1, 1]) if (side == 0 || sy == side)
        translate([sx * px, sy * py, lid_z - post_h - 1])
            cylinder(d = lid_screw_d, h = post_h + 2);
}

// Grown sideways and upwards only. The free end of a base post is its top, and below it is the
// floor, which the clearance must not eat into.
module base_posts(side = 0, g = 0) {
    for (sx = [-1, 1], sy = [-1, 1]) if (side == 0 || sy == side)
        translate([0, 0, floor_t])
            linear_extrude(base_post_h + g) post_profile(sx, sy, g);
}

// A back lid post hangs in mid air, and the body prints standing on its floor, so each gets a 45
// degree cone beneath it. Struck from the point on the corner fillet, not the post's own axis: that
// is what keeps every layer of the cone attached to the wall instead of starting in free space.
module lid_post_cone(side = 0) {
    c = corner_ri / sqrt(2);
    z0 = lid_z - post_h - post_taper;
    for (sx = [-1, 1], sy = [-1, 1]) if (side == 0 || sy == side)
        intersection() {
            translate([0, 0, z0]) linear_extrude(post_taper) post_profile(sx, sy);
            translate([sx * (corner_cx + c), sy * (corner_cy + c), z0])
                cylinder(r1 = 0, r2 = post_taper, h = post_taper);
        }
}

module base_post_holes(side = 0) {
    for (sx = [-1, 1], sy = [-1, 1]) if (side == 0 || sy == side)
        translate([sx * px, sy * py, floor_t - 1])
            cylinder(d = lid_screw_d, h = base_post_h + 1);
}

// Two walls take openings and no others: the connectors go out the right, the card slot out the
// back. Both frames start 1 mm proud of the wall with +Z running into the box. On the right wall
// the local X axis is vertical, so profiles there are given height first.
module on_right(u, v) { translate([out_w / 2 + 1, u, floor_t + v]) rotate([0, -90, 0]) children(); }
module on_back(u, v)  { translate([u, out_d / 2 + 1, floor_t + v]) rotate([90, 0, 0]) children(); }

module connector_cuts() {
    for (c = pcb_connectors) {
        u = pcb_y + (c[0] - 0.5) * pcb_d;
        v = pcb_seat_h + pcb_t + c[1];
        gr = plug_relief_grow;
        on_right(u, v) {
            linear_extrude(wall + 6) rrect(c[3], c[2], c[4]);
            if (c[5] > 0)
                linear_extrude(c[5] + 1) rrect(c[3] + gr, c[2] + gr, c[4] + gr / 2);
        }
    }
    on_back(pcb_x + (0.5 - sd_at) * pcb_w, pcb_seat_h - sd_card_drop) {
        linear_extrude(wall + 6) rrect(sd_slot_w, sd_slot_h, 1.0);
        // Funnel: mouth sd_flare wider all round, tapering back to size over sd_flare_depth.
        if (sd_flare > 0) hull() {
            linear_extrude(1 + eps)
                rrect(sd_slot_w + 2 * sd_flare, sd_slot_h + 2 * sd_flare, 1.0 + sd_flare);
            translate([0, 0, 1 + sd_flare_depth]) linear_extrude(eps)
                rrect(sd_slot_w, sd_slot_h, 1.0);
        }
    }
}

/* ---------------- parts ---------------- */
module before(y1) { translate([-out_w, y1 - 2 * out_d, -1]) cube([2 * out_w, 2 * out_d, out_h + 2]); }
module behind(y1) { translate([-out_w, y1, -1]) cube([2 * out_w, 2 * out_d, out_h + 2]); }

// Walls and the two ledges with every panel opening cut, before the front is taken off. Open at the
// top and the bottom: the lid and the base plate close it.
module shell() {
    difference() {
        union() {
            difference() {
                rbox(out_w, out_d, out_h, corner_r);
                translate([0, 0, -1]) rbox(cav_w, cav_d, out_h + 2, corner_ri);
            }
            lid_ledge();
        }
        connector_cuts();
    }
}

module speaker_mount() {
    intersection() { place_spk_front() spk_solids(); cavity_clip(); }
}

// The wall from the cavity face outwards by t, following the corner fillet.
module wall_band(t) {
    difference() {
        rrect(cav_w + 2 * t, cav_d + 2 * t, corner_ri + t);
        rrect(cav_w, cav_d, corner_ri);
    }
}

// The tongue the body carries past the seam, and grown by g the groove the panel is relieved by.
// Two lengths, the longer one thinner, is what puts the guiding step on the tip.
module seam_lip(g = 0) {
    for (s = [[lip_reach - lip_lead, lip_t], [lip_reach, lip_t - lip_lead]])
        intersection() {
            shell();
            translate([-out_w, seam_y - s[0] - g, -1])
                cube([2 * out_w, s[0] + g, out_h + 2]);
            translate([0, 0, -1]) linear_extrude(out_h + 2) wall_band(s[1] + g);
        }
}

// The closed end of the shell. Full cavity footprint behind the seam. In front of it a lip, shrunk
// by the fit so the panel clears it, that backs up the inside of the panel's front wall and carries
// the two screws pulling the panel's bottom in.
module floor_plate() {
    difference() {
        union() {
            intersection() {
                rbox(cav_w + 2 * eps, cav_d + 2 * eps, floor_t, corner_ri + eps);
                behind(seam_y);
            }
            intersection() {
                rbox(cav_w - 2 * split_fit, cav_d - 2 * split_fit, floor_t,
                     max(corner_ri - split_fit, 0.5));
                before(seam_y + eps);
            }
        }
        for (sx = [-1, 1]) translate([sx * px, -py, 0]) {
            translate([0, 0, -1]) cylinder(d = lid_screw_d + 1.0, h = floor_t + 2);
            translate([0, 0, -eps])
                cylinder(d1 = lid_head_d, d2 = lid_screw_d + 1.0, h = lid_head_h + eps);
        }
    }
}

// The ledge overhangs the cavity by ledge_w, which the body cannot print standing on its floor. A 45
// degree run-up carries it. Behind the seam only: the panel's share of the ledge lies flat on its face.
module ledge_chamfer() {
    z0 = lid_z - ledge_h;
    intersection() {
        difference() {
            translate([0, 0, z0 - ledge_w]) rbox(cav_w, cav_d, ledge_w, corner_ri);
            hull() {
                translate([0, 0, z0 - ledge_w - eps]) linear_extrude(eps)
                    rrect(cav_w + 2 * eps, cav_d + 2 * eps, corner_ri + eps);
                translate([0, 0, z0]) linear_extrude(eps)
                    rrect(cav_w - 2 * ledge_w, cav_d - 2 * ledge_w,
                          max(corner_ri - ledge_w, 0.5));
            }
        }
        behind(seam_y);
    }
}

// Back shell: everything behind the seam, plus the floor and the board's seat, relieved where the
// panel's posts reach into it.
module body() {
    difference() {
        union() {
            intersection() { shell(); behind(seam_y); }
            seam_lip();
            floor_plate();
            pcb_mount_geo();
            ledge_chamfer();
            lid_posts(1);
            lid_post_cone(1);
        }
        lid_post_holes(1);
        lid_posts(-1, split_fit);
        base_posts(-1, split_fit);
    }
}

// Front panel: grille, speaker mount and the front post of each pair, so the lid screw pulls the
// panel down from above and the floor screw pulls it in from below.
module panel() {
    difference() {
        union() {
            intersection() { shell(); before(seam_y); }
            lid_posts(-1);
            base_posts(-1);
            speaker_mount();
        }
        lid_post_holes(-1);
        base_post_holes(-1);
        place_spk_front() spk_cuts(wall);
        seam_lip(split_fit);
    }
}

module button_row() {
    for (i = [0:button_count - 1])
        translate([(i - (button_count - 1) / 2) * button_pitch, btn_y]) children();
}

module lid() {
    translate([0, 0, lid_z]) union() {
        difference() {
            rbox(lid_w, lid_d, lid_t, corner_ri);
            button_row() translate([0, 0, -1]) cylinder(d = button_hole_d, h = lid_t + 2);
            button_row() translate([0, 0, -eps])
                cylinder(d = button_body_d, h = lid_t - button_panel_t + eps);
            for (sx = [-1, 1], sy = [-1, 1]) translate([sx * px, sy * py, -1]) {
                cylinder(d = lid_screw_d + 1.0, h = lid_t + 2);
            translate([0, 0, 1 + lid_t - lid_head_h])
                cylinder(d1 = lid_screw_d + 1.0, d2 = lid_head_d, h = lid_head_h + eps);
            }
        }
        // Labels stand label_h proud of the top face rather than being cut into it.
        for (i = [0:button_count - 1])
            translate([(i - (button_count - 1) / 2) * button_pitch,
                       btn_y - label_offset, lid_t - eps])
                linear_extrude(label_h + eps)
                    text(button_labels[i], size = label_size, halign = "center",
                         valign = "center");
    }
}

module ring_placed() {
    place_spk_front() translate([0, 0, speaker_flange_t]) speaker_ring();
}

// Every part on one bed. The body stands on its floor, which is the only orientation that puts the
// board's rails and posts upright; the panel lies on its face, which puts the grille flat on the
// plate. Nothing needs support in either.
module print_plate() {
    g = plate_gap;
    col2 = out_w + g;
    translate([out_w / 2, out_d / 2, 0]) body();
    translate([out_w / 2, out_d + g + out_h, out_d / 2]) rotate([90, 0, 0]) panel();
    translate([col2 + lid_w / 2, lid_d / 2, -lid_z]) lid();
    translate([col2 + ring_w / 2, lid_d + g + ring_w / 2, 0]) speaker_ring();
}

/* ---------------- output ---------------- */
if (part == "body") body();
else if (part == "panel") panel();
else if (part == "lid") lid();
else if (part == "speaker_ring") speaker_ring();
else if (part == "print_plate") print_plate();
else if (part == "assembly") {
    color("SteelBlue") body();
    color("CadetBlue") translate([0, -explode, 0]) panel();
    color("Gainsboro") translate([0, 0, explode]) lid();
    color("DarkOrange") translate([0, -explode / 2, 0]) ring_placed();
}
