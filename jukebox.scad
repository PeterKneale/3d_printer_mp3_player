// Parametric personal jukebox enclosure.
// Fits Jaycar XC3748 MP3 module (77 x 33 x 8), AS3000 57 mm speaker, 3 x SP0710 pushbuttons.
// Shell auto-grows past the requested size when the contents need more room.

/* [Output] */
part = "assembly";        // [assembly, body, lid, speaker_ring, pcb_gauge, end_gauge, print_plate, none]
explode = 30;             // lid lift in the assembly view

/* [Requested outer size] */
want_w = 80;              // left-right
want_d = 40;              // front-back
want_h = 35;              // floor to lid

/* [Shell] */
wall = 2.4;
floor_t = 2.4;
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
pcb_seat_h = 4;           // board underside above the floor
pcb_flip = true;          // 180 deg: card slot to the back wall, jack and USB to the right
pcb_mount = "both";       // [both, rails, posts, none]
pcb_rail_w = 2.5;         // how far the seat rails reach under the long edges
pcb_post_d = 5.5;
pcb_screw_d = 1.7;        // M2 self-tapping pilot
// [fraction along the long axis from the jack end, fraction across from the back edge]
pcb_hole_at = [[0.0935, 0.5153], [0.9656, 0.4497]];
pcb_over_left_f = 0.0573;   // audio jack past the jack-end edge
pcb_over_right_f = 0.0984;  // pin headers past the header-end edge

/* [Speaker - AS3000] */
speaker_face = "front";   // [front, top]
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
grille_style = "hex";     // [hex, dots, rings, slots]
grille_margin = 4;        // grille smaller than the rim
grille_hole = 4;
grille_gap = 1.6;

/* [Buttons - SP0710] */
button_count = 3;
button_hole_d = 7.2;      // 7 mm cutout plus fit
button_body_d = 10.5;     // nut and flange clearance under the lid
button_panel_t = 2.0;     // local lid thickness at each button
button_pitch = 22;        // 0 spreads them across the lid
button_row_y = 3;         // row offset from the lid centre
button_labels = ["PREV", "PLAY", "NEXT"];
label_size = 4.0;
label_depth = 0.6;
label_offset = 7.5;

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
sd_slot = true;
sd_at = 0.3555;             // card slot centre
sd_span = [0.2275, 0.4835]; // holder footprint along the board
sd_from_edge = 0.6;         // holder mouth inside the board edge
sd_gap = 1.5;               // board edge to the inner wall on the card side
sd_slot_w = 13;
sd_slot_h = 3.2;
sd_card_drop = 1.0;         // card plane below the board underside

/* [Extra panel cutouts] */
// [face, along-face offset, height above floor, width, height, corner radius]
panel_cutouts = [];

/* [Feet] */
feet = true;
foot_d = 12;
foot_recess = 1.0;

/* [Quality] */
$fa = 3;
$fs = 0.4;

/* ---------------- derived ---------------- */
eps = 0.02;
lip_t = 1.6;
speaker_edge = 3;

front = speaker_face == "front";

pcb_over_left = pcb_over_left_f * pcb_w;
pcb_over_right = pcb_over_right_f * pcb_w;
pcb_hole_pts = [for (h = pcb_hole_at) [(h[0] - 0.5) * pcb_w, (0.5 - h[1]) * pcb_d]];

pcb_gap_left = pcb_over_left + 0.3;         // jack clears the wall, so the board drops in
pcb_clear_right = pcb_over_right + 2;
pcb_env_w = pcb_gap_left + pcb_w + pcb_clear_right;
pcb_env_d = pcb_d + pcb_fit + 2 * lip_t + 2;
pcb_zone_h = pcb_seat_h + pcb_t + pcb_comp_h + 2;

spk_panel = speaker_d + 2 * speaker_edge;
spk_pcd = speaker_d + 2 * speaker_boss_gap + speaker_boss_d;
grille_d = speaker_d - 2 * grille_margin;

btn_min_pitch = button_body_d + 2;
btn_req_w = (button_count - 1) * max(button_pitch, btn_min_pitch) + button_body_d + 6;

req_w = max(spk_panel, pcb_env_w, btn_req_w);
req_d = front ? max(speaker_depth + 3, pcb_env_d)
              : max(spk_panel + button_body_d + 10, pcb_env_d);
req_h = front ? spk_panel + pcb_zone_h + ledge_h
              : speaker_depth + 3 + pcb_zone_h;

cav_w = max(want_w - 2 * wall, req_w);
cav_d = max(want_d - 2 * wall, req_d);
cav_h = max(want_h - floor_t - lid_t, req_h);

out_w = cav_w + 2 * wall;
out_d = cav_d + 2 * wall;
out_h = floor_t + cav_h + lid_t;

lid_w = cav_w - lid_fit;
lid_d = cav_d - lid_fit;
lid_z = out_h - lid_t;

px = cav_w / 2 - post_d / 2;
py = cav_d / 2 - post_d / 2;

btn_pitch = button_pitch > 0 || button_count < 2 ? button_pitch
                : (lid_w - button_body_d - 8) / (button_count - 1);
btn_y = front ? button_row_y : -(lid_d / 2 - button_body_d / 2 - 5);

spk_cz = cav_h - ledge_h - speaker_d / 2 - speaker_edge;  // front mount, above the floor
spk_ly = lid_d / 2 - spk_panel / 2 - 2;                  // top mount, from the lid centre

rot = pcb_flip ? -1 : 1;
conn_face = pcb_flip ? "right" : "left";
sd_face = pcb_flip ? "back" : "front";
pcb_x = -rot * (cav_w / 2 - pcb_gap_left - pcb_w / 2);
pcb_y = -rot * (cav_d / 2 - sd_gap - pcb_d / 2);
sd_reach = wall + sd_gap + sd_from_edge;

eg_lo = min(abs(pcb_x + rot * (sd_at - 0.5) * pcb_w) - sd_slot_w / 2 - 4, out_w / 2 - 34);
eg_w = out_w / 2 - eg_lo;
eg_cx = (pcb_flip ? 1 : -1) * (eg_lo + eg_w / 2);

echo(str("outer  ", out_w, " x ", out_d, " x ", out_h, " mm"));
echo(str("cavity ", cav_w, " x ", cav_d, " x ", cav_h, " mm"));
echo(str("button pitch ", btn_pitch, " mm"));
echo(str("pcb ", pcb_w, " x ", pcb_d, ", jack out ", pcb_over_left,
         ", headers out ", pcb_over_right, " mm"));
echo(str("pcb screw posts at ", pcb_hole_pts, " from board centre"));
echo(str("sd card sits ", sd_reach, " mm inside the ", sd_face, " wall"));

/* ---------------- helpers ---------------- */
module rrect(w, d, r) {
    rr = min(r, w / 2 - eps, d / 2 - eps);
    offset(r = rr) square([w - 2 * rr, d - 2 * rr], center = true);
}

module rbox(w, d, h, r) { linear_extrude(h) rrect(w, d, r); }

/* ---------------- grille ---------------- */
module grille_hex(d) {
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

module grille_dots(d) {
    pitch = grille_hole + grille_gap;
    rmax = d / 2 - grille_hole * 0.6;
    n = ceil(d / pitch) + 1;
    for (j = [-n:n], i = [-n:n]) {
        x = (i + (j % 2) / 2) * pitch;
        y = j * pitch * sin(60);
        if (sqrt(x * x + y * y) <= rmax) translate([x, y]) circle(d = grille_hole);
    }
}

module grille_rings(d) {
    step = grille_hole + grille_gap;
    n = floor((d / 2 - grille_gap) / step);
    difference() {
        for (k = [1:n]) difference() {
            circle(r = k * step);
            circle(r = k * step - grille_hole);
        }
        for (s = [0:3]) rotate(45 + 45 * s) square([grille_gap * 2, d + 2], center = true);
    }
}

module grille_slots(d) {
    step = grille_hole + grille_gap;
    n = floor(d / 2 / step);
    for (k = [-n:n]) {
        y = k * step;
        hw = sqrt(max(0, pow(d / 2, 2) - pow(abs(y) + grille_hole / 2, 2)));
        if (hw > grille_hole)
            translate([0, y]) hull() {
                translate([-hw + grille_hole / 2, 0]) circle(d = grille_hole);
                translate([hw - grille_hole / 2, 0]) circle(d = grille_hole);
            }
    }
}

module grille2d(d) {
    if (grille_style == "hex") grille_hex(d);
    else if (grille_style == "dots") grille_dots(d);
    else if (grille_style == "rings") grille_rings(d);
    else grille_slots(d);
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

module place_spk_lid() {
    translate([0, spk_ly, lid_z]) rotate([180, 0, 0]) children();
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
module pcb_rails() {
    bd = pcb_d + pcb_fit;
    sx0 = (sd_span[0] - 0.5) * pcb_w - 1;
    sx1 = (sd_span[1] - 0.5) * pcb_w + 1;
    for (sy = [-1, 1]) {
        linear_extrude(pcb_seat_h) difference() {
            translate([0, sy * (bd / 2 - pcb_rail_w / 2)])
                square([pcb_w, pcb_rail_w], center = true);
            if (sy == -1) translate([(sx0 + sx1) / 2, -bd / 2])
                square([sx1 - sx0, bd], center = true);
        }
        linear_extrude(pcb_seat_h + pcb_t + 1.6) translate([0, sy * (bd / 2 + lip_t / 2)])
            square([pcb_w, lip_t], center = true);
    }
}

module pcb_posts() {
    for (p = pcb_hole_pts) translate([p[0], p[1]]) difference() {
        cylinder(d = pcb_post_d, h = pcb_seat_h);
        translate([0, 0, -1.5]) cylinder(d = pcb_screw_d, h = pcb_seat_h + 1.5);
    }
}

module pcb_mounts() {
    if (pcb_mount == "both" || pcb_mount == "rails") pcb_rails();
    if (pcb_mount == "both" || pcb_mount == "posts") pcb_posts();
}

module pcb_mount_geo() {
    translate([pcb_x, pcb_y, floor_t]) rotate([0, 0, pcb_flip ? 180 : 0]) pcb_mounts();
}

// Throwaway plate for checking the board fits before committing to the body print.
module pcb_gauge() {
    t = 2;
    difference() {
        union() {
            linear_extrude(t) rrect(pcb_w + 2 * lip_t + 10, pcb_d + 2 * lip_t + 10, 3);
            translate([0, 0, t]) pcb_mounts();
        }
        for (p = pcb_hole_pts) translate([p[0], p[1], -1])
            cylinder(d = pcb_screw_d, h = t + pcb_seat_h + 2);
    }
}

/* ---------------- shell details ---------------- */
module lid_ledge() {
    translate([0, 0, lid_z - ledge_h]) difference() {
        rbox(cav_w, cav_d, ledge_h, max(corner_r - wall, 0.5));
        translate([0, 0, -1]) rbox(cav_w - 2 * ledge_w, cav_d - 2 * ledge_w, ledge_h + 2,
                                   max(corner_r - wall - ledge_w, 0.5));
    }
}

module cavity_clip() {
    translate([0, 0, floor_t])
        rbox(cav_w, cav_d, cav_h - ledge_h, max(corner_r - wall, 0.5));
    translate([0, 0, lid_z - ledge_h])
        rbox(cav_w - 2 * ledge_w, cav_d - 2 * ledge_w, ledge_h,
             max(corner_r - wall - ledge_w, 0.5));
}

module lid_posts() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * px, sy * py, lid_z - post_h]) cylinder(d = post_d, h = post_h);
}

module lid_post_holes() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * px, sy * py, lid_z - post_h - 1])
            cylinder(d = lid_screw_d, h = post_h + 2);
}

module panel_cut(c, depth = 0) {
    f = c[0]; u = c[1]; v = c[2]; w = c[3]; h = c[4];
    r = len(c) > 5 ? c[5] : 1.5;
    t = depth > 0 ? depth + 1 : wall + 6;
    z = floor_t + v;
    if (f == "back")
        translate([u, out_d / 2 + 1, z]) rotate([90, 0, 0]) linear_extrude(t) rrect(w, h, r);
    else if (f == "front")
        translate([u, -out_d / 2 - 1, z]) rotate([-90, 0, 0]) linear_extrude(t) rrect(w, h, r);
    else if (f == "left")
        translate([-out_w / 2 - 1, u, z]) rotate([0, 90, 0]) linear_extrude(t) rrect(h, w, r);
    else if (f == "right")
        translate([out_w / 2 + 1, u, z]) rotate([0, -90, 0]) linear_extrude(t) rrect(h, w, r);
}

module connector_cuts() {
    for (c = pcb_connectors) {
        u = pcb_y + rot * (0.5 - c[0]) * pcb_d;
        v = pcb_seat_h + pcb_t + c[1];
        gr = plug_relief_grow;
        panel_cut([conn_face, u, v, c[2], c[3], c[4]]);
        if (c[5] > 0)
            panel_cut([conn_face, u, v, c[2] + gr, c[3] + gr, c[4] + gr / 2], c[5]);
    }
    if (sd_slot)
        panel_cut([sd_face, pcb_x + rot * (sd_at - 0.5) * pcb_w,
                   pcb_seat_h - sd_card_drop, sd_slot_w, sd_slot_h, 1.0]);
}

module foot_recesses() {
    if (feet) for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * (out_w / 2 - foot_d / 2 - 4), sy * (out_d / 2 - foot_d / 2 - 4), -1])
            cylinder(d = foot_d, h = foot_recess + 1);
}

/* ---------------- parts ---------------- */
module body() {
    difference() {
        union() {
            difference() {
                rbox(out_w, out_d, out_h, corner_r);
                translate([0, 0, floor_t]) rbox(cav_w, cav_d, cav_h + lid_t + 1,
                                                max(corner_r - wall, 0.5));
            }
            lid_ledge();
            lid_posts();
            pcb_mount_geo();
            if (front) intersection() { place_spk_front() spk_solids(); cavity_clip(); }
        }
        lid_post_holes();
        if (front) place_spk_front() spk_cuts(wall);
        connector_cuts();
        for (c = panel_cutouts) panel_cut(c);
        foot_recesses();
    }
}

module button_row() {
    for (i = [0:button_count - 1])
        translate([(i - (button_count - 1) / 2) * btn_pitch, btn_y]) children();
}

module lid() {
    translate([0, 0, lid_z]) difference() {
        union() {
            rbox(lid_w, lid_d, lid_t, max(corner_r - wall, 0.5));
            if (!front) translate([0, 0, -lid_z])
                intersection() { place_spk_lid() spk_solids(); cavity_clip(); }
        }
        // buttons
        button_row() translate([0, 0, -1]) cylinder(d = button_hole_d, h = lid_t + 2);
        button_row() translate([0, 0, -eps]) cylinder(d = button_body_d, h = lid_t - button_panel_t + eps);
        // labels
        for (i = [0:button_count - 1])
            translate([(i - (button_count - 1) / 2) * btn_pitch,
                       btn_y - label_offset, lid_t - label_depth])
                linear_extrude(label_depth + 1)
                    text(button_labels[i], size = label_size, halign = "center", valign = "center");
        // lid screws
        for (sx = [-1, 1], sy = [-1, 1]) translate([sx * px, sy * py, -1]) {
            cylinder(d = lid_screw_d + 1.0, h = lid_t + 2);
            translate([0, 0, 1 + lid_t - lid_head_h]) cylinder(d1 = lid_screw_d + 1.0, d2 = lid_head_d, h = lid_head_h + eps);
        }
        if (!front) translate([0, 0, -lid_z]) place_spk_lid() spk_cuts(lid_t);
    }
}

module ring_placed() {
    if (front)
        place_spk_front() translate([0, 0, speaker_flange_t]) speaker_ring();
    else
        place_spk_lid() translate([0, 0, speaker_flange_t]) speaker_ring();
}

// The real connector end, sliced off the body: proves every wall opening against the board.
// Reaches far enough along to take in the card slot as well as the jack and USB.
module end_gauge() {
    zt = floor_t + pcb_seat_h + pcb_t + 14;
    intersection() {
        body();
        mirror([pcb_flip ? 0 : 1, 0, 0])
            translate([eg_lo, -out_d / 2 - 1, -1]) cube([out_w, out_d + 2, zt + 1]);
    }
}

// Every part on one bed, gauges included. Check the echoed footprint against your printer.
module print_plate() {
    g = 8;
    gw = pcb_w + 2 * lip_t + 10;
    rw = speaker_d + 4;
    r1 = max(out_d, lid_d);
    y2 = r1 / 2 + g + rw / 2;
    translate([out_w / 2, 0, 0]) body();
    translate([out_w + g + lid_w / 2, 0, -lid_z]) lid();
    translate([gw / 2, y2, 0]) pcb_gauge();
    translate([gw + g + rw / 2, y2, 0]) speaker_ring();
    translate([gw + g + rw + g + eg_w / 2 - eg_cx, y2, 0]) end_gauge();
}

/* ---------------- output ---------------- */
if (part == "body") body();
else if (part == "lid") lid();
else if (part == "speaker_ring") speaker_ring();
else if (part == "pcb_gauge") pcb_gauge();
else if (part == "end_gauge") end_gauge();
else if (part == "print_plate") print_plate();
else if (part == "assembly") {
    color("SteelBlue") body();
    color("Gainsboro") translate([0, 0, explode]) lid();
    color("DarkOrange") translate([0, 0, front ? 0 : explode]) ring_placed();
}
