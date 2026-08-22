# YDLIDAR X2 — sealed enclosure **V2**

Second-generation box. Same concept as V1 (sealed enclosure, 360° window made
from a bought clear tube), redesigned around a **relocated driver board** and a
**flat-plate chassis mount**.

V1 is untouched — `ydlidar_x2_box.scad` / `stl/`. V2 is
`ydlidar_x2_box_v2.scad` / `stl_v2/`.

---

## What changed, and why

| | V1 | V2 |
|---|---|---|
| Body footprint | 104.03 × 78.60 | **104.03 × 68.30** |
| Max envelope | 104.03 × 78.60 | **104.03 × 75.60** ← lid cap, see below |
| Height | 79.50 | **66.90** |
| Vendor bracket | used | **deleted** |
| Driver board | inside | **outside the box** |
| Chassis screws | dropped in from inside | **up from under the chassis, blind inserts** |
| Parts | tub + collar + lid + tube | same |

**The height saving is the real win.** The vendor bracket turned out to be
nothing but a 14.67 mm spacer whose only job was holding the lidar *above* the
driver board. With the board relocated, the bracket has no purpose: the lidar
bolts straight onto three 3 mm bosses off the box floor, using its own three
tapped holes. Everything above it drops by **11.67 mm**.

### The footprint did NOT shrink the way it first looked

The lidar's own **motor-and-belt tail** runs out to X = 96.65 — *that* is what
sets the 104 mm length, not the driver board (which sits tucked under the lidar
body, entirely inside its envelope). Removing the board saves zero length.
X = 104.03 is a hard floor for this lidar.

### And Y is floored by the lid, not the body

The body is now 68.30 wide, but the **lid cap is Ø75.60** and overhangs it.
Ø70 is the smallest clear tube that clears the Ø60.5 head — 65 is not made in
acrylic and Ø60's bore is too small — so ~75.6 is a hard floor on Y for any
full-360° window. **Plan the installation around 75.60 mm, not 68.30.** The
narrower body still buys clearance at chassis level and ~15 % less material.

---

## Bill of materials

- 3 × printed parts: `tub`, `collar`, `lid`
- 1 × **clear tube, Ø70.0 OD × 2.0 wall × 15.5 long, CAST PMMA** (see V1 README
  "Tube sourcing" — unchanged, and still unbought)
- 3 × **M3 socket-head screws, ~10 mm** — up through the floor into the lidar's
  own tapped holes. *Confirm the thread and the tapped depth first (below).*
- 3 × **M3 bonded seal / O-ring** under those heads — these are the only
  through-holes in the floor, so they are the only leak path.
- 4 × M3 heat-set inserts + 4 × M3 × 8 — collar down onto the tub posts
- 4 × M3 heat-set inserts — chassis, blind, opening downward
- 4 × M3 screws for the chassis, length = plate thickness + 5 mm
- Silicone bead for both tube grooves

## Key dimensions

- Body **104.03 × 68.30**, total height **66.90**
- Widest point **Ø75.60** (lid cap), at z = 61.9 … 66.9
- Free window span z = 46.4 … 55.9 (laser needs 47.63 … 52.33 — clears both ends)
- Head radial clearance inside the tube: 2.75 mm
- Lid underside sits 2.25 mm above the top of the rotating head (z = 53.65)
- Collar flare 34.06° from vertical — prints unsupported
- Lidar body underside sits 18.0 mm above the floor (cable run)

---

## MEASURE THIS BEFORE PRINTING

The lidar's mount is taken from the vendor CAD in `ref/`, not from your unit.
It is the one thing that will scrap a print if it is wrong. Please caliper:

1. **Thread size** in the three holes on the underside of the lidar's feet.
   CAD shows a Ø2.46 minor diameter, which is an **M3 tap** — but M2.5 is
   plausible on some batches. Try threading an M3 screw in by hand.
2. **Tapped depth** of those holes — how deep does the screw go before it
   bottoms? This sets the screw length. The box eats 5.8 mm before the screw
   reaches the lidar, so an M3 × 10 leaves 4.2 mm of engagement.
3. **Hole spacing**, to confirm the pattern:
   - the two holes on the motor side: **36.00 mm** apart
   - motor-side holes to the single opposite hole: **71.27 mm** in X
   - the single hole sits on the centreline of the other two (0.01 mm off), so
     the pattern is a symmetric isosceles triangle
4. **Foot pad thickness / leg height** — CAD says the feet are **15.00 mm**
   below the lidar body. If yours differs, change `LEG_H`.
5. **Overall length over the motor tail** — CAD says **96.23 mm** from the
   opposite end. This sets the 104 mm box length.

If any number differs, edit the `MEASURED LIDAR GEOMETRY` block and re-export;
the asserts will catch anything that stops fitting.

---

## Printing

Every part is exported already resting on z = 0 in its print orientation — do
not re-orient in the slicer.

- 0.15 mm layers, 0.4 nozzle, brim (no raft), **no supports anywhere**
- `tub` — floor-down. Corner posts run to the floor and merge into the corner
  fillets. The blind insert holes open downward and bridge over Ø4 — trivial.
- `collar` — flat face down. It flares outward at 34° from vertical on the Y
  sides; that is well inside what prints unsupported.
- `lid` — already flipped upside down, flat top on the bed.
- Wall is 2.4 mm = 6 perimeters at 0.4 nozzle. Keep perimeters ≥ 4.

## Sliced G-code — Raise3D N2

Ready to print, in `LIDAR gcode v2/`, sliced with `n2_pla_lidarbox_v2.ini`.

| Part | Time | PLA | Layers | Height |
|---|---|---|---|---|
| `tub` | 10 h 26 m | 75.9 g | 306 | 45.95 |
| `collar` | 2 h 15 m | 17.3 g | 42 | 6.35 |
| `lid` | 1 h 39 m | 16.2 g | 33 | 5.00 |
| **total** | **14 h 19 m** | **109.3 g** | | |
| `collar+lid_plate` | 3 h 53 m | 33.3 g | 42 | 6.35 |

### Print the collar and lid first

`ydlidar_x2_v2_collar+lid_plate.gcode` puts both flat parts on one 189.6 mm
plate — one job, 3 h 53 m, instead of two heat-up cycles. Print this while you
caliper the lidar's three mounting holes: neither part depends on that pattern,
so they are safe to commit to, whereas the 10-hour `tub` carries the whole
mount and is the one that gets scrapped if the CAD and your unit disagree.

The plate comes from `plate_collar_lid.scad`, which **imports the two exported
STLs** and offsets the lid by 107.95 mm. It does not re-derive the geometry, so
the plate is provably the same solids that passed the clash and solid-body
checks — verified: 2 components, volumes 19419.55 and 20188.06 mm³, identical
to the individual parts.

Do not try to make this plate with the PrusaSlicer CLI. Passing it two STLs
slices them **separately and overwrites the first with the second**, and
`--merge` also produced the lid alone — in both cases it exits 0 and writes a
plausible file that silently contains one part. The tell is the reported
weight: a real plate is 33.3 g, a bad one is 16.2 g.

Verified on the output: **zero support extrusions** in all three, no overhang
warning from the slicer (the collar's 34° flare and the tub's blind-hole
bridges both pass), and every extrusion inside the 300 × 300 bed.

The 0.05 mm shortfall on `tub` and `collar` height is layer quantisation
(0.20 first layer + n × 0.15) and is harmless — it lands on the tub/collar
joint face, which the screws and silicone close anyway.

To re-slice:

```bash
cd /c/Users/HP/lidar_box
PS=/c/Users/HP/Tools/PrusaSlicer-2.9.6/prusa-slicer-console.exe
for p in tub collar lid; do
  "$PS" --export-gcode --load n2_pla_lidarbox_v2.ini \
    -o "LIDAR gcode v2/ydlidar_x2_v2_$p.gcode" "stl_v2/ydlidar_x2_v2_$p.stl"
done
```

**Caveat, unchanged from V1:** the start/end G-code is hand-written generic
Marlin, not ideaMaker's official Raise3D profile. It homes, heats, and runs a
prime line at Y6, uses absolute E (`M82`), and does **no** `G29` — the N2 is
manually levelled. Watch the first layer.

## Assembly order

1. Heat-set the 4 chassis inserts into the **underside** of the tub floor, and
   the 4 collar inserts into the post tops.
2. Bolt the box to the chassis: screws come **up from under the chassis plate**
   into the floor inserts. Do this first — the lidar blocks the access later.
3. Drop the lidar in, seat its 3 feet on the bosses, and run the 3 M3 screws up
   from underneath with a seal under each head.
4. Route the cable out the notch in the tub rim and on to the driver board,
   which now lives outside the box.
5. Seat the tube in the collar groove, drop the lid groove over the top,
   silicone both grooves.
6. Screw the collar down onto the 4 posts.

---

## Re-exporting

**Use bash (Git Bash), not PowerShell.** PowerShell strips the inner quotes off
`-D part="tub"` no matter how you escape them; OpenSCAD then sees an unknown
variable, falls back to the `else` branch and **silently writes the assembly
into your part file**. It exits 0 and the STL looks plausible. The first
`echo` is `PART = ...` — check it says the part you asked for, every time.

```bash
cd /c/Users/HP/lidar_box
OS=/c/Users/HP/Tools/openscad-nightly/OpenSCAD-2026.07.20-x86-64/openscad.exe
for p in tub collar lid; do
  "$OS" --backend=manifold -o "stl_v2/ydlidar_x2_v2_$p.stl" --export-format=binstl \
    -D "part=\"$p\"" ydlidar_x2_box_v2.scad
done
```

Use the **nightly with `--backend=manifold`**, not `tools/openscad-2021.01`.
The 2021.01 CGAL kernel cannot boolean imported meshes at all, so the clash
checks below will not run on it. Renders take seconds instead of minutes.

## Verifying an export

Three independent checks. Run all three; each has caught a different failure.

**1. Clash checks — the real verification.** These intersect the printed
solids with things that must never be touched, so a correct design produces an
*empty* result. Renders cannot prove this; these can.

```bash
for c in clash_beam clash_lidar; do
  "$OS" --backend=manifold -o "stl_v2/_$c.stl" --export-format=binstl \
    -D "part=\"$c\"" ydlidar_x2_box_v2.scad
done
python tools/clashcheck.py stl_v2/_clash_lidar.stl stl_v2/_clash_beam.stl
```

Expected:

```
_clash_lidar.stl   510 facets, volume 0.00005 mm3  -> CONTACT ONLY
_clash_beam.stl    EMPTY export -> CLEAR (nothing intersects)
```

`clash_beam` must be **empty** — anything at all there is a permanent blind
sector in the point cloud. `clash_lidar` is expected to report three
zero-volume patches at z = 3.000: those are the bosses seating against the
lidar's feet. Any *volume* is a real collision. This check already earned its
keep — rounding `FOOT_Z` from 14.669 to 14.70 buried the feet 0.03 mm into the
bosses, and nothing else would have shown it.

**2. Solid-body check.**

```bash
python tools/stlcheck.py stl_v2/ydlidar_x2_v2_*.stl
```

Expect **1 component, positive volume** per part. Expected z extents:
`tub` 0…46.0, `collar` 0…6.4, `lid` 0…5.0. In V1 a subtracted chamfer cone
wider than the lid severed it into two pieces and still exported clean — V2
builds that chamfer from stacked cylinders instead, because a union cannot cut
a part in half.

**3. Staleness.** STLs carry no record of the parameters that made them, and an
edit after an export silently orphans them. The `.scad` must be **older** than
every STL:

```bash
ls -la --time-style=+%H:%M:%S ydlidar_x2_box_v2.scad stl_v2/*.stl
```

### Assertions

Unlike V1, the critical clearances are `assert()`ed, so a bad parameter fails
the export loudly instead of producing a plausible wrong file: laser band vs
collar and lid, rim vs motor tail, head vs tube bore, collar flare angle,
material left under the counterbores and at the inserts, and cable room under
the lidar. `boss_h` is the master height knob — everything above scales with it.

## Tools

| Path | What |
|---|---|
| `tools/measure_ref.py` | bounding boxes of every `ref/` part in box coordinates |
| `tools/occupancy.py` | coarse plan-view occupancy map per part |
| `tools/down_planes.py` | every down-facing plane and its area — finds mounting faces |
| `tools/find_holes.py` | bolt-hole centres and diameters on a flat face |
| `tools/clashcheck.py` | verdict on a clash export: clear / contact / interference |
| `tools/stlcheck.py` | connected components + signed volume per part |
| `tools/ref_view.scad` | one colour per reference part, to identify them |
