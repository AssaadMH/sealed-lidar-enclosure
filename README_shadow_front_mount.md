# SHADOW 4WD — front lidar drop mount (rev B)

Puts the **bare YDLIDAR X2 under the Kinect**, hung from the reserved deck's
underside on a front-overhanging arm.

Source: `shadow_front_mount.scad` · STLs: `stl_mount/shadow_fm_*.stl`

**Not printed, not fitted.** Five robot dimensions still need confirming (see
the bottom of this file) — but those set *tube cut lengths only*, not the
fittings, so **all three parts are sliced and ready**.

**rev B** replaced the separate splayed impact guard with a **C-section cradle**
and dropped `BEAM_Z` from 330 to 320 mm.

---

## Why this geometry

Three constraints fight each other, and the design sits in the small window
where all three hold.

| Constraint | Rule | At the chosen numbers |
|---|---|---|
| Coverage | `360 − 2·atan((W/2) / overhang)` | 200 mm overhang → **221.6° usable / 138.4° masked** |
| Nose-dive | beam must strike the floor beyond `max_range` | 320 mm → strike at **9163.6 mm** vs an 8000 mm cap (margin 1163.6) |
| Kinect cone | the shroud roof must stay under the cone's lower edge | needs 194.3 mm, has 209.8 mm (**margin 15.5 mm**) |

The 221.6° is the number that matters: it is where your measured **220°** comes
from. A 200 mm overhang on a 1053 mm body gives exactly that. The Under-Deck
Sensor Plan's 240° would need a **304 mm** overhang — it was never achievable at
the 140 mm bracket that document specifies.

**The bare X2 is what makes this work.** Its head top is only **3.7 mm** above
its own laser band (band 44.63–49.33 mm above the feet, head top 50.65 mm). The
V2 sealed box is 66.9 mm tall and its top corner would drive straight into the
Kinect's cone.

Dropping `BEAM_Z` 330 → 320 bought the cone margin back from 12.0 to **15.5 mm**
and cost 286 mm of nose-dive strike distance, which had 1450 mm to spare.

### The rule that shapes the whole part

Nothing may cross the scan plane. So the **arm and cradle sit entirely below the
beam band**, and the **vertical post** — which has to cross it — is parked at the
chassis front face, inside the shadow the chassis already casts. It subtends
±3.5° against a ±69.2° chassis shadow, so it costs nothing. That is asserted,
not assumed.

---

## Parts

Three printed fittings on a **20 × 20 aluminium tube** backbone.

| Part | STL | Volume | Prints |
|---|---|---|---|
| `cradle` | `shadow_fm_cradle.stl` | 90.7 cm³ | **on its side** — C profile in the bed plane, extruding up |
| `elbow` | `shadow_fm_elbow.stl` | 33.3 cm³ | arm socket lying, vertical socket rising |
| `deck_clamp` | `shadow_fm_deck_clamp.stl` | 66.7 cm³ | flange face down, socket rising |

All three export sitting at z ≥ 0 needing no support. **Do not re-orient them.**

The cradle printing on its side is not arbitrary: base-down would leave the roof
as a **110 mm unsupported bridge**. On its side the whole C profile lies in the
bed plane and extrudes straight up — zero overhang, ~1400 mm² of bed contact.

### The C-section shroud (replaces the separate guard)

rev A carried a **separate sacrificial impact guard**: walls splayed 30° from
vertical on four L-feet, bolted to the cradle through heat-set inserts. It is
**gone**, and its whole parameter block with it.

The cradle is now a **C** lying on its side, opening forward: base under the
lidar, rear wall behind it, roof over the top, **no side walls**.

- **The roof is free.** A 2D lidar is blinded only by what sits *in its own
  plane*, so a slab overhead costs no coverage at all. Roof underside sits at
  **53.15 mm**, clearing the head top (50.65) by 2.5.
- **The rear wall is free too** — it lives inside the already-masked rear
  sector, subtending ±28.8° against the chassis's own ±69.2° shadow.
- **The side walls were the problem.** rev A's splayed walls stood beside the
  lidar, right where coverage is worth something. Deleting them is why the
  guard could be absorbed rather than re-bolted.
- No bolted joint, no inserts, no second part to reprint.

The trade: the shroud is no longer sacrificial. A hard enough hit now costs the
cradle, not a 40 cm³ bumper. That was judged worth it for the coverage and the
deleted joint — revisit if the vehicle actually starts hitting things.

**★ The side chamfer is STEPPED, not hulled.** `hull()` takes the *convex* hull,
and this profile is a C — hulling it fills the cavity solid and drops a slab
straight through the laser band. That cost 1189 mm³ of blind sector the first
time. Stacked `offset()`s cannot fill anything.

### The three foot screws set the arm layout

They enter from below, so the arm must leave hex-key room at each one. The
cradle socket is sized to fill exactly the X gap between the front foot and the
two rear feet — **x 14.37 to 67.14**. Running it the full length of the cradle,
as rev A did, left only **1.16 mm** beside the rear counterbores: the holes
cleared but no driver would fit. Now the bare tube clears them by **4.71 mm**.

### ★ Ream the three foot holes before assembly

The cradle prints on its side, so its three M3 foot holes come out as
**horizontal bores** — drilled through in the bed plane, which droops the top of
each bore slightly. True at any layer height, more so at 0.30. Run a 3.4 mm
drill through them by hand before offering the part up to the lidar; the
clearance is only 0.2 mm a side.

### Cut list

| Member | Length | Stock |
|---|---|---|
| Horizontal arm | **225.68 mm** | 20 × 20 × 2 alu |
| Vertical post | **355.98 mm** | 20 × 20 × 2 alu |

**★ Cut the post to 355.98, not 372.98.** The echo also reports a *deck-to-arm
drop* of 372.98 mm — that is the clear span, not a cut length; `POST_LEN`
subtracts the deck-clamp flange and stops at the arm centreline. Two echoes used
to both read "vertical tube … long"; the first is now labelled as not-a-cut.

### Why metal, not one printed part

The drop does not fit the N2's 300 mm bed. Stiffness was never
the issue: a 20 × 20 × 2 alu tube deflects **0.012 mm** at the lidar under its
0.25 kg. The drivers are bed size and PLA creep.

The drop is now **347 mm** (deck 620 − feet plane 273.0).

**Print these in PETG or ASA, not PLA.** This is an outdoor vehicle in Tunisia —
PLA's glass transition is ~60 °C, which a parked robot in the sun will reach, and
it creeps under sustained cantilever load. That is a change from the enclosure
work, which was all indoor PLA.

## Hardware

| Qty | Item | Where |
|---|---|---|
| 3 | M3 × 10 SHCS | cradle → the lidar's own tapped feet, from below |
| 4 | M4 × 30 + nyloc | tube cross-bolts, 2 per socket |
| 2 | M4 × 30 + nyloc | vertical socket at the elbow |
| 4 | M5 | deck clamp → deck underside, 62 mm square pitch |
| 4 | M5 | cradle → robot arm, through `UBOLT` |

---

## Verification

Re-run in full on rev B (2026-08-22):

- **`clash_beam`** — everything forward of the chassis face, intersected with the
  full 900 mm beam band: **EMPTY export**. Control: fattening the tube sockets
  gives **36,221 mm³ × 2**, so the check moves when the input is wrong.
- **`clash_lidar`** — printed parts against the real vendor meshes in `ref/`:
  **3 bodies, 0.00005 mm³ total, all at z = 0**, at X 1.92–8.28 / 73.22–79.58 —
  exactly the three foot pads. Feet seat flat, nothing else touches.
- **`stlcheck`** — all three fittings: **1 component, SOLID, z = 0.00**.
- 8 asserts covering nose-dive, the Kinect cone, the post's angular shadow, the
  arm staying under the beam, and socket engagement.

### ★ Two verification traps caught on rev B

**1. `clashcheck.py` was binary-STL only and would have lied.** It read bytes
80:84 as a facet count unconditionally. The nightly exports **ascii** unless you
pass `--export-format binstl`, so it was parsing ascii text as a struct — here it
crashed, but a different byte pattern parses as a small facet count and prints a
confident **false `CLEAR`**. The tool now sniffs the header, parses ascii
properly, and *rejects* a binary file whose length disagrees with its own facet
count. Verified by running the same geometry through both paths: identical
verdict, 508 facets / 0.00005 mm³.

**2. The cradle exported 0.01 mm below the bed.** The stepped side chamfer
extrudes each step `t + 0.01` so neighbours merge. The far-side loop placed each
step at `W-(i+1)*t` and grew *upward*, so the outermost step reached **W + 0.01**
— 0.01 proud of the side face, and that face is the one that lands on the bed.
The near-side loop grew inward and was clean, so the part was oversize on one
side only. Both merge overlaps now grow inward. Same class as the ceiling
mount's upstand that protruded past its bed face.

**Geometry-neutral cleanup, proved.** The dead rev-A guard parameters
(`GUARD_T/H/LEAN/RAKE/BASE`, `TAB_D`, `TAB_OUT`, `G_PAT`, `BOSS_H`,
`m3_insert`, `insert_d`, and the `GX0/GY/GDY/GBOLT` chain) were all defined and
never referenced — plus an `echo` still printing a `GUARD:` line for a part that
no longer exists. All removed; only the clearance survives, renamed `CLR_GAP`.
Re-exported afterwards and the volumes came back **identical to the digit**
(90715.46 / 33341.78 / 66661.10), which is what proves the cleanup moved nothing.

---

## Slicing

Profile: **`n2_petg_shadow_mount.ini`** — Raise3D N2, **PETG**, new for this part.
Deliberately not the enclosure's PLA profile: 5 perimeters, 40 % gyroid, fan held
to 30–50 % (PETG layer adhesion is what a cantilever lives on), bed 80.

Two profiles, both PETG. **The fast set is the one to print.**

| Part | fast (0.30) | fine (0.20) |
|---|---|---|
| `cradle` | **4 h 09 m** / 98.20 g | 10 h 37 m / 107.19 g |
| `elbow` | **2 h 09 m** / 40.03 g | 4 h 16 m / 41.31 g |
| `deck_clamp` | **2 h 46 m** / 54.60 g | 6 h 01 m / 63.07 g |
| **total** | **9 h 04 m / 192.83 g** | 20 h 55 m / 211.57 g |

`n2_petg_shadow_mount_fast.ini` takes layers 0.20 to 0.30, bead 0.45 to 0.52,
perimeters 5 to 4, infill 40 % to 22 %. **The cradle is 93 % perimeter** — it
extrudes 84.4 cm³ against a 90.7 cm³ solid — so layer height and bead width are
the whole clock; infill density barely registers. Shell goes 2.25 to 2.08 mm,
8 % thinner, against a 0.25 kg lidar on a tube that deflects 0.012 mm. Thicker
PETG layers also bond *better*, carrying more heat into the layer below. The
cost is visible stepping on the curved corners of a part that lives under a
robot deck.

`max_volumetric_speed = 9` is what actually caps the fast profile — at
0.30 × 0.52 a 45 mm/s perimeter is already 7.0 mm³/s. Raising the speed numbers
further would only under-extrude.

All sliced clean: **0 support material**, bridge regions only at the square
tube-socket ceilings. PrusaSlicer raises *"consider enabling
supports"* on those bridges — **ignore it.** Support inside a tube socket cannot
be removed.

Sanity check on the weights, per the multi-part trap: elbow 32.53 cm³ extruded
vs 33.34 cm³ solid is ~98 %, which is right for a thin-walled part whose 3.2 mm
socket walls are almost entirely perimeter; deck clamp 49.66 vs 66.66 cm³ is
75 %, right for a chunky part at 40 % infill.

Slice **one STL per run** — PrusaSlicer's CLI cannot build a multi-part plate,
and the second STL silently overwrites the first.

---

## Resolved: the foot triangle

`LIDAR_FEET` comes from **vendor CAD, never from the physical unit**, so it was
the one dimension that could invalidate the cradle. An early rough reading of
the real lidar suggested **35 / 70 / 70 mm**, against the CAD's
**36.00 / 73.51 / 73.51**.

That gap mattered because `m3_free` is 3.4 mm on an M3 screw — **0.2 mm of slop
per hole**. A 3.5 mm scale error is 17x the available play and the screws would
not have started.

**Caliper, 2026-08-22: 36 and 73.5 mm.** That is the CAD, to within reading
precision. Nothing changed, and the cradle is the model as drawn.

★ Worth keeping for the next part that bolts to this lidar: the rough reading was
wrong by enough to have scrapped a 10-hour print, and the only thing separating
the two answers was measuring properly. Take both spans across each hole pair —
outer wall to outer wall, then inner wall to inner wall — and average them. The
hole diameter cancels, which matters on a *tapped* hole where "the diameter" is
ambiguous between thread crest and root.

---

## Config that has to follow

| Parameter | Set to | Where |
|---|---|---|
| `laser_z` | **0.320** | tf.launch.py |
| `kinect_z` | **0.540** | tf.launch.py |
| `kinect_pitch` | **20°** (0.349 rad) | tf.launch.py |
| Masked rear sector | **±69.2°**, not ±60 | scan_fixer.py · DEFAULT_SECTORS |
| Scan max range | 8.0 | lidar.launch.py |

The mask must be published as `inf`, not as clamped max range — Nav2's obstacle
layer ignores infinite returns entirely, but will happily ray-trace-clear floor
it never saw if you clamp them.

`kinect_pitch` still has to come from a plane fit on `/kinect/points` once the
bracket exists. 20° is design intent, not a measurement.

---

## The five numbers to confirm before cutting metal

Every one of these is read off the *Under-Deck Sensor Plan* figures, not measured
on the vehicle. All five are at the top of the `.scad`, and the asserts will fail
loudly if a real value breaks the design.

- [ ] `DECK_Z = 620` — deck underside above ground
- [ ] `CHASSIS_W = 1053` — body width **at the scan height**. This one directly
      sets coverage, and the plan already flags that the SolidWorks export's
      wheel positions disagree by 18 cm in Z. Tape-measure it.
- [ ] `OVERHANG = 200` — how far ahead of the front face the head can actually go
- [ ] `KIN_Z = 540` / `KIN_X = 0` — the Kinect's position once it takes the top slot
- [ ] `KIN_VFOV = 38` — your figure. Kinect 360 depth is normally quoted 43° V.

None of these five change the printed fittings — verified by perturbing each and
re-exporting, with the part volumes unmoved. They set the two tube cut lengths.

One margin is thin enough that a measurement error will eat it: the Kinect
cone has **15.5 mm** and nothing else. If `OVERHANG` grows or `KIN_TILT` rises,
that is the assert that will fire first — drop `BEAM_Z` to buy it back.
