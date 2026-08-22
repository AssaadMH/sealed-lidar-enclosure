// =====================================================================
//  YDLIDAR X2 - sealed enclosure with 360 deg clear window band
//  Built for the "ydlidar-x2-with-driver-circuit" SolidWorks/STEP model.
//
//  All geometry below is MEASURED from that model, not guessed.
//  Origin      : bottom face of Lidar_holder bracket
//  Axes        : Z up.  x = model X,  y = model Z  (the model is Y-up)
//
//  3 printed parts + 1 bought clear tube:
//     tub    - holds lidar + driver board, bolts to chassis
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
// ---------------------------------------------------------------------
// Footprint = union of EVERYTHING below the rim. Note Y is driven by the
// Ø60.5 head (0.31..60.80), not the bracket (4.05..57.05) - the head
// overhangs the bracket in Y and would hit the wall if you used the latter.
LID_X      = [ 0.42, 96.65];
LID_Y      = [ 0.30, 60.80];
HEAD       = [40.40, 30.55];   // rotating head axis
HEAD_D     = 60.50;
HEAD_Z     = [48.32, 65.32];
OPT_Z      = [59.30, 64.00];   // <-- LASER WINDOW. Must stay clear.
BRACKET_TOP= 14.67;

// bracket -> box floor, M3 from above (bracket has Ø5.8 counterbores here)
PAT_A = [[10.40,12.55],[70.40,12.55],[10.40,48.55],[70.40,48.55]];
// box -> chassis, M3 down (bracket's Ø6.35 bores give hex-key access)
PAT_B = [[17.40,18.25],[63.40,18.25],[17.40,42.85],[63.40,42.85]];

// ---------------------------------------------------------------------
//  TUNABLES
// ---------------------------------------------------------------------
wall      = 2.4;    // 6 perimeters @ 0.4 nozzle
floor_t   = 7.0;    // thick enough for M3 heat-set inserts
clr       = 1.5;    // clearance around the lidar
corner_r  = 6.0;
tub_top   = 52.0;   // rim height (head bottom is 48.32, so the head pokes out)

collar_t  = 3.0;    // flat plate thickness
collar_z1 = 58.0;   // top of collar = bottom of the free window span

// Ø70 IS a standard size - the clear PMMA/PC ladder is 50/60/70/80/90/100.
// (65 and 75 do not exist in acrylic; 63/75 are PVC pipe only.)
// Material: CAST PMMA, clear, no tint and no UV-filter grade. ~92% T at the
// X2's ~800 nm vs ~90% for PC, lower haze, no birefringence. Do NOT accept
// anything sold as IR-blocking or solar-control - those are visibly clear and
// kill NIR, a failure you cannot see by eye.
tube_od   = 70.0;
tube_t    = 2.0;    // 2 mm is the THINNEST really stocked at Ø70 (and best optically).
                    // Continental EU default is 3 mm (Ø70/64) - if that is what
                    // you get, set this to 3.0 and re-export.

// Extruded acrylic tolerance at Ø70 is +0.35/-1.05 on OD and +/-20% on wall
// (+/-0.6 at 3 mm). A tight slip fit is therefore IMPOSSIBLE - the wall
// tolerance alone exceeds any sane clearance. The groove is deliberately
// sloppy and a silicone bead takes up the slack; that also seals dust and
// decouples the tube from the spinning head's vibration.
tube_fit  = 1.2;    // total diametral slack in the groove (0.6 per side)
groove_d  = 3.0;

lid_z0    = 67.5;   // lid underside (head top is 65.32 -> 2.18 clearance)
lid_t     = 5.0;
lid_over  = 2.2;    // lid overhang past the tube OD
lid_ch    = 1.8;    // top-edge chamfer: height, and diametral pull-in at the top

m3_free   = 3.4;
m3_insert = 4.0;    // heat-set insert pilot Ø
insert_d  = 5.5;    // insert depth

post_d    = 8.0;    // corner posts, collar screws into these
post_z0   = 15.5;   // starts above the bracket (top 14.67)

cable_w   = 12;     // cable notch, open to the rim so it needs no support
cable_h   = 12;

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
G_ID  = tube_od - 2*tube_t - tube_fit;   // groove inner Ø
G_OD  = tube_od + tube_fit;              // groove outer Ø
CAP_D = G_OD + 2*lid_over;

// The shell must be at least as big as the tube cap, otherwise the collar's
// rect -> circle loft flares OUTWARD on the way up = unprintable overhang.
// Grow the short axis symmetrically about the head until it encloses the cap.
MIN_W = CAP_D + 3;
RX = [LID_X[0]-clr-wall, LID_X[1]+clr+wall];
RY = [LID_Y[0]-clr-wall, LID_Y[1]+clr+wall];
GX = max(0, (MIN_W - (RX[1]-RX[0]))/2);
GY = max(0, (MIN_W - (RY[1]-RY[0]))/2);
OUT_X = [RX[0]-GX, RX[1]+GX];
OUT_Y = [RY[0]-GY, RY[1]+GY];
CAV_X = [OUT_X[0]+wall, OUT_X[1]-wall];
CAV_Y = [OUT_Y[0]+wall, OUT_Y[1]-wall];
TUBE_Z0  = collar_z1 - groove_d;
TUBE_Z1  = lid_z0 + groove_d;
TUBE_LEN = TUBE_Z1 - TUBE_Z0;
BORE_D   = HEAD_D + 3.5;                 // clearance bore around the head

// corner posts, parked in the cavity corners wherever those end up
PX = [CAV_X[0] + post_d/2 - 1.1, CAV_X[1] - post_d/2 + 1.1];
PY = [CAV_Y[0] + post_d/2 - 1.1, CAV_Y[1] - post_d/2 + 1.1];
POSTS = [[PX[0],PY[0]],[PX[1],PY[0]],[PX[0],PY[1]],[PX[1],PY[1]]];

// guards against a shell mangling -D part="tub" into an unquoted variable,
// which silently exports the assembly instead of the part you asked for
echo(str("PART = ", part));
echo(str("TUBE: OD ", tube_od, " x ", tube_t, " wall, cut to ", TUBE_LEN, " mm"));
echo(str("FREE WINDOW SPAN z = ", collar_z1, " .. ", lid_z0,
         "   (laser needs ", OPT_Z[0], " .. ", OPT_Z[1], ")"));
echo(str("OUTER FOOTPRINT ", OUT_X[1]-OUT_X[0], " x ", OUT_Y[1]-OUT_Y[0]));
echo(str("TOTAL HEIGHT ", floor_t + lid_z0 + lid_t));
echo(str("HEAD RADIAL CLEARANCE in tube: ", (G_ID + tube_fit - HEAD_D)/2, " mm"));
echo(str("GROOVE slack per side ", tube_fit/2, " mm  (needs silicone bead)"));

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

// ---------------------------------------------------------------------
//  TUB
// ---------------------------------------------------------------------
module tub() {
  difference() {
    union() {
      difference() {
        translate([0,0,-floor_t])
          linear_extrude(floor_t + tub_top) rrect(OUT_X, OUT_Y, corner_r);
        translate([0,0,0])
          linear_extrude(tub_top + 2) rrect(CAV_X, CAV_Y, corner_r - wall);
      }
      for (p = POSTS) translate([p[0], p[1], 0]) {
        translate([0,0,post_z0]) cylinder(d = post_d, h = tub_top - post_z0);
        translate([0,0,post_z0 - post_d/2])          // 45 deg, no support
          cylinder(d1 = 0.6, d2 = post_d, h = post_d/2);
      }
    }
    // chassis screws: dropped in from inside, reachable through the
    // bracket's own Ø6.35 bores with a long hex key
    for (p = PAT_B) translate([p[0], p[1], -floor_t-1])
      cylinder(d = m3_free, h = floor_t + 2);
    // heat-set inserts, bracket bolts down into these
    for (p = PAT_A) translate([p[0], p[1], -insert_d])
      cylinder(d = m3_insert, h = insert_d + 0.01);
    // collar screws
    for (p = POSTS) translate([p[0], p[1], tub_top - insert_d])
      cylinder(d = m3_insert, h = insert_d + 1);
    // cable exit, open to the rim
    translate([CAV_X[1] - 1, HEAD[1] - cable_w/2, tub_top - cable_h])
      cube([wall + 3, cable_w, cable_h + 2]);
  }
}

// ---------------------------------------------------------------------
//  COLLAR  -- tapers from the rectangular rim up to the tube groove so
//  no flat surface sits just under the beam throwing reflections back
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
    for (p = POSTS) translate([p[0], p[1], tub_top - 1]) // screws to tub
      cylinder(d = m3_free, h = collar_t + 3);
    translate([CAV_X[1] - 1, HEAD[1] - cable_w/2, tub_top - 1])
      cube([wall + 3, cable_w, 1.2]);                    // cable notch relief
  }
}

// ---------------------------------------------------------------------
//  LID   -- print upside down, flat top on the bed
// ---------------------------------------------------------------------
module lid() {
  difference() {
    // The top-edge chamfer is BUILT, not subtracted. It used to be a
    // subtracted cone sized d1 = CAP_D + 2.0 "to avoid coincident faces" -
    // but a subtracted solid that is wider than the part removes the whole
    // cross-section, and it sliced the lid into two pieces with a 1 mm gap
    // (a detached ring). Stacking cylinders cannot sever anything.
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

module lidar_ghost() {
  D = "ref/";   // reference STLs live next to this file, see README
  color("DimGray") translate([0, 61.10, 0]) rotate([90,0,0]) {
    import(str(D, "Lidar_assy - Lidar_holder-1.STL"));
    import(str(D, "Lidar_assy - YDLIDAR_driver-2.STL"));
    for (n = [1:5]) import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_", n, "-1.STL"));
  }
}

// each part is exported already resting on z = 0, oriented for printing
if (part == "tub")         translate([0,0,floor_t]) tub();
else if (part == "collar") translate([0,0,-tub_top]) collar();
else if (part == "lid")    translate([HEAD[0], HEAD[1], 0])
                             rotate([180,0,0])
                               translate([-HEAD[0], -HEAD[1], -lid_z0 - lid_t]) lid();
else {
  // cut the front half away in "section" so the fit can be eyeballed
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
        cube([OUT_X[1]-OUT_X[0]+10, HEAD[1]-OUT_Y[0]+5, 120]);
  }
  // laser band, drawn as a red disc - nothing solid may touch this
  if (part == "section")
    color("Red", 0.35) translate([HEAD[0], HEAD[1], OPT_Z[0]])
      cylinder(d = 130, h = OPT_Z[1] - OPT_Z[0]);
}
