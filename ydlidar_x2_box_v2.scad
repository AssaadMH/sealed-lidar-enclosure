// =====================================================================
//  YDLIDAR X2 - sealed enclosure with 360 deg clear window band   *** V2 ***
//
//  V2 vs V1, and why:
//    - The VENDOR BRACKET IS GONE. It was a 14.67 mm spacer whose only job
//      was holding the lidar above the driver board. The driver board now
//      lives outside the box, so the lidar bolts straight onto short bosses
//      off the box floor by its OWN 3 tapped holes. That is the whole
//      height saving: 79.5 -> 66.9 mm.
//    - The body is no longer grown out to meet the tube cap in Y. V1 padded
//      Y to 78.60 so the collar could never flare outward. Instead the flare
//      is now checked: it is 34 deg from vertical over the collar's height,
//      which prints unsupported. Body Y drops 78.60 -> 68.30.
//    - Chassis screws now come UP from under the chassis into blind heat-set
//      inserts. V1 dropped them in from inside and reached them through the
//      bracket's access bores - with the bracket gone there is no such path,
//      the lidar body is directly overhead. Blind inserts also mean the floor
//      keeps no through-hole, so it stays sealed.
//    - Clearances are assert()ed, not just echoed. V1 echoed them and a
//      stale export still slipped through once.
//
//  NOTE ON THE ENVELOPE: the body is 104.03 x 68.30, but the LID CAP is
//  Ø75.60 and overhangs the body in Y. The widest point of the assembly is
//  therefore 75.60, not 68.30. Ø70 is the smallest clear tube that clears the
//  Ø60.5 head (65 is not made in acrylic, 60 bores too small), so ~75.6 is a
//  hard floor on Y for any full-360 window. Plan the install around 75.60.
//
//  3 printed parts + 1 bought clear tube:
//     tub    - holds the lidar, bolts to the chassis
//     collar - closes the tub, carries the lower tube groove
//     lid    - carries the upper tube groove
//     tube   - Ø70 x 2.0 wall CAST PMMA, clear, cut to TUBE_LEN (see echo)
//
//  The tube is STRUCTURAL. Nothing else may cross the scan plane, or you
//  get permanent blind sectors in the point cloud.
// =====================================================================

part       = "assembly";  // "tub" | "collar" | "lid" | "assembly" | "section"
show_lidar = false;       // true = drop the real STLs in for a fit check
$fn        = 96;

// ---------------------------------------------------------------------
//  MEASURED LIDAR GEOMETRY  --  do not edit unless you re-measure
//  Source: vendor SolidWorks model in ref/, measured by tools/measure_ref.py,
//  tools/find_holes.py and tools/down_planes.py. Box frame: origin at the
//  underside of the lidar's mounting feet, Z up, x = model X, y = model Z.
// ---------------------------------------------------------------------
LID_X      = [ 0.42, 96.65];   // full envelope; X max is the MOTOR/BELT TAIL,
LID_Y      = [ 0.30, 60.80];   // Y is the Ø60.5 head, which overhangs the body
HEAD       = [40.40, 30.55];   // rotating head axis
HEAD_D     = 60.50;
HEAD_Z     = [48.32, 65.32];
OPT_Z      = [59.30, 64.00];   // <-- LASER WINDOW. Must stay clear.
LIDAR_TOP  = 47.87;            // top of everything except the head (motor tail)

// The lidar's OWN mount: 3 tapped holes (Ø2.46 minor => M3) in pads whose
// undersides sit at FOOT_Z. Screws enter from BELOW. Confirm with calipers
// before printing - see README_v2.md.
FOOT_Z     = 14.669;           // exact: rounding this to 14.70 put the feet
                               // 0.03 mm INSIDE the bosses, which the clash
                               // check caught as 3 slivers of 0.42 mm3
LIDAR_FEET = [[5.12, 30.60], [76.39, 12.59], [76.39, 48.59]];
LEG_H      = 15.00;            // foot underside -> lidar body underside

// box -> chassis. Free choice now that the bracket is gone; kept clear of the
// feet and inside the body's shadow so the pads have somewhere to live.
PAT_C = [[17.40,18.25],[63.40,18.25],[17.40,42.85],[63.40,42.85]];

// ---------------------------------------------------------------------
//  TUNABLES
// ---------------------------------------------------------------------
wall      = 2.4;    // 6 perimeters @ 0.4 nozzle
floor_t   = 6.0;
clr       = 1.5;    // clearance around the lidar
corner_r  = 6.0;

boss_h    = 3.0;    // lidar sits this high off the floor. Drives the whole
                    // height of the box - everything above scales with it.
                    // Keep >= 2: it is also the cable run under the lidar.
boss_d    = 9.0;    // the lidar's foot pads measure 6.36 x 5.50, diagonal
                    // 8.41 - Ø8 let the corners overhang, Ø9 seats them fully

tub_top   = 40.0;   // rim height
collar_t  = 3.0;    // flat plate thickness
collar_z1 = 46.4;   // top of collar = bottom of the free window span

// Ø70 IS a standard size - the clear PMMA/PC ladder is 50/60/70/80/90/100.
// (65 and 75 do not exist in acrylic; 63/75 are PVC pipe only.)
// Material: CAST PMMA, clear, no tint and no UV-filter grade. ~92% T at the
// X2's ~800 nm vs ~90% for PC, lower haze, no birefringence. Do NOT accept
// anything sold as IR-blocking or solar-control - those are visibly clear and
// kill NIR, a failure you cannot see by eye.
tube_od   = 70.0;
tube_t    = 2.0;    // 2 mm is the THINNEST really stocked at Ø70 (and best
                    // optically). Continental EU default is 3 mm (Ø70/64) -
                    // if that is what you get, set this to 3.0 and re-export.

// Extruded acrylic tolerance at Ø70 is +0.35/-1.05 on OD and +/-20% on wall.
// A tight slip fit is therefore IMPOSSIBLE - the wall tolerance alone exceeds
// any sane clearance. The groove is deliberately sloppy and a silicone bead
// takes up the slack; that also seals dust and decouples the tube from the
// spinning head's vibration.
tube_fit  = 1.2;    // total diametral slack in the groove (0.6 per side)
groove_d  = 3.0;

lid_z0    = 55.9;   // lid underside
lid_t     = 5.0;
lid_over  = 2.2;    // lid overhang past the tube OD (also the drip edge)
lid_ch    = 1.8;    // top-edge chamfer: height, and diametral pull-in

m3_free   = 3.4;
m3_insert = 4.0;    // heat-set insert pilot Ø
insert_d  = 5.5;    // insert depth
cb_d      = 6.5;    // counterbore for the M3 SHCS heads under the floor
cb_h      = 3.2;    // M3 SHCS head is 3.0 tall -> sits below flush
pad_d     = 9.0;    // internal pad thickening the floor at each insert
pad_h     = 3.5;

post_d    = 8.0;    // corner posts, the collar screws into these

cable_w   = 12;     // cable notch, open to the rim so it needs no support
cable_h   = 12;

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
// Everything the lidar defines moves down by DROP when the bracket is deleted.
DROP  = FOOT_Z - boss_h;
HEADZ = [HEAD_Z[0] - DROP, HEAD_Z[1] - DROP];
OPTZ  = [OPT_Z[0]  - DROP, OPT_Z[1]  - DROP];
TAILZ = LIDAR_TOP - DROP;                 // top of the motor tail
BODYZ = boss_h + LEG_H;                   // underside of the lidar body

G_ID  = tube_od - 2*tube_t - tube_fit;    // groove inner Ø
G_OD  = tube_od + tube_fit;               // groove outer Ø
CAP_D = G_OD + 2*lid_over;

OUT_X = [LID_X[0]-clr-wall, LID_X[1]+clr+wall];
OUT_Y = [LID_Y[0]-clr-wall, LID_Y[1]+clr+wall];
CAV_X = [OUT_X[0]+wall, OUT_X[1]-wall];
CAV_Y = [OUT_Y[0]+wall, OUT_Y[1]-wall];
BOX_X = OUT_X[1]-OUT_X[0];
BOX_Y = OUT_Y[1]-OUT_Y[0];

TUBE_Z0  = collar_z1 - groove_d;
TUBE_Z1  = lid_z0 + groove_d;
TUBE_LEN = TUBE_Z1 - TUBE_Z0;
BORE_D   = HEAD_D + 3.5;                  // clearance bore around the head

// The collar hulls a BOX_X x BOX_Y rounded rect up to a Ø CAP_D disc. In Y
// the cap is wider than the body, so that face leans OUTWARD as it rises -
// an unsupported overhang. V1 dodged this by padding the body out to the cap;
// here it is allowed but measured.
FLARE_DY = max(0, (CAP_D - BOX_Y)/2);
FLARE_H  = (collar_z1 - 1) - tub_top;
FLARE_A  = atan(FLARE_DY / FLARE_H);      // degrees FROM VERTICAL
HEAD_CLR = (G_ID + tube_fit - HEAD_D)/2;  // radial gap head -> tube bore
ENV_Y    = max(BOX_Y, CAP_D);
TOTAL_H  = floor_t + lid_z0 + lid_t;

// corner posts, parked in the cavity corners
PX = [CAV_X[0] + post_d/2 - 1.1, CAV_X[1] - post_d/2 + 1.1];
PY = [CAV_Y[0] + post_d/2 - 1.1, CAV_Y[1] - post_d/2 + 1.1];
POSTS = [[PX[0],PY[0]],[PX[1],PY[0]],[PX[0],PY[1]],[PX[1],PY[1]]];

// guards against a shell mangling -D part="tub" into an unquoted variable,
// which silently exports the assembly instead of the part you asked for
echo(str("PART = ", part));
echo(str("TUBE: OD ", tube_od, " x ", tube_t, " wall, cut to ", TUBE_LEN, " mm"));
echo(str("FREE WINDOW SPAN z = ", collar_z1, " .. ", lid_z0,
         "   (laser needs ", OPTZ[0], " .. ", OPTZ[1], ")"));
echo(str("BODY FOOTPRINT ", BOX_X, " x ", BOX_Y));
echo(str("MAX ENVELOPE   ", BOX_X, " x ", ENV_Y, "  <-- lid cap Ø", CAP_D, " sets Y"));
echo(str("TOTAL HEIGHT ", TOTAL_H));
echo(str("LIDAR DROPPED ", DROP, " mm vs V1 (vendor bracket deleted)"));
echo(str("HEAD RADIAL CLEARANCE in tube: ", HEAD_CLR, " mm"));
echo(str("COLLAR FLARE ", FLARE_A, " deg from vertical over ", FLARE_H, " mm"));
echo(str("GROOVE slack per side ", tube_fit/2, " mm  (needs silicone bead)"));

// Hard stops. V1 only echoed these and a stale export slipped through anyway.
assert(collar_z1 < OPTZ[0],
       "collar top is inside the laser band - lower collar_z1 or raise boss_h");
assert(lid_z0 > OPTZ[1],
       "lid underside is inside the laser band - raise lid_z0");
assert(lid_z0 > HEADZ[1],
       "lid underside is below the top of the rotating head - raise lid_z0");
assert(tub_top > TAILZ,
       "tub rim is below the top of the motor tail - raise tub_top");
assert(tub_top < HEADZ[1],
       "tub rim is above the head - the rim would block the beam");
assert(HEAD_CLR > 1.0,
       "head has under 1 mm to the tube bore - check tube_t");
assert(FLARE_A < 45,
       "collar flare is steeper than 45 deg from vertical - unprintable");
assert(collar_z1 - groove_d > tub_top + collar_t - 0.001,
       "tube groove starts below the collar plate - raise collar_z1");
assert(floor_t + pad_h > insert_d + 2,
       "not enough material at the chassis inserts - raise pad_h");
assert(floor_t - cb_h > 1.5,
       "floor too thin under the lidar screw counterbores - raise floor_t");
assert(BODYZ > boss_h + 6,
       "no room under the lidar body for the cable run");

// ---------------------------------------------------------------------
//  HELPERS
// ---------------------------------------------------------------------
module rrect(xr, yr, r) {
  hull() for (x = [xr[0]+r, xr[1]-r], y = [yr[0]+r, yr[1]-r])
    translate([x, y]) circle(r = r);
}

module ring(id, od, z0, h) {           // subtractable annulus
  translate([HEAD[0], HEAD[1], z0]) difference() {
    cylinder(d = od, h = h);
    translate([0,0,-1]) cylinder(d = id, h = h+2);
  }
}

module cable_slot(z_top, h, depth_from) {
  translate([depth_from, HEAD[1] - cable_w/2, z_top - h])
    cube([wall + 4, cable_w, h + 2]);
}

// ---------------------------------------------------------------------
//  TUB
// ---------------------------------------------------------------------
module tub() {
  difference() {
    union() {
      difference() {
        translate([0,0,-floor_t])
          linear_extrude(floor_t + tub_top) rrect(OUT_X, OUT_Y, corner_r);
        linear_extrude(tub_top + 2) rrect(CAV_X, CAV_Y, corner_r - wall);
      }
      // corner posts - run all the way to the floor, they merge into the
      // corner fillets and need no support
      for (p = POSTS) translate([p[0], p[1], 0]) cylinder(d = post_d, h = tub_top);
      // the three lidar bosses
      for (p = LIDAR_FEET) translate([p[0], p[1], 0]) cylinder(d = boss_d, h = boss_h);
      // internal pads so the blind chassis inserts have depth to bite into
      for (p = PAT_C) translate([p[0], p[1], 0]) cylinder(d = pad_d, h = pad_h);
    }
    // lidar screws: M3 up from below into the lidar's own tapped holes,
    // heads recessed so the box still sits flat on the chassis
    for (p = LIDAR_FEET) translate([p[0], p[1], 0]) {
      translate([0,0,-floor_t-1]) cylinder(d = m3_free, h = floor_t + boss_h + 2);
      translate([0,0,-floor_t-0.01]) cylinder(d = cb_d, h = cb_h + 0.01);
    }
    // chassis: blind heat-set inserts opening downward. No through-hole, so
    // the floor stays sealed; the chassis screws come up from underneath.
    for (p = PAT_C) translate([p[0], p[1], -floor_t-0.01])
      cylinder(d = m3_insert, h = insert_d + 0.01);
    // collar screws
    for (p = POSTS) translate([p[0], p[1], tub_top - insert_d])
      cylinder(d = m3_insert, h = insert_d + 1);
    // cable exit, open to the rim so it prints without support
    cable_slot(tub_top, cable_h, CAV_X[1] - 1);
  }
}

// ---------------------------------------------------------------------
//  COLLAR  -- tapers from the rectangular rim up to the tube groove so no
//  flat surface sits just under the beam throwing reflections back
// ---------------------------------------------------------------------
module collar() {
  difference() {
    hull() {
      translate([0,0,tub_top])
        linear_extrude(collar_t) rrect(OUT_X, OUT_Y, corner_r);
      translate([HEAD[0], HEAD[1], collar_z1 - 1])
        cylinder(d = CAP_D, h = 1);
    }
    translate([HEAD[0], HEAD[1], tub_top - 1])           // head clearance bore
      cylinder(d = BORE_D, h = 60);
    ring(G_ID, G_OD, TUBE_Z0, groove_d + 1);             // tube groove
    translate([HEAD[0], HEAD[1], collar_z1 - 2.5])       // anti-reflection cone
      cylinder(d1 = BORE_D, d2 = G_ID, h = 2.5 + 0.01);
    for (p = POSTS) translate([p[0], p[1], tub_top - 1]) // screws down to tub
      cylinder(d = m3_free, h = collar_t + 3);
    translate([CAV_X[1] - 1, HEAD[1] - cable_w/2, tub_top - 1])
      cube([wall + 4, cable_w, 1.2]);                    // cable notch relief
  }
}

// ---------------------------------------------------------------------
//  LID   -- print upside down, flat top on the bed
// ---------------------------------------------------------------------
module lid() {
  difference() {
    // The top-edge chamfer is BUILT, not subtracted. In V1 it was a
    // subtracted cone sized d1 = CAP_D + 2.0 "to avoid coincident faces" -
    // but a subtracted solid WIDER than the part removes the whole
    // cross-section, and it sliced the lid into two pieces with a 1 mm gap.
    // Stacking cylinders cannot sever anything. Keep it this way.
    translate([HEAD[0], HEAD[1], lid_z0]) union() {
      cylinder(d = CAP_D, h = lid_t - lid_ch);
      translate([0, 0, lid_t - lid_ch])
        cylinder(d1 = CAP_D, d2 = CAP_D - lid_ch, h = lid_ch);
    }
    ring(G_ID, G_OD, lid_z0 - 1, groove_d + 1);
  }
}

// ---------------------------------------------------------------------
//  VIEW
// ---------------------------------------------------------------------
module tube_ghost() {
  color("LightCyan", 0.25) ring(tube_od - 2*tube_t, tube_od, TUBE_Z0, TUBE_LEN);
}

// each import gets its OWN transform chain: a transform wrapping several
// children is an implicit union(), which the old CGAL kernel cannot do on
// imported meshes at all
// The driver board is deliberately NOT drawn: it lives outside the box in V2,
// and that is the whole reason the vendor bracket could be deleted.
module lidar_ghost() {
  D = "ref/";
  for (n = [1:5])
    color("DimGray") translate([0,0,-DROP]) translate([0,61.10,0]) rotate([90,0,0])
      import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_", n, "-1.STL"));
}

// ---------------------------------------------------------------------
//  CLASH CHECKS  -- these are the real verification, not the renders.
//  Each intersects the printed solids with something that must never be
//  touched. A correct design exports an EMPTY stl (0 facets / 0 volume);
//  anything else is a collision, and its bounding box says where.
//    part="clash_lidar" : box vs the physical lidar
//    part="clash_beam"  : box vs the full 360 deg scan band
// ---------------------------------------------------------------------
module box_solids() { tub(); collar(); lid(); }

module beam_disc() {
  translate([HEAD[0], HEAD[1], OPTZ[0]])
    cylinder(d = 260, h = OPTZ[1] - OPTZ[0]);
}

// each part is exported already resting on z = 0, oriented for printing
if (part == "clash_lidar") intersection() { union() box_solids(); lidar_ghost(); }
else if (part == "clash_beam") intersection() { union() box_solids(); beam_disc(); }
else if (part == "tub")    translate([0,0,floor_t]) tub();
else if (part == "collar") translate([0,0,-tub_top]) collar();
else if (part == "lid")    translate([HEAD[0], HEAD[1], 0])
                             rotate([180,0,0])
                               translate([-HEAD[0], -HEAD[1], -lid_z0 - lid_t]) lid();
else {
  difference() {
    union() {
      color("Gainsboro") tub();
      color("Silver")    collar();
      color("Gainsboro") lid();
      tube_ghost();
      if (show_lidar) lidar_ghost();
    }
    if (part == "section")
      translate([OUT_X[0]-5, OUT_Y[0]-5, -floor_t-5])
        cube([BOX_X+10, HEAD[1]-OUT_Y[0]+5, 120]);
  }
  // laser band, drawn as a red disc - nothing solid may touch this
  if (part == "section")
    color("Red", 0.35) translate([HEAD[0], HEAD[1], OPTZ[0]])
      cylinder(d = 130, h = OPTZ[1] - OPTZ[0]);
}
