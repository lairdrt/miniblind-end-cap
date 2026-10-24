# Miniblind Bottom-Rail End Cap

Parametric OpenSCAD replacement of the protective plastic cap on a miniblind bottom rail. The originals fracture when the blind contacts a windowsill.

**Status: v0.8 concentric-arc prototype — fit not yet validated.** Both inner and outer long sides are true **concentric circular arcs**, with the 13.0 mm inside center width as the **only controlling interior width measurement**. Exterior radius 45.518 mm, interior radius 44.268 mm; 1.25 mm constant radial wall thickness along each long arc. Interior length remains 21.5 mm. The old 10.0 mm end and 11.5 mm intermediate width constraints have been retired at the user's direction. Predicted interior widths are about 10.35 mm at the ends and 12.25 mm at 5 mm inward. Inspect the new contour before printing.

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
| Exterior maximum width `outer_width_center` | 15.5 | Fixed center-envelope target |
| Constant side arc `outer_side_radius` | 45.518 | Editable circular radius of both exterior sides |
| Exterior end width | ~12.0 | Derived from circle radius and length |
| `cap_depth` | 12.7 | Caliper photo |
| `corner_radius` | 0.65 | Visual estimate |
| Inside `inside_length` | 21.5 | Latest physical measurement |
| `inside_center_width` | 13.0 | Sole controlling interior width |
| `inside_side_radius` | 44.268 | Derived from outer arc minus wall thickness |
| `side_wall` | 1.25 | Derived constant radial wall thickness of long arcs |
| Predicted interior end width | ~10.35 | Inferred from circle; not enforced |
| Predicted interior 5 mm width | ~12.25 | Inferred from circle; not enforced |
| `inside_corner_radius` | 0.15 | Small corner fillets; curved sides remain circular |
| Impact `face` | 2.6 | Design choice |
| `boss_diameter` | 4.3 | Unverified estimate |
| `bore_diameter` | 2.35 | Unverified estimate |

The complete end cap uses the same circle centers for its inner and outer long sides. Setting only the interior center width gives the inner circle radius and a constant 1.25 mm radial separation. Corner transitions and end walls are separately rounded, and the outer shape remains 25 × 15.5 mm. The finished model includes the reinforced closed face and optional hollow center boss. Geometry-render and mesh checks passed locally, but physical fit, insertion depth and boss engagement remain unverified.

## Open / print

Open `src/end-cap.scad` in OpenSCAD, F6, and export STL. Default `mode = "final"` shows the full finished cap. For a quick profile-only test set `mode = "fit_gauge"`, export the gauge, then **restore `final`**.

On the Bambu P1S, an initial PLA test can use 0.4 mm nozzle, 0.20 mm layers, 3–4 walls and no supports, with the closed face down. Verify the slice first. The gauge only tests cross-sectional clearance: it does not validate insertion depth, retention, or central-boss interference. Try the gauge on the bare metal bottom rail before printing a whole replacement.

A PETG final part or bumper on the windowsill may improve impact survival, but that is not yet tested.

## Next measurements

First visually inspect the constant-radius outside arc against the original cap. Confirm the shape before printing the updated fit gauge. Report where it contacts or remains loose along the sidewalls. If the profile fits, measure/verify insertion depth and center-boss engagement on the complete cap. Keep source, documentation and generated exports aligned when adjusting parameters.

## Git / licensing

This repository is the authoritative **published** version for future work. The current published history is new and does not preserve the earlier local ZIP's commit SHA. The first physically fitted design should receive a separate known-good commit/tag. Source changes trigger automated STL and 3MF publication to `exports/` on the `main` branch.

Original OpenSCAD source and text: GPL-3.0-or-later. See LICENSE.
