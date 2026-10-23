# Miniblind Bottom-Rail End Cap

Parametric OpenSCAD replacement of the protective plastic cap on a miniblind bottom rail. The originals fracture when the blind contacts a windowsill.

**Status: v0.2 measured-opening prototype; not physically fit-tested.** The metal rail measures approximately **21.0 x 10.0 mm**, and the first fit gauge targets **21.3 x 10.3 mm**. Metal corner shape and full cap retention are still unverified.

## Project

- [Editable OpenSCAD model](src/end-cap.scad): defaults to complete end cap; switch `mode` to `fit_gauge` for a 5 mm profile test.
- [Measurement notes](docs/MEASUREMENT_NOTES.md): caliper-photo interpretations and outstanding unknowns.
- [Automated mesh build](.github/workflows/build-exports.yml): regenerates STL and mesh-only 3MF exports, commits them to `exports/` on `main`, and publishes a GitHub Actions artifact.
- [Additional measurements](reference/README.md): reserved for the metal rail's cross-section and retention details.

The six original source photographs remain in the initial downloadable local project ZIP and are **not currently stored in this remote repository**. The editable OpenSCAD source is authoritative; exports are reproducible and may initially be missing until the source-change build completes.

## Initial parameters (mm)

| Feature | Starting value | Basis |
|---|---:|---|
| Long axis `length` | 25.0 | Caliper photo |
| Maximum `width_middle` | 15.5 | Caliper photo |
| End `width_ends` | 12.0 | Caliper photo |
| `cap_depth` | 12.7 | Caliper photo |
| `corner_radius` | 0.65 | Visual estimate |
| Rail `rail_length` | 21.0 | Direct user measurement, approximate |
| Rail `rail_width` | 10.0 | Direct user measurement, approximate |
| Total `length_clearance` | 0.30 | First-print allowance (0.15 per end) |
| Total `width_clearance` | 0.30 | First-print allowance (0.15 per side) |
| `inside_corner_radius` | 0.40 | Unverified, to be fit-tested |
| Impact `face` | 2.6 | Design choice |
| `boss_diameter` | 4.3 | Unverified estimate |
| `bore_diameter` | 2.35 | Unverified estimate |

The model includes the tapered, rounded-rectangle profile, cavity, reinforced closed face and optional blind-hole center boss. The metal rail goes *inside* the cavity; the exact end cross-section still requires physical testing. The cavity dimensions are controlled independently of the external dimensions.

## Open / print

Open `src/end-cap.scad` in OpenSCAD, F6, and export STL. Default `mode = "final"` shows the full finished cap. For a quick profile-only test set `mode = "fit_gauge"`, export the gauge, then **restore `final`**.

On the Bambu P1S, an initial PLA test can use 0.4 mm nozzle, 0.20 mm layers, 3–4 walls and no supports, with the closed face down. Verify the slice first. The gauge only tests cross-sectional clearance: it does not validate insertion depth, retention, or central-boss interference. Try the gauge on the bare metal bottom rail before printing a whole replacement.

A PETG final part or bumper on the windowsill may improve impact survival, but that is not yet tested.

## Next measurements

Photograph the exposed end of the actual metal blind rail straight-on to verify corner and taper shape. The bounding dimensions are approximately 21 x 10 mm, but insertion depth and center boss engagement are not yet known. Keep source, documentation and generated exports aligned when adjusting parameters.

## Git / licensing

This repository is the authoritative **published** version for future work. The current published history is new and does not preserve the earlier local ZIP's commit SHA. The first physically fitted design should receive a separate known-good commit/tag. Source changes trigger automated STL and 3MF publication to `exports/` on the `main` branch.

Original OpenSCAD source and text: GPL-3.0-or-later. See LICENSE.
