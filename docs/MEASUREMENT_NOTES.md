# Reference photo interpretation — October 23, 2026

- IMG_7608.jpg: long direction, approximately **25 mm**.
- IMG_7607.jpg: widest side-to-side measurement, approximately **15.5 mm**.
- IMG_7609.jpg: exterior depth, approximately **12.7 mm**.
- IMG_7610.jpg: narrow end width, approximately **12 mm**.
- IMG_7611.jpg: overall scale with caliper.
- IMG_7612.jpg: smooth finished/closed face.

These caliper photos are not orthographic and do not measure the metal rail. Readings are provisional. The cap assumes the metal rail slides inside its cavity, with an optional central blind-hole boss.


## Physical rail measurements — October 23, 2026

- Metal rail outside long dimension: **approximately 21.0 mm** (user measured).
- Original cap inside long dimension: **approximately 21.0 mm** (user measured).
- Metal rail outside short dimension: **approximately 10.0 mm** (user measured).
- Initial cap cavity target: **21.3 x 10.3 mm**, adding **0.30 mm total** clearance on each axis (0.15 mm per side).
- First gauge cavity uses a near-rectangular opening with nominal 0.40 mm inside corner radius. Actual metal corner and side profile remain unmeasured.
- The earlier uniform-wall cavity was approximately 21.9 x 12.4 mm, too large for these measurements.

The 5-mm-deep gauge checks XY fit only. It cannot validate the center boss, engagement mechanism or actual required insertion depth. If the gauge binds, photograph the exposed metal rail end directly along the length axis before changing dimensions.

**Unknowns affecting fit:** aluminum rail cross-section, actual interior opening, intended insertion depth, center boss engagement, retention mechanism, and printing shrinkage. The 5-mm-deep gauge only tests cross-sectional clearance. No physical fit test has been performed.

## Interior silhouette correction — October 23, 2026

The first physical fit gauge failed because the opening was modeled with `square()` (straight long walls), even though the original cap's interior follows its curved, narrowed-at-ends exterior. This was a modeling mistake independent of nominal clearance.

The revised cavity uses the same bowed/tapered parametric outline as the exterior, independently sized to **21.3 mm long x 10.3 mm maximum width**, with proportional narrowing at each end. Profile cross-section extracted from the locally rendered STL at the middle of the 5 mm gauge:

- Y = 0 mm: inner width **10.30 mm**.
- Y = 5 mm: inner width **9.93 mm**.
- Y = 8 mm: inner width **9.27 mm**.
- Y = 9.5 mm: inner width **8.74 mm**.

Both revised local STL models were confirmed watertight and single-body. This checks rendered geometry, not fit against the physical aluminum rail. These widths are **predicted from the source** and should be adjusted after the next real fit test. The metal rail's exact curved profile is still unknown.

## Fit-test revision: widen all curved sides — October 23, 2026

User physical fit feedback on the curved gauge:
1. Interior length acceptable, approximately 0.25 mm oversize: **leave unchanged** (nominal 21.3 mm).
2. Interior width insufficient everywhere along both bowed side walls, including near ends: **increase overall opening by 1.0 mm at every lengthwise station**.
3. Side walls approximately 0.5 mm too thick: moving each inside wall outward by 0.5 mm accomplishes **both** corrections without modifying the exterior (do not apply wall reduction a second time).

New parameter `side_wall_reduction = 0.50` is added per side to both the middle and narrow-end widths **after** applying the original curvature ratio; taper curvature remains unchanged. New opening width at center: **11.30 mm**; end widths gain 1.0 mm as well. The full outer envelope remains 25.0 × 15.5 mm and depth 12.7 mm. This revision does not change the opening length or boss.

Locally rendered OpenSCAD meshes of both full cap and 5 mm fit gauge are watertight, single-body. The sidewall at the center is reduced from 2.60 to **2.10 mm**. This geometry result is not a physical fit confirmation. Test the fit gauge before the full cap.

## Three-station inside-profile replacement — October 24, 2026

**Latest physical measurements supersede all earlier inferred cavity profiles.** The previous 21.3 mm length and 11.3 mm center-width gauge failed. User measured the original interior along its 21.5 mm long axis, from one end, with symmetry around the halfway point:

| From either inside end | Inside width |
|---:|---:|
| 0.0 mm | 10.0 mm |
| 5.0 mm | 11.5 mm |
| 10.75 mm (center) | 13.0 mm |

The new cavity uses two monotonic, C1-continuous cubic Hermite segments **per half**, with zero slope at the center and matched slopes at the intermediate station. This is a smooth interpolation through actual supplied measurements, **not** a uniform expansion of the old curved opening. The exterior shape, overall dimensions, cap depth, central boss, and original corner-radius parameter remain unchanged.

The short end has a 0.4 mm radius, so the unrounded underlying input profile must be slightly wider there: the underlying end width is the measured 10.0 mm plus 1.8× the 0.4 mm corner radius. This 1.8 factor is empirically calibrated to the current OpenSCAD offset behavior at the current radius; recheck mesh station widths if changing the radius.

**Rendered local STL cross-section (gauge at z=2.5 mm):** terminal width 9.979 mm, 5.0 mm from either end 11.500 mm, center 13.000 mm; inside length 21.500 mm. Minimum cross-sectional wall thickness measured from the mesh is approximately **1.25 mm**. Both full and gauge STLs were rendered successfully; gauge mesh validated watertight, one body. These are digital measurements, **not a successful physical fit test**.

Next test: try the revised 5 mm gauge and report whether the new profile is tight, loose or snug at the ends, intermediate stations and center. A full cap still requires separate insertion-depth and boss checks.

## Smooth contour correction — October 24, 2026

User's OpenSCAD visual review rejected the two-piece Hermite interior as looking like nearly straight tapered sides rather than the rounded contours in the original reference photograph. The central issue was contour shape, **not** STL watertightness.

The new cavity is one globally smooth quartic width profile per symmetric half, constrained to the physically measured width stations: nominal terminal width 10.0 mm, 11.5 mm at 5.0 mm from either end, 13.0 mm at the center; total interior length 21.5 mm. Unlike the prior piecewise Hermite, it has no join at 5 mm. The end tangent slope is calculated from the unchanged exterior profile at the corresponding Y station; the center tangent is zero for both profiles.

An exactly parallel constant-thickness offset of the existing exterior **cannot also match all three measured widths**. The exterior at 5 mm in from the 21.5 mm interior end is ~14.96 mm across; a 1.25 mm-per-side constant offset would yield ~12.46 mm, versus the measured 11.5 mm. The new contour therefore follows the exterior's tangents while allowing sidewall thickness to change smoothly.

The interior fillet is reduced from an unverified 0.40 mm to 0.15 mm and the source's raw terminal width is compensated by 1.40 times that radius to maintain the *mesh-measured* opening at the terminal edge. This factor is specific to the current OpenSCAD offset construction and should be rechecked if the corner radius changes.

Locally rendered 5 mm fit-gauge STL cross-section (one closed mesh):
- Inside length: **21.50 mm**
- Width at the terminal edge: **9.98 mm**
- Width 5.0 mm from either end: **11.50 mm**
- Width at center: **13.00 mm**
- Minimum 2D wall distance: approximately **1.25 mm**
- Outside dimensions and center boss: unchanged

The new gauge and full-cap STL each render as a watertight, single connected body. A successful physical fit has **not** been established; inspect contour visually before printing another test.

## Parallel sidewall rebuild — October 24, 2026

**Supersedes the independently modeled exterior**, which produced visibly diverging inner/outer shapes despite several changes to the inside spline. The interior three-station measurements remain the controlling geometry. **The outer outline is now generated from exactly the same sampled interior width curve.** At each normalized station, each outer side is widened by `side_wall = 1.25 mm`. The exterior is also stretched along the length axis to preserve the original 25.0 mm overall length and its stronger 1.75 mm end walls. Both profiles retain their independently controllable corner fillets.

This intentionally changes the *exterior taper*; it does **not** change the measured interior opening. The shape is visually parallel, but the slight difference in the length-axis scale means it is not a mathematically constant normal offset.

The earlier assertion that a parallel outer and measured opening were incompatible only applied to the *previous, independently fixed* outer profile. Once the outer contour is derived from the measured interior, that conflict disappears.

### Locally rendered OpenSCAD mesh inspection (5 mm fit gauge)

| Feature | Measured mesh |
|---|---:|
| Interior length | 21.50 mm |
| Interior width at end | ~10.03 mm at 0.005 mm inward |
| Interior width at 5 mm inward | ~11.50 mm |
| Interior width at middle | ~13.00 mm |
| Exterior length | 25.00 mm |
| Exterior maximum width | ~15.50 mm |
| Minimum wall in XY section | ~1.25 mm |
| Exterior width at 5 mm inward from *interior* end | ~14.25 mm |

The gauge and full cap are each watertight single solids in local OpenSCAD mesh testing. These are measurements of computer-generated geometry, **not evidence of successful fit on the actual metal rail**. Review the new sidewall comparison graphic before printing.

## Exterior circular-arc revision — October 24, 2026

User observed that the outside bow still deforms, because the model stretched a measured interior spline to produce the outer shape. This **v0.7 revision supersedes the shared-spline exterior**: each long exterior side is now ONE geometric circle with fixed, editable radius `outer_side_radius = 45.518 mm`. The exterior center width remains 15.5 mm; end width is computed from circle geometry (~12.0 mm at ±12.5 mm from the center), plus small independent corner fillets. The complete outside length remains 25 mm. Default source mode remains `final`.

Formula for the right exterior side (`y` from the center):
`x(y) = outer_width_center/2 - R + sqrt(R² - y²)`.
The left side is its mirror. Thus the long side's curvature is constant (1/R), unlike the previous independently stretched spline.

**Constraint:** A concentric circular inset with 13.0 mm middle width and 10.0 mm end width over a 21.5 mm length would predict 12.15 mm at 5 mm from the end. The user measured 11.5 mm there. Therefore v0.7 fixes the constant-radius OUTSIDE and retains the measured three-station inside contour separately, giving smooth but variable side-wall thickness. A truly constant-thickness offset would require revisiting at least one measured station or changing the geometric interpretation. Do not describe the complete interior and exterior as exactly parallel.

OpenSCAD 2021.01 rendered the local full part and 5 mm fit gauge successfully. Trimesh inspection: both are one watertight component, external X bounds ±7.75 mm, Y ±12.5 mm, Z 0–12.7 mm (full) or 0–5 mm (gauge). The new outside radius has not been visually or physically accepted by the user yet.


## V0.8 concentric circle revision — October 24, 2026 (ACTIVE)

**This section supersedes the previous station-constrained interior and spline approaches.** Per latest user feedback: **use ONLY 13.0 mm at the center as the controlling inside width**, with a smooth circular curve running from either end to center. The previous 10.0 mm end and 11.5 mm intermediate width observations are no longer modeled as fixed fit requirements.

- Exterior long-side arc radius: **45.518 mm**, unchanged.
- Exterior center width: **15.5 mm**, unchanged; end width approximately 12.0 mm.
- Interior center width: **13.0 mm**, controlling target.
- Both circles use the same center; derived interior radius: **44.268 mm**.
- Wall thickness measured radially between circular side arcs: **1.25 mm** everywhere along those arcs (excluding end and corner transitions).
- Interior opening length: **21.5 mm**, unchanged.
- Model-derived interior width at each nominal end: **~10.35 mm**, not forced to match the previously observed 10 mm.
- Model-derived interior width at 5.0 mm from either end: **~12.25 mm**, not forced to match the previously observed 11.5 mm.
- Center boss, 12.7 mm insertion-depth envelope, corner fillets, and 5 mm gauge retained.
- OpenSCAD local renders and trimesh checks: full cap and 5 mm gauge are single, watertight solids with outside extents **25 × 15.5 mm**.
- **Physical fit remains unknown**. Confirm the circular/parallel appearance in OpenSCAD before trying another gauge.

The circular inside and outside sides share one center, which is geometrically different from the prior approximations that merely matched endpoint tangents.


## V0.9 inward side-wall thickening — October 24, 2026 (ACTIVE)

User reports v0.8 nearly fits and asks to increase both curved side walls **INWARD by 0.75 mm each**, explicitly without increasing exterior length or width. Preserve concentric circles and everything else.

- Exterior profile and bounding box: **unchanged**, width 15.5 mm, length 25.0 mm, exterior arc R=45.518 mm.
- Interior length **unchanged** at 21.5 mm; depth, boss and fillets unchanged.
- Radial wall thickness per curved side: **1.25 -> 2.00 mm**.
- Derived interior circle radius: **44.268 -> 43.518 mm** (same center as exterior).
- Interior center width: **13.0 -> 11.5 mm** (1.50 mm narrower overall).
- The circle determines the other widths: at nominal inside ends ~8.80 mm (previous ~10.35); at 5 mm inward ~10.74 mm (previous ~12.25). These are mathematical predictions, not extra measurements or constrained stations.
- The change is accomplished **once** via `inside_center_width = 11.5`: the existing `side_wall=(outer_width_center-inside_center_width)/2` and `inside_side_radius=outer_side_radius-side_wall` equations produce the requested +0.75 mm per side automatically. No separate wall modifier.

The new gauge requires physical testing. The narrower opening at the ends is an intentional geometric consequence of inwardly offset concentric circular sides; do not confuse this with changing end-wall length.


## V0.10 partial rollback of inward thickening — October 24, 2026 (ACTIVE)

Physical feedback: v0.9 curved walls (2.00 mm radial thickness) were **too thick**. Revert 0.25 mm of the previous +0.75 mm inward change on **each** curved side. This is not a reduction of the full 0.75 mm, and not 0.25 mm total shared between both walls.

| Feature | v0.9 | v0.10 |
|---|---:|---:|
| Curved radial wall thickness per side | 2.00 mm | **1.75 mm** |
| Interior center width | 11.50 mm | **12.00 mm** |
| Interior circular radius | 43.518 mm | **43.768 mm** |
| Computed interior end width | ~8.80 mm | **~9.32 mm** |
| Computed interior width 5 mm inward | ~10.74 mm | **~11.24 mm** |
| Interior length | 21.50 mm | **unchanged** |
| Exterior maximum width | 15.50 mm | **unchanged** |
| Exterior length | 25.00 mm | **unchanged** |
| Exterior side radius | 45.518 mm | **unchanged** |

The only geometric source parameter modified is `inside_center_width` from 11.5 to **12.0**. Existing formulas then derive `side_wall = 1.75` and `inside_side_radius = 43.768`. No independent extra offset is applied. All other feature geometry including center boss, closed face, end walls, fillets, and fit-gauge height stays as v0.9.

These widths are predicted by the parametric circular geometry; the new fit remains to be confirmed physically.
