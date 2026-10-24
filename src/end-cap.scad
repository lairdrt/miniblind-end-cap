// Miniblind bottom-rail protective end cap
// Copyright (C) 2026. Released under GPL-3.0-or-later.
// X = width; Y = length; Z = depth. Z=0 is the closed end.
// v0.10: back off v0.9's inward thickening by 0.25 mm EACH side.
// Outside contour/length unchanged. Walls 1.75mm; cavity center 12.0mm.
// Concentric circular arcs remain; fit not yet confirmed.

/* [Configuration] */
mode = "final"; // [final,fit_gauge]

/* [Overall size (mm)] */
length = 25.0;
cap_depth = 12.7;

/* [Circular exterior (mm)] */
outer_width_center = 15.5;
outer_side_radius = 45.518; // Constant radius of each bowed exterior side
corner_radius = 0.65;
face_chamfer = 0.45;

/* [Concentric interior arc (mm)] */
inside_length = 21.5;
inside_center_width = 12.0; // +0.25mm each side over v0.9; wall = 1.75mm
inside_corner_radius = 0.15;

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
inside_segments = 320;
$fn = 64;

assert(length > inside_length && inside_length > 0);
assert(outer_side_radius > length/2);
assert(outer_width_center > outer_width_ends && outer_width_ends > 0);
assert(cap_depth > face && face >= 1.2);
assert(inside_length > 0 && inside_length < length);
assert(inside_center_width > 0 && inside_center_width < outer_width_center);
assert(side_wall > 0.8);
assert(inside_side_radius > inside_length/2);
assert(inside_corner_radius >= 0 && inside_corner_radius < inside_center_width/4);
assert(corner_radius > 0 && corner_radius < outer_width_ends/4);
assert(face_chamfer >= 0 && face_chamfer < face);
assert(boss_diameter > bore_diameter && bore_depth > 0);
assert(boss_height > bore_depth && boss_height <= cap_depth-face);
assert(gauge_depth > 0 && gauge_depth <= cap_depth);

// Each exterior long side is one genuine circular arc (constant radius).
// End width (~12.0mm at R=45.518) derives from the radius, rather than
// being independently deformed by a spline.
outer_circle_cx = outer_width_center/2 - outer_side_radius;
outer_width_ends = 2*(outer_circle_cx + sqrt(outer_side_radius*outer_side_radius-pow(length/2,2)));
function outer_half_width(y) =
    outer_circle_cx + sqrt(outer_side_radius*outer_side_radius-y*y);

// Two truly concentric arcs, with constant normal separation on sides.
// Derived wall thickness = (15.5-12.0)/2 = 1.75mm.
// Change only center width; do not apply a second offset.
side_wall = (outer_width_center-inside_center_width)/2;
inside_side_radius = outer_side_radius-side_wall;
function inside_half_width(y) =
    outer_circle_cx + sqrt(inside_side_radius*inside_side_radius-y*y);

// Previous 10 mm end and 11.5 mm intermediate station constraints
// are removed. Center width, arc radius and length determine all points.
module outer_outline() {
    offset(r=corner_radius) offset(delta=-corner_radius)
        polygon(points=concat(
            [for (i=[0:inside_segments])
                let(y=-length/2+length*i/inside_segments)
                [outer_half_width(y),y]],
            [for (i=[inside_segments:-1:0])
                let(y=-length/2+length*i/inside_segments)
                [-outer_half_width(y),y]]
        ));
}

module cavity_outline() {
    offset(r=inside_corner_radius) offset(delta=-inside_corner_radius)
        polygon(points=concat(
            [for (i=[0:inside_segments])
                let(y=-inside_length/2+inside_length*i/inside_segments)
                [inside_half_width(y),y]],
            [for (i=[inside_segments:-1:0])
                let(y=-inside_length/2+inside_length*i/inside_segments)
                [-inside_half_width(y),y]]
        ));
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
