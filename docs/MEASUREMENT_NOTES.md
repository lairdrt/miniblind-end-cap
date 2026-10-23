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
