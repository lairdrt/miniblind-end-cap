// Miniblind bottom-rail protective end cap
// Copyright (C) 2026. Released under GPL-3.0-or-later.
// X = width; Y = length; Z = depth. Z=0 is the closed end.
// Photo-derived prototype only. Not fitted to the actual metal rail.

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

/* [Strength and clearance (mm)] */
wall = 1.55;
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
assert(wall >= 0.8 && 2*wall < width_ends);
assert(corner_radius > 0 && corner_radius < width_ends/4);
assert(face_chamfer >= 0 && face_chamfer < face);
assert(boss_diameter > bore_diameter && bore_depth > 0);
assert(boss_height > bore_depth && boss_height <= cap_depth-face);
assert(gauge_depth > 0 && gauge_depth <= cap_depth);

function half_width(y) =
    (width_ends + (width_middle-width_ends) *
    pow(max(0, 1-pow(abs(2*y/length), side_power)), side_taper)) / 2;

module nominal_outline() {
    polygon(points=concat(
        [for (i=[0:profile_segments])
            let(y=-length/2 + length*i/profile_segments)
            [ half_width(y), y ]],
        [for (i=[profile_segments:-1:0])
            let(y=-length/2 + length*i/profile_segments)
            [-half_width(y), y ]]
    ));
}

module outer_outline() {
    offset(r=corner_radius) offset(delta=-corner_radius)
        nominal_outline();
}

module cavity_outline() {
    offset(delta=-wall) outer_outline();
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
