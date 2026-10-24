# Miniblind Bottom-Rail End Cap

Parametric OpenSCAD replacement of the protective plastic cap on a miniblind bottom rail. The originals fracture when the blind contacts a windowsill.

**Status: v0.6 shared-contour prototype; not physically fit-confirmed.** Both the inside and outside walls now follow the SAME measured bowed width curve, instead of independent profiles. Inside length **21.5 mm**, width **10.0 mm at either end**, **11.5 mm at 5 mm inward**, and **13.0 mm at the center**. The side-wall expansion is **1.25 mm per side** at corresponding normalized stations; the outside remains **25 × 15.5 mm**, with slightly thicker end walls. Inspect the profile before printing.

## Project

- [Editable OpenSCAD model](src/end-cap.scad): defaults to complete end cap; switch `mode` to `fit_gauge` for a 5 mm profile test.
- [Measurement notes](docs/MEASUREMENT_NOTES.md): caliper-photo interpretations and outstanding unknowns.
- [Automated mesh build](.github/workflows/build-exports.yml): regenerates STL and mesh-only 3MF exports, commits them to `exports/` on `main`, and publishes a GitHub Actions artifact.
- [Additional measurements](reference/README.md): reserved for the metal rail's cross-section and retention details.

The six original reference photographs remain in the initial locally downloadable project ZIP and are **not currently stored in this remote repository**. The editable OpenSCAD source is authoritative; STL/3MF exports are regenerated and committed by the source-change build.

## Initial parameters (mm)

| Feature | Starting value | Basis |
|---|---:|---|
| Exterior length `length` | 25.0 | Kept for end-wall strength |
| Exterior maximum width | 15.5 | Derived from 13.0 mm inside + 2×1.25 mm side wall |
| `side_wall` | 1.25 per side | Derived outward contour expansion; minimum wall ~1.25 mm |
| `cap_depth` | 12.7 | Caliper photo |
| `corner_radius` | 0.65 | Visual estimate |
| Inside `inside_length` | 21.5 | Latest physical measurement |
| Inside `inside_end_width` | 10.0 | Width at either end |
| `inside_station` | 5.0 | Distance inward from either end |
| `inside_station_width` | 11.5 | Width at 5.0 mm |
| `inside_center_width` | 13.0 | Width at the center |
| `inside_corner_radius` | 0.15 | Smaller, unverified fillet; terminal mesh width compensated |
| Minimum wall thickness | about 1.25 | Computed from printed mesh cross-section |
| Impact `face` | 2.6 | Design choice |
| `boss_diameter` | 4.3 | Unverified estimate |
| `bore_diameter` | 2.35 | Unverified estimate |

The model includes the tapered exterior, separately measured smooth interior profile, reinforced closed face and optional blind-hole center boss. The interior is one smooth curve constrained by the three measured widths. The outside is generated from the same curve, widened by 1.25 mm on both sides and stretched along the length direction to 25 mm; both walls therefore bow together. This is visually parallel, not an exact constant-normal offset. The previous independent exterior profile (and its conflicting 5 mm width) is no longer used. Physical fit, insertion depth, and retention are not yet validated.

## Open / print

Open `src/end-cap.scad` in OpenSCAD, F6, and export STL. Default `mode = "final"` shows the full finished cap. For a quick profile-only test set `mode = "fit_gauge"`, export the gauge, then **restore `final`**.

On the Bambu P1S, an initial PLA test can use 0.4 mm nozzle, 0.20 mm layers, 3–4 walls and no supports, with the closed face down. Verify the slice first. The gauge only tests cross-sectional clearance: it does not validate insertion depth, retention, or central-boss interference. Try the gauge on the bare metal bottom rail before printing a whole replacement.

A PETG final part or bumper on the windowsill may improve impact survival, but that is not yet tested.

## Next measurements

First inspect the new shared-contour inner/outer walls against the original cap, then test the updated fit gauge. Report where it contacts or remains loose along the sidewalls. If the profile fits, measure/verify insertion depth and center-boss engagement on the complete cap. Keep source, documentation and generated exports aligned when adjusting parameters.

## Git / licensing

This repository is the authoritative **published** version for future work. The current published history is new and does not preserve the earlier local ZIP's commit SHA. The first physically fitted design should receive a separate known-good commit/tag. Source changes trigger automated STL and 3MF publication to `exports/` on the `main` branch.

Original OpenSCAD source and text: GPL-3.0-or-later. See LICENSE.
