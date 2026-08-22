// =====================================================================
//  YDLIDAR X2 V2 box - CEILING HANGER                          rev A
//
//  Hangs the V2 enclosure INVERTED (lid down) from a flat ceiling.
//
//  WHY INVERTED. Nothing may cross the scan plane - the O70 tube is
//  structural precisely so no bracket has to be, and any arm reaching
//  down past the window puts a permanent blind sector in the cloud.
//  Hung inverted, every part of this mount lives BELOW z = 0 in box
//  coordinates (i.e. behind the floor), so it is nowhere near the beam.
//  It also puts the load into the 6 mm tub floor instead of through the
//  acrylic tube joint, and turns the counterbored through-holes - the
//  only leak path in the box - to face upward under the roof.
//
//  TWO PRINTED PARTS + hardware:
//    yoke   - bolts to the tub 4 PAT_C inserts, stands the box off 18 mm,
//             carries the two tapered keyhole slots
//    plate  - screws to the ceiling, carries two mushroom studs
//  Hang = drop the yoke keyholes over the studs, slide 12 mm (the slot
//  taper wedges it home), then drive ONE M4x12 safety screw up through
//  the middle of the yoke into the plate. The safety screw is what stops
//  it ever sliding back off - the wedge alone is friction, not a lock.
//
//  SERVICE ACCESS. The yoke plate and the ceiling plate are both sized
//  to fall strictly INSIDE the X band between the lidar feet, so all
//  three foot counterbores keep an open column to the ceiling. See the
//  FOOT CLEARANCE asserts - they fail the build if that stops being
//  true. Full access = pull the safety screw and slide the box off.
//
//  Box frame throughout: z = 0 is the OUTER face of the tub floor, the
//  box occupies z > 0, this mount occupies z < 0. Same frame as
//  stl_v2/ydlidar_x2_v2_tub.stl, so the clash check needs no transform.
// =====================================================================

CM_PART = "assembly";  // "yoke"|"plate"|"assembly"|"section"|"clash_seat"
$fn     = 96;

// ---------------------------------------------------------------------
//  COPIED from ydlidar_x2_box_v2.scad (file dated 2026-08-03).
//  Deliberately copied, not include()d: including it would disturb that
//  file mtime rule, and it renders the assembly on an unknown part=.
//  Cross-checked against the real exported tub by the clash_seat check.
// ---------------------------------------------------------------------
PAT_C      = [[17.40,18.25],[63.40,18.25],[17.40,42.85],[63.40,42.85]];
LIDAR_FEET = [[5.12,30.60],[76.39,12.59],[76.39,48.59]];
HEAD       = [40.40, 30.55];
BOX_XR     = [ -3.48, 100.55];
BOX_YR     = [ -3.60,  64.70];
ENV_D      = 75.60;   // lid cap - the widest thing on the assembly
cb_d       = 6.5;     // foot counterbore in the floor underside
m3_free    = 3.4;
m3_insert  = 4.0;
insert_d   = 5.5;

// ---------------------------------------------------------------------
//  TUNABLES
// ---------------------------------------------------------------------
PILLAR_H  = 18.0;   // box floor -> yoke plate. Also the stud-head room,
                    // and the working room for the safety screw.
PILLAR_D  = 10.0;
YOKE_T    = 5.0;
YOKE_MX   = 4.0;    // yoke plate margin past PAT_C in X - LIMITED by the feet
YOKE_Y    = [2.55, 58.55];   // free in Y: no foot lies in the yoke X band

PLATE_X   = [12.40, 68.40];  // ceiling plate, also kept clear of the feet
PLATE_Y   = [ 4.55, 56.55];
PLATE_T   = 9.0;
JOINT_CL  = 0.30;   // yoke plate face -> ceiling plate face

STUD_DY   = 18.0;   // studs at HEAD +/- this in Y
NECK_D    = 5.0;
CAPD      = 10.0;
CONE_H    = 2.5;    // 45 deg flare: prints unsupported, and wedges
CAP_H     = 2.0;
SLOT_CL   = 0.6;    // diametral slack, neck in slot at the entry end
TRAVEL    = 12.0;   // keyhole slide

m3_cb     = 6.5;
m3_cbh    = 3.4;
M5_free   = 5.5;
M5_cb     = 10.0;
M5_cbh    = 4.0;
ANCH_DX   = 20.0;   // ceiling anchors at HEAD +/- these
ANCH_DY   = 18.0;

m4_free   = 4.5;    // central safety screw, M4x12, driven UP from the gap
m4_insert = 5.6;
m4_ins_d  = 6.0;
SLOT_NIP  = 0.3;    // slot narrows to NECK_D+this at the locked end. This
                    // CENTRES the stud and takes up slack - it is not the
                    // lock. 0.1 was tried and is below FDM tolerance: a O5.0
                    // neck prints ~5.15 and a O5.1 slot ~4.95, so it jams
                    // instead of sliding. The M4 safety screw is the clamp.
FOOT_KEEP = 5.75;   // keep-out radius round each foot: cb 6.5 + 2.5 clear

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
function cmin(v,i) = min([for (p=v) p[i]]);
function cmax(v,i) = max([for (p=v) p[i]]);

YOKE_X   = [cmin(PAT_C,0)-YOKE_MX, cmax(PAT_C,0)+YOKE_MX];
// The PILLARS stand proud of the plate edge, so the silhouette that actually
// shadows the feet is wider than the plate. Test the silhouette, not the plate.
YOKE_XF  = [min(YOKE_X[0], cmin(PAT_C,0)-PILLAR_D/2),
            max(YOKE_X[1], cmax(PAT_C,0)+PILLAR_D/2)];

Z_PLATE_B = -PILLAR_H;                 // yoke plate, box side
Z_YOKE_F  = -PILLAR_H - YOKE_T;        // yoke plate, ceiling side
Z_SPINE_B = Z_YOKE_F - JOINT_CL;       // ceiling plate, box side
Z_CEIL    = Z_SPINE_B - PLATE_T;       // ceiling face
SERVICE   = -Z_CEIL;                   // box floor -> ceiling

NECK_H    = YOKE_T + JOINT_CL + 0.2;   // neck spans the yoke plate
Z_NECK_E  = Z_SPINE_B + NECK_H;        // where the flare starts
GRIP      = (CAPD - (NECK_D+SLOT_CL))/2;

STUDS   = [for (s=[-1,1]) [HEAD[0], HEAD[1] + s*STUD_DY]];
ANCH    = [for (sx=[-1,1], sy=[-1,1]) [HEAD[0]+sx*ANCH_DX, HEAD[1]+sy*ANCH_DY]];
ENTRY_X = HEAD[0] + TRAVEL;            // keyhole entry, slide -X to lock

echo(str("CM_PART = ", CM_PART));
echo(str("SERVICE GAP box floor -> ceiling = ", SERVICE, " mm"));
echo(str("YOKE plate  X ", YOKE_X, "  Y ", YOKE_Y,
         "   silhouette X ", YOKE_XF));
echo(str("foot open column X-gaps: ",
         [for (f=LIDAR_FEET) min(abs(f[0]+FOOT_KEEP-YOKE_XF[0]),
                                 abs(f[0]-FOOT_KEEP-YOKE_XF[1]))]));
echo(str("PLATE       X ", PLATE_X, "  Y ", PLATE_Y));
echo(str("keyhole grip per side = ", GRIP, " mm,  travel ", TRAVEL));
echo(str("stud spread ", 2*STUD_DY, " mm,  anchor spread ",
         2*ANCH_DX, " x ", 2*ANCH_DY));
echo(str("M3 to PAT_C: head seat z ", Z_YOKE_F + m3_cbh,
         " -> insert bottom z ", insert_d, "  => use M3x20 SHCS"));
echo(str("safety screw: head at z ", Z_PLATE_B, " -> insert bottom z ",
         Z_SPINE_B - m4_ins_d, "  => use M4x12"));
echo(str("slot taper ", NECK_D+SLOT_CL, " -> ", NECK_D+SLOT_NIP, " mm"));

// --- FOOT CLEARANCE: the whole point of the design -------------------
for (f = LIDAR_FEET) {
  assert(f[0] + FOOT_KEEP < YOKE_XF[0] || f[0] - FOOT_KEEP > YOKE_XF[1],
         "a lidar foot counterbore is under the YOKE - service access lost");
  assert(f[0] + FOOT_KEEP < PLATE_X[0] || f[0] - FOOT_KEEP > PLATE_X[1],
         "a lidar foot counterbore is under the CEILING plate - access lost");
}
// pillars must not clip a counterbore either
for (f = LIDAR_FEET) for (p = PAT_C)
  assert(norm([f[0]-p[0], f[1]-p[1]]) > (PILLAR_D + cb_d)/2 + 1.0,
         "a yoke pillar overlaps a lidar foot counterbore");
// keyhole entries must clear the PAT_C screw heads
for (p = PAT_C) for (s = STUDS)
  assert(norm([p[0]-ENTRY_X, p[1]-s[1]]) > (CAPD+SLOT_CL)/2 + m3_cb/2 + 1,
         "keyhole entry fouls a PAT_C screw head");

// nothing may reach into the box, nothing may exceed the lid envelope
assert(Z_PLATE_B < 0, "the yoke plate is inside the box");
assert(GRIP > 1.8, "keyhole grip under 1.8 mm - widen CAPD");
assert(PLATE_T - M5_cbh > 4.0, "ceiling plate too thin under the M5 counterbores");
assert(NECK_H > YOKE_T + JOINT_CL, "stud neck is shorter than the yoke plate");
assert(Z_NECK_E + CONE_H + CAP_H < 0, "the stud head hits the box floor");
assert(SERVICE > 25, "service gap under 25 mm - a hex key will not reach the feet");
assert(PLATE_T - m4_ins_d > 2.5,
       "not enough material behind the safety-screw insert");
assert(norm([HEAD[0]-ANCH[0][0], HEAD[1]-ANCH[0][1]]) > (m4_insert+M5_cb)/2 + 1,
       "safety insert fouls a ceiling anchor counterbore");
for (s2 = STUDS)
  assert(norm([HEAD[0]-s2[0], HEAD[1]-s2[1]]) > (m4_insert+CAPD)/2 + 1,
         "safety insert fouls a stud");
assert(YOKE_Y[1] < HEAD[1] + ENV_D/2, "yoke plate exceeds the lid cap envelope");
assert(ANCH_DX + M5_cb/2 < (PLATE_X[1]-PLATE_X[0])/2,
       "ceiling anchor counterbore runs off the plate in X");
assert(ANCH_DY + M5_cb/2 < (PLATE_Y[1]-PLATE_Y[0])/2,
       "ceiling anchor counterbore runs off the plate in Y");

// ---------------------------------------------------------------------
//  HELPERS
// ---------------------------------------------------------------------
module rrect(xr, yr, r) {
  hull() for (x = [xr[0]+r, xr[1]-r], y = [yr[0]+r, yr[1]-r])
    translate([x, y]) circle(r = r);
}
// Tapered slot: wide where the stud enters, nipped at the locked end so the
// cone under the stud head wedges the two plates together as it slides home.
module keyhole(d_entry, d_wide, d_nip, ex, y, travel) {
  hull() { translate([ex, y]) circle(d = d_wide);
           translate([ex - travel, y]) circle(d = d_nip); }
  translate([ex, y]) circle(d = d_entry);
}

// ---------------------------------------------------------------------
//  YOKE - print the ceiling face DOWN (pillars up, no support)
// ---------------------------------------------------------------------
module yoke() {
  difference() {
    union() {
      translate([0,0,Z_YOKE_F]) linear_extrude(YOKE_T) rrect(YOKE_X, YOKE_Y, 4);
      for (p = PAT_C) translate([p[0],p[1],Z_PLATE_B]) cylinder(d=PILLAR_D, h=PILLAR_H);
    }
    for (p = PAT_C) translate([p[0], p[1], 0]) {
      translate([0,0,Z_YOKE_F-1])    cylinder(d=m3_free, h=PILLAR_H+YOKE_T+2);
      translate([0,0,Z_YOKE_F-0.01]) cylinder(d=m3_cb,   h=m3_cbh+0.01);
    }
    translate([0,0,Z_YOKE_F-1]) linear_extrude(YOKE_T+2)
      for (s = STUDS) keyhole(CAPD+SLOT_CL+0.6, NECK_D+SLOT_CL,
                              NECK_D+SLOT_NIP, ENTRY_X, s[1], TRAVEL);
    // central safety screw - clearance only; it threads into the ceiling plate
    translate([HEAD[0], HEAD[1], Z_YOKE_F-1]) cylinder(d = m4_free, h = YOKE_T+2);
  }
}

// ---------------------------------------------------------------------
//  CEILING PLATE - print the CEILING FACE DOWN (studs up, no support)
// ---------------------------------------------------------------------
module plate() {
  difference() {
    union() {
      translate([0,0,Z_CEIL]) linear_extrude(PLATE_T) rrect(PLATE_X, PLATE_Y, 5);
      for (s = STUDS) translate([s[0], s[1], Z_SPINE_B]) {
        cylinder(d = NECK_D, h = NECK_H);
        translate([0,0,NECK_H]) cylinder(d1 = NECK_D, d2 = CAPD, h = CONE_H);
        translate([0,0,NECK_H+CONE_H]) cylinder(d = CAPD, h = CAP_H);
      }
    }
    // blind M4 heat-set insert for the safety screw - opens toward the box,
    // so the plate keeps no through-hole here
    translate([HEAD[0], HEAD[1], Z_SPINE_B - m4_ins_d])
      cylinder(d = m4_insert, h = m4_ins_d + 0.01);
    for (a = ANCH) translate([a[0], a[1], 0]) {
      translate([0,0,Z_CEIL-1])         cylinder(d = M5_free, h = PLATE_T+2);
      translate([0,0,Z_SPINE_B-M5_cbh]) cylinder(d = M5_cb, h = M5_cbh+0.01);
      // 45 deg lead-in so the counterbore roof bridges cleanly when printed
      translate([0,0,Z_SPINE_B-M5_cbh-(M5_cb-M5_free)/2])
        cylinder(d1 = M5_free, d2 = M5_cb, h = (M5_cb-M5_free)/2 + 0.01);
    }
  }
}

// ---------------------------------------------------------------------
//  DISPATCH  -- an unknown part renders NOTHING, deliberately: the v2
//  file falls through to the assembly and that has bitten this project.
// ---------------------------------------------------------------------
if (CM_PART == "yoke")          translate([0,0,-Z_YOKE_F]) yoke();
else if (CM_PART == "plate")    translate([0,0,-Z_CEIL]) plate();
else if (CM_PART == "assembly") { yoke(); plate(); }
else if (CM_PART == "section")
  difference() { union() { yoke(); plate(); }
                 translate([-200, HEAD[1], -200]) cube([400,400,400]); }
else if (CM_PART == "clash_seat")
  intersection() {
    import("stl_v2/ydlidar_x2_v2_tub.stl", convexity = 10);
    for (p = PAT_C) translate([p[0],p[1],0]) difference() {
      cylinder(d = PILLAR_D, h = 0.6);
      translate([0,0,-1]) cylinder(d = m3_free, h = 3);
    }
  }
else echo("*** UNKNOWN CM_PART - nothing rendered ***");
