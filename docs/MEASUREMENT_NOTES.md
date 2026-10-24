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


## V0.11 wider curved sides with fixed 12.5 mm midpoint — October 24, 2026 (ACTIVE)

Following the v0.10 gauge feedback, the user confirmed the proposed interpretation: **increase both circular side radii to open the sides near the ends**, while keeping the inner and outer arcs concentric/parallel and setting the interior center width to **12.50 mm**. This supersedes v0.10's 12.00 mm center target.

The previous exterior and interior shared circle center remains the architecture. Two source parameters change together:
- `inside_center_width`: 12.00 -> **12.50 mm**, thus radial wall thickness 1.75 -> **1.50 mm** per curved side.
- `outer_side_radius`: 45.518 -> **55.000 mm**, a modest larger-radius / flatter circular bow that opens side clearances as one moves away from the midpoint.
- Derived inner radius: **53.500 mm**. Both arcs remain concentric and constant-radius, with **1.50 mm radial separation**.
- Unchanged: outside overall length **25.0 mm**, max outside width at midpoint **15.5 mm**, inside overall length **21.5 mm**, depth **12.7 mm**, end/inside fillets, boss, face thickness, full-model default and gauge depth.
- **The exterior widths away from the center will change**, intentionally: outside width at the ends grows from ~12.00 to **~12.62 mm**. This does not change overall max width or length.
- Circle-predicted inside width at the ends: **~10.32 mm**; at 5 mm inward: **~11.88 mm**; at midpoint: **12.50 mm**. The end/intermediate values are predictions, not separately fitted constraints.

The user approved this direction as a trial. Verify generated STL measurements and inspect visually before physical fit; no new test result has been received.


## V0.12 interior short-end retention stubs — October 24, 2026 (ACTIVE)

**Confirmed fit checkpoint:** User physically tested v0.11 fit gauge and reported "Fits good". Preserve the established **12.5 mm center cavity width**, concentric circular sidewalls (outer R55.0, inner R53.5), interior length **21.5 mm**, and original 25 × 15.5 × 12.7 mm exterior envelope without modification.

User now requests **one friction/retention stub centered on the inner face of EACH short end wall** (not on the long curved sidewalls). Both stubs are the same, symmetric, and feature-flagged:

- `include_retention_stubs = true` for the default full cap.
- `stub_width = 4.0 mm` along X, centered at X=0 on each short inner end wall.
- `stub_length = 5.0 mm` along Z (insertion/depth axis), immediately above the closed inner floor, starting at `z = face = 2.6 mm` and ending at `z = 7.6 mm`. This is the user's "down the face of the wall toward the filled-in cap end" direction.
- `stub_projection = 2.0 mm` in Y, protruding into the cavity (toward Y=0).
- `stub_embed = 0.20 mm` in Y behind the wall face, for a reliable solid union. This extra embedded portion is NOT an additional in-cavity projection.
- The short inner walls are at Y=±(inside_length/2)=±10.75 mm. Thus the stub faces project to Y=±8.75 mm in their local 4 mm wide X bands. This intentionally reduces the free opening along Y by **4.0 mm locally**, even though the nominal cavity length stays 21.5 mm elsewhere.
- The proven v0.11 open-ring `fit_gauge` remains **unchanged and stub-free**; only `mode="final"` receives retention features.
- `include_boss`, floor/face, bore and all other parameters remain as before.
- **User-requested ramped `/---\\` profile:** Each stub is a trapezoidal prism (not a square block), with a 2.0 mm sloped lead-in encountered first from the cap opening, a 2.0 mm full-height flat gripping plateau, and a 1.0 mm trailing ramp toward the closed face. Their summed Z length is still 5.0 mm; maximum in-cavity projection remains 2.0 mm.
- The ramp makes initial insertion more gradual, but **2 mm projection on two opposed walls is still an aggressive press fit for a rigid rail**. Test carefully without forcing or breaking the rail/cap. `stub_projection`, `stub_lead_ramp`, and `stub_trailing_ramp` are independently adjustable.


## V0.13 stub placement correction — October 24, 2026 (ACTIVE)

User confirms v0.12 trapezoidal retention stubs are **too low** on the interior short-end wall face when viewed from the open mouth. Center EACH stub both horizontally and vertically on the inside wall face.

- X center: **0.00 mm**, unchanged, centered across the inner short wall.
- Vertical wall face spans **Z=2.60 mm** (inner closed floor) through **Z=12.70 mm** (open mouth). Total inner wall height = **10.10 mm**.
- The vertical mid-height of the wall is therefore **Z=7.65 mm**.
- 5.00 mm-long retention stub centered on that face occupies **Z=5.15–10.15 mm**, leaving **2.55 mm space at both the open and closed ends**.
- Compared to v0.12's **Z=2.60–7.60 mm**, this moves both retention stubs **+2.55 mm toward the open end**. It does **not** increase projection or length.
- Same ramp orientation: from the opening (Z high), 2.00 mm lead-in slope, 2.00 mm raised plateau, 1.00 mm trailing slope toward the floor. Plateau occupies **Z=6.15–8.15 mm**.
- Symmetric Y positions remain **±10.75 mm** at the short walls; 2.00 mm maximum projection toward Y=0, 0.20 mm union overlap into the wall.
- The 4 × 5 × 2 mm stub dimensions, outer shell, confirmed 12.5 mm centered curved cavity, 21.5 mm inner length, boss, and existing unchanged/stub-free fit gauge all remain exactly as before.
- Physical retention/installation has not yet been tested; verify visually and install gently because two 2 mm opposed projections may exert significant pressure.


## V0.14 move the two short-end retention stubs toward the lip — October 24, 2026 (ACTIVE)

User directed a **pure vertical translation** of both v0.13 stubs until their top edges are **2.00 mm below the open lip**. Do not alter horizontal centering, either short-end Y position, stub shape, size, ramp orientation, inward projection, overlap, shell, center boss, or the fit-confirmed hollow profile.

- Cap opening is at **Z=12.70 mm**. The top edge of each stub is therefore **Z=10.70 mm**.
- The two 5.00 mm-long stubs now extend **Z=5.70 to 10.70 mm** (center **Z=8.20 mm**).
- From v0.13's Z=5.15–10.15 mm, this is a **+0.55 mm displacement along +Z toward the open mouth**, nothing else.
- Horizontal center is still **X=0**. Stub width along X remains 4.00 mm.
- Short end walls remain at **Y=±10.75 mm**, with 2.00 mm maximum inward projection and unchanged 0.20 mm embedding.
- Open-mouth-side 2.00 mm lead-in, 2.00 mm plateau, closed-side 1.00 mm trailing ramp stay unchanged.
- The shape-fitted v0.11/v0.13 hollow opening remains **12.50 mm at midpoint** with 21.50 mm inner length; outside is still 25.00 × 15.50 × 12.70 mm.
- The `fit_gauge` is explicitly unchanged and stub-free; only `mode="final"` places stubs.

The stub's lip clearance is a parametric `stub_top_clearance = 2.0`; its starting Z is `cap_depth - stub_top_clearance - stub_length`. Physical retention has not yet been verified.


## Final fit-accepted design — October 24, 2026

**User confirmation: "Fits fine, thank you"** after inspecting/testing v0.14 complete end cap with both short-wall retention tabs. This closes the iterative fit phase. Treat the final model as a **known-good design**; earlier "unverified" statements in this chronological log describe historical prototypes, not the present accepted model.

Accepted invariants:
- Outer overall 25.0 mm long × 15.5 mm maximum wide × 12.7 mm deep.
- Circular long outside walls: R55.0 mm. Inside walls concentric: R53.5 mm.
- Interior length 21.5 mm, center interior width 12.5 mm, radial long-wall thickness 1.5 mm.
- Closed floor/face thickness 2.6 mm. Hollow center boss retained.
- Two opposite inside SHORT-wall trapezoidal friction tabs: X-centered, 4.0 mm across, 5.0 mm along Z, maximum 2.0 mm inward projection. 2.0 mm lead-in / 2.0 mm plateau / 1.0 mm trailing taper.
- Top edge of each tab **2.0 mm below the open lip**, so Z=5.7–10.7 mm; Y remains at ±10.75 mm short wall, X=0.
- Source defaults to the full finished cap; historical 5 mm `fit_gauge` remains separately exportable and unchanged.
- Latest **fit-accepted source** commit: `49fb17565e1882e281f49856c0465950582f5aa9`. Generated exports on main belong to that geometry (and may be re-rendered with different mesh triangle ordering).
- OpenSCAD views of the actual final model are maintained in `docs/images/` by the automated build, separate from the original reference photographs (not stored on GitHub).

Status: **completed for now; no further dimensional changes authorized.** Differences in future rail profiles, materials, or print calibration may still need independent fit checks.
