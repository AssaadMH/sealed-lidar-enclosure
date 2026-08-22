# YDLIDAR X2 V2 box — ceiling hanger (rev A)

Hangs the V2 enclosure **inverted (lid down)** from a flat ceiling, keeping the
lidar's three foot screws serviceable.

Source: `ceiling_mount.scad` · STLs: `stl_mount/` · preview: `img/ceiling_mount_iso.png`

**Nothing here is printed or fitted yet.**

---

## Why inverted

The Ø70 tube is structural precisely so that no bracket has to be, and
**nothing may cross the scan plane** — any arm reaching down past the window
band puts a permanent blind sector in the point cloud. So the mount can only
attach at the floor end, which means the box hangs upside down.

That turns out to be the better option anyway:

- the load goes into the 6 mm tub floor, not through the acrylic tube joint
- every part of the mount sits at `z < 0` in box coordinates — behind the
  floor, nowhere near the beam
- the three counterbored through-holes — the box's only leak path — end up
  facing *up*, under the roof

## Why the feet stay accessible

The lidar's feet are at **X = 5.12 and 76.39**; the four chassis inserts
(`PAT_C`) are at **X = 17.40 and 63.40**. The feet are outboard of the insert
rectangle in X, and **no foot falls inside that X band**. So a mount that grabs
only `PAT_C` can be made to shadow none of the three counterbores.

`PAT_C` is also centred exactly on the head axis (40.40, 30.55), so the hanging
load sits directly under the spin axis with no tilt moment.

Measured clear gap between each counterbore keep-out and the yoke silhouette:
**1.53 / 2.24 / 2.24 mm**, on top of the 2.5 mm already inside the keep-out
radius — so ≥ 4.0 mm of open ground around every screw.

Service gap, box floor to ceiling: **32.3 mm.** Reach the feet with a ball-end
2.5 mm key at an angle, or pull one screw and slide the whole box off.

---

## Parts

| Part | STL | Volume | Print |
|---|---|---|---|
| `yoke` | `stl_mount/lidar_ceiling_yoke.stl` | 18.0 cm³ | plate face down, pillars up |
| `plate` | `stl_mount/lidar_ceiling_plate.stl` | 24.7 cm³ | ceiling face down, studs up |

Both export **already sitting flat at z = 0, single solid body, zero support.**
Do not re-orient them in the slicer.

They are structural and overhead — print at **≥ 5 perimeters and ≥ 40 % infill**,
not the box's 5 % infill profile.

## Hardware

| Qty | Item | Where |
|---|---|---|
| 4 | M3 heat-set insert (Ø4.0 × 5.5) | into the tub floor `PAT_C` bores, from outside |
| 4 | M3 × 20 SHCS | yoke → tub |
| 1 | M4 heat-set insert (Ø5.6 × 6.0) | into the ceiling plate, box-side face, centre |
| 1 | M4 × 12 SHCS | safety screw, yoke → plate |
| 4 | M5 screws + ceiling anchors | plate → ceiling (length per ceiling) |

The two mushroom studs are **printed into the plate** — no hardware.

## Assembly order

The order matters: step 3 must happen before the box goes up.

1. Heat-set the 4 × M3 inserts into the tub floor.
2. Heat-set the 1 × M4 insert into the ceiling plate.
3. Mark and drill the ceiling through the plate, fit anchors, and screw the
   plate up with the 4 × M5. Heads sit in the counterbores on the box side.
4. On the bench, with the box inverted, bolt the yoke to the tub floor with the
   4 × M3 × 20. Heads recess into the yoke's counterbores.
5. Lift the box+yoke, drop the two keyholes over the studs (entry holes are
   +12 mm in X of the locked position), and slide **−X by 12 mm**.
6. Drive the M4 × 12 up through the centre of the yoke into the plate.

**Removal:** back out the M4, slide +X 12 mm, lift off.

### The safety screw is the lock

The slot tapers 5.6 → 5.3 mm to centre the stud and take up slack. That is
**not** a lock — it is friction. The M4 screw is what clamps the plates
together and what stops the joint ever sliding back off. Do not skip it on an
overhead mount.

Keyhole grip is 2.2 mm per side (Ø10 cap over a 5.6 mm slot).

---

## Verification

Numbers, not renders — this project has been burned by renders before.

- **`clash_seat`** — the 4 pillar footprints intersected with the *real*
  exported tub: 4 bodies, **39.56 mm³ each** against 39.58 predicted for a
  Ø10/Ø4 annulus 0.6 deep. Every pillar seats on solid floor, losing exactly
  the insert bore and nothing else — no counterbore is clipped. This is what
  validates the constants copied out of `ydlidar_x2_box_v2.scad`.
- **`stlcheck`** — both parts: **1 component, SOLID**, positive volume, z ≥ 0.
- **joint clash** — yoke ∩ plate at the locked position: **0.00 mm³.**
  Control: the same intersection with the yoke slid only 6 mm gives
  **88.39 mm³ per stud**, so the check moves when the input is wrong.
- 21 `assert()`s, including the three foot-clearance ones that fail the build
  if any counterbore ever ends up shadowed.

A first attempt put an anti-slide upstand on the yoke's +Y edge. `stlcheck`
reported **2 components** — it met the plate on a coincident face and exported
as a loose second body — and it protruded past the very face that needs to be
on the bed. It was replaced by the central safety screw.

`SLOT_NIP` was 0.1 mm before; that is below FDM tolerance (a Ø5.0 neck prints
~5.15, a Ø5.1 slot ~4.95) and would jam rather than slide. Now 0.3.

---

## Before you print

- [ ] **Caliper the lidar's 3 mounting holes** — still outstanding from the box
      itself, and the tub is what carries them.
- [ ] Decide the ceiling anchors. Hanging mass is only ~350 g, so almost
      anything holds, but it is overhead — use real anchors, not plugs in
      plasterboard.
- [ ] **Seal the 3 counterbores.** Inverted, the box's only leak path now faces
      up and can collect condensation. A dab of silicone over each head.
- [ ] **The cable now exits at the bottom.** The tub's cable notch is at the
      rim, which is the low end when inverted — the cable has to run down and
      then back up to the ceiling. Nothing in this design addresses that; if it
      bothers you, the notch is a one-line change in the V2 tub, but that
      re-slices the 10 h tub print.
- [ ] **The scan will be mirrored.** Set the driver's inverted flag, or handle
      it in the TF — the box is upside down.
