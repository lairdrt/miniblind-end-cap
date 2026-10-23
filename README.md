# Miniblind Bottom-Rail End Cap

Parametric OpenSCAD replacement of the protective plastic cap on a miniblind bottom rail. The originals fracture when the blind contacts a windowsill.

**Status: v0.1 photo-derived prototype; not physically fit-tested.** Dimensions are provisional because the rail itself has not yet been measured.

## Project

- [Editable OpenSCAD model](src/end-cap.scad): defaults to complete end cap; switch `mode` to `fit_gauge` for a 5 mm profile test.
- [Measurement notes](docs/MEASUREMENT_NOTES.md): caliper-photo interpretations and outstanding unknowns.
- [Automated mesh build](.github/workflows/build-exports.yml): produces STL and 3MF exports as a GitHub Actions artifact.
- [Additional measurements](reference/README.md): reserved for the metal rail's cross-section and retention details.

The six source photographs and initially generated meshes remain in the original downloadable local project ZIP; they are **not yet uploaded into this remote repository**. Build artifacts are download-only and expire after the workflow retention period, so the SCAD source is authoritative.

## Initial parameters (mm)

| Feature | Starting value | Basis |
|---|---:|---|
| Long axis `length` | 25.0 | Caliper photo |
| Maximum `width_middle` | 15.5 | Caliper photo |
| End `width_ends` | 12.0 | Caliper photo |
| `cap_depth` | 12.7 | Caliper photo |
| `corner_radius` | 0.65 | Visual estimate |
| Shell `wall` | 1.55 | Design choice |
| Impact `face` | 2.6 | Design choice |
| `boss_diameter` | 4.3 | Unverified estimate |
| `bore_diameter` | 2.35 | Unverified estimate |

The model includes the tapered, rounded-rectangle profile, cavity, reinforced closed face and optional blind-hole center boss. It assumes the metal rail goes *inside* the cavity, which needs confirmation.

## Open / print

Open `src/end-cap.scad` in OpenSCAD, F6, and export STL. Default `mode = "final"` shows the full finished cap. For a quick profile-only test set `mode = "fit_gauge"`, export the gauge, then **restore `final`**.

On the Bambu P1S, an initial PLA test can use 0.4 mm nozzle, 0.20 mm layers, 3–4 walls and no supports, with the closed face down. Verify the slice first. The gauge only tests cross-sectional clearance: it does not validate insertion depth, retention, or central-boss interference. Try the gauge on the bare metal bottom rail before printing a whole replacement.

A PETG final part or bumper on the windowsill may improve impact survival, but that is not yet tested.

## Next measurements

Photograph the exposed end of the actual metal blind rail straight-on; measure external width, height and corner shape, plus insertion depth and any center boss engagement. Keep source, documentation and generated exports aligned when adjusting parameters.

## Git / licensing

This repository is the authoritative **published** version for future work. The current published history is new and does not preserve the earlier local ZIP's commit SHA. The first physically fitted design should receive a separate known-good commit/tag.

Original OpenSCAD source and text: GPL-3.0-or-later. See LICENSE.
