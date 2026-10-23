// Miniblind bottom-rail protective end cap
// Copyright (C) 2026. Released under GPL-3.0-or-later.
// X = width; Y = length; Z = depth. Z=0 is the closed end.
// 21 x 10 mm rail measured; 21.3 mm interior length is retained.
// Updated curved width: 11.3 mm at center, +0.5 mm clearance on each side.
// Prototype still awaits successful physical fit test.

/* [Configuration] */
mode = "final"; // [final,fit_gauge]

/* [Overall size (mm)] */
length = 25.0;
width_middle = 15.5;
width_ends = 12.0;
cap_depth = 12.7;

/* [Profile (mm)] */
corner_radius = 0.65;
face_chamfer = 0.45;
side_power = 2.0;
side_taper = 0.70;

/* [Measured rail fit (mm)] */
rail_length = 21.0;        // Measured metal rail long axis, approximate
rail_width = 10.0;         // Measured metal rail short axis, approximate
length_clearance = 0.30;  // UNCHANGED: +0.15 per end
width_clearance = 0.30;   // Original total width allowance
side_wall_reduction = 0.50; // Move EACH curved cavity side outward by 0.50 mm
inside_corner_radius = 0.40; // Unmeasured metal corner geometry
inside_end_ratio = width_ends / width_middle; // Base taper, before uniform wall reduction

/* [Strength (mm)] */
face = 2.6;

/* [Interior boss (mm)] */
include_boss = true;
boss_diameter = 4.3;
boss_height = 7.1;
bore_diameter = 2.35;
bore_depth = 5.0;

/* [Gauge (mm)] */
gauge_depth = 5.0;

/* [Smoothness] */
profile_segments = 80;
$fn = 64;

assert(length > 0 && width_middle > width_ends && width_ends > 0);
assert(cap_depth > face && face >= 1.2);
assert(rail_length > 0 && rail_width > 0);
assert(length_clearance >= 0 && width_clearance >= 0);
assert(rail_length + length_clearance < length);
assert(side_wall_reduction >= 0);
assert(rail_width + width_clearance + 2*side_wall_reduction < width_middle);
assert((rail_width + width_clearance)*inside_end_ratio + 2*side_wall_reduction < width_ends);
assert(inside_corner_radius >= 0 && inside_corner_radius < rail_width/4);
assert(inside_end_ratio > 0 && inside_end_ratio < 1);
assert(corner_radius > 0 && corner_radius < width_ends/4);
assert(face_chamfer >= 0 && face_chamfer < face);
assert(boss_diameter > bore_diameter && bore_depth > 0);
assert(boss_height > bore_depth && boss_height <= cap_depth-face);
assert(gauge_depth > 0 && gauge_depth <= cap_depth);

// Both boundaries use the SAME bowed/tapered profile family.
// Their length and width envelopes are independently adjustable.
function half_width(y, profile_length, middle_width, end_width) =
    (end_width + (middle_width-end_width) *
    pow(max(0, 1-pow(abs(2*y/profile_length), side_power)), side_taper)) / 2;

module shaped_outline(profile_length, middle_width, end_width, radius) {
    offset(r=radius) offset(delta=-radius)
        polygon(points=concat(
            [for (i=[0:profile_segments])
                let(y=-profile_length/2 + profile_length*i/profile_segments)
                [half_width(y, profile_length, middle_width, end_width), y]],
            [for (i=[profile_segments:-1:0])
                let(y=-profile_length/2 + profile_length*i/profile_segments)
                [-half_width(y, profile_length, middle_width, end_width), y]]
        ));
}

module outer_outline() {
    shaped_outline(length, width_middle, width_ends, corner_radius);
}

module cavity_outline() {
    // Widen the curved cavity by 0.5 mm per SIDE along its full length.
    // Both middle width and narrow-end width receive the same +1.0 mm;
    // scaling only the maximum width would leave the ends undersized.
    base_middle = rail_width + width_clearance;
    inner_middle = base_middle + 2*side_wall_reduction;
    inner_ends = base_middle * inside_end_ratio + 2*side_wall_reduction;
    shaped_outline(rail_length + length_clearance,
                   inner_middle, inner_ends, inside_corner_radius);
}

module outer_body() {
    if (face_chamfer > 0) {
        hull() {
            linear_extrude(height=0.01)
                offset(delta=-face_chamfer) outer_outline();
            translate([0,0,face_chamfer])
                linear_extrude(height=0.01) outer_outline();
        }
        translate([0,0,face_chamfer])
            linear_extrude(height=cap_depth-face_chamfer) outer_outline();
    } else {
        linear_extrude(height=cap_depth) outer_outline();
    }
}

module full_cap() {
    difference() {
        union() {
            difference() {
                outer_body();
                translate([0,0,face])
                    linear_extrude(height=cap_depth-face+0.2)
                        cavity_outline();
            }
            if (include_boss)
                translate([0,0,face])
                    cylinder(h=boss_height, d=boss_diameter);
        }
        if (include_boss)
            translate([0,0,face+boss_height-bore_depth])
                cylinder(h=bore_depth+0.1, d=bore_diameter);
    }
}

module fit_gauge() {
    difference() {
        linear_extrude(height=gauge_depth) outer_outline();
        translate([0,0,-0.1])
            linear_extrude(height=gauge_depth+0.2) cavity_outline();
    }
}

if (mode == "fit_gauge") fit_gauge();
else full_cap();
