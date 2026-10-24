// Miniblind bottom-rail protective end cap
// Copyright (C) 2026. Released under GPL-3.0-or-later.
// X = width; Y = length; Z = depth. Z=0 is the closed end.
// v0.7: true constant-radius circular arcs on both EXTERIOR long sides.
// Measured interior opening preserved independently; fit unverified.

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

/* [Measured interior profile (mm)] */
inside_length = 21.5;
inside_end_width = 10.0;     // 0 mm inward from either end
inside_station = 5.0;       // Distance inward from either end
inside_station_width = 11.5;
inside_center_width = 13.0; // At 10.75 mm inward from either end
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
assert(inside_station > 0 && inside_station < inside_length/2);
assert(inside_end_width > 0 && inside_end_width < inside_station_width);
assert(inside_station_width < inside_center_width && inside_center_width < outer_width_center);
assert(inside_corner_radius >= 0 && inside_corner_radius < inside_end_width/4);
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

// Smooth measured interior through the three supplied width stations.
// The three stations cannot lie on a single symmetric circular arc;
// preserving them requires a varying wall thickness.
function smooth_step(u) = u*u*(3-2*u);
// Endpoint slope comes from the interior's measured width change.
function measured_end_slope() =
    (inside_station_width-inside_end_width)/inside_station;

function inside_target_width(t) =
    let(h=inside_length/2,
        // A small compensation for 0.15mm rounded interior corners.
        // Calibrated against rendered STL terminal-edge width.
        end_nominal=inside_end_width + 1.40*inside_corner_radius,
        u=max(0,min(1,t/h)),
        p=inside_station/h,
        slope=measured_end_slope(),
        a=slope*h,
        base=end_nominal+(inside_center_width-end_nominal)*smooth_step(p),
        b=(inside_station_width-base-a*p*pow(1-p,2))/(p*p*pow(1-p,2)))
    end_nominal+(inside_center_width-end_nominal)*smooth_step(u)
    +a*u*pow(1-u,2)+b*pow(u,2)*pow(1-u,2);

function measured_inside_width(y) =
    inside_target_width(inside_length/2-abs(y));

// The outside and inside are deliberately independent in v0.7.
// The exterior is a true circular arc. The interior preserves the
// three physical fit measurements without claiming a parallel offset.
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
                [measured_inside_width(y)/2,y]],
            [for (i=[inside_segments:-1:0])
                let(y=-inside_length/2+inside_length*i/inside_segments)
                [-measured_inside_width(y)/2,y]]
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
