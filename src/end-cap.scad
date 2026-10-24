// Miniblind bottom-rail protective end cap
// Copyright (C) 2026. Released under GPL-3.0-or-later.
// X = width; Y = length; Z = depth. Z=0 is the closed end.
// Three physical interior width stations; not yet fit-validated.

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

/* [Measured interior profile (mm)] */
inside_length = 21.5;
inside_end_width = 10.0;     // 0 mm inward from either end
inside_station = 5.0;       // Distance inward from either end
inside_station_width = 11.5;
inside_center_width = 13.0; // At 10.75 mm inward from either end
inside_corner_radius = 0.40;

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
inside_segments = 160;
$fn = 64;

assert(length > 0 && width_middle > width_ends && width_ends > 0);
assert(cap_depth > face && face >= 1.2);
assert(inside_length > 0 && inside_length < length);
assert(inside_station > 0 && inside_station < inside_length/2);
assert(inside_end_width > 0 && inside_end_width < inside_station_width);
assert(inside_station_width < inside_center_width && inside_center_width < width_middle);
assert(inside_corner_radius >= 0 && inside_corner_radius < inside_end_width/4);
assert(corner_radius > 0 && corner_radius < width_ends/4);
assert(face_chamfer >= 0 && face_chamfer < face);
assert(boss_diameter > bore_diameter && bore_depth > 0);
assert(boss_height > bore_depth && boss_height <= cap_depth-face);
assert(gauge_depth > 0 && gauge_depth <= cap_depth);

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

// Two cubic Hermite segments per half, continuous first derivative
// through the 5 mm measurement station and zero slope at the center.
// The measured widths are controlling dimensions, not extra clearance.
function hermite_width(w0, w1, m0, m1, span, u) =
    (2*pow(u,3)-3*pow(u,2)+1)*w0
    + (pow(u,3)-2*pow(u,2)+u)*span*m0
    + (-2*pow(u,3)+3*pow(u,2))*w1
    + (pow(u,3)-pow(u,2))*span*m1;

function measured_inside_width(y) =
    let(
        h = inside_length/2,
        t = max(0, min(h, h-abs(y))),
        // Compensate for 0.4 mm corner rounding, keeping ~10 mm
        // of actual terminal clear width after the offset operation.
        effective_end_width = inside_end_width + 1.8*inside_corner_radius,
        first_slope = (inside_station_width-effective_end_width)/inside_station,
        second_span = h-inside_station,
        second_slope = (inside_center_width-inside_station_width)/second_span,
        at_station_slope = (first_slope + second_slope)/2
    )
    t <= inside_station
    ? hermite_width(effective_end_width, inside_station_width,
                    first_slope, at_station_slope,
                    inside_station, t/inside_station)
    : hermite_width(inside_station_width, inside_center_width,
                    at_station_slope, 0,
                    second_span, (t-inside_station)/second_span);

module cavity_outline() {
    offset(r=inside_corner_radius) offset(delta=-inside_corner_radius)
        polygon(points=concat(
            [for (i=[0:inside_segments])
                let(y=-inside_length/2 + inside_length*i/inside_segments)
                [ measured_inside_width(y)/2, y ]],
            [for (i=[inside_segments:-1:0])
                let(y=-inside_length/2 + inside_length*i/inside_segments)
                [-measured_inside_width(y)/2, y ]]
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
