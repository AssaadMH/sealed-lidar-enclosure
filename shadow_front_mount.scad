// =====================================================================
//  SHADOW 4WD - FRONT LIDAR DROP MOUNT (bare YDLIDAR X2)        rev A
//
//  Hangs the BARE X2 from the reserved deck's UNDERSIDE, below the
//  Kinect, on a front-overhanging arm.
//
//  Three printed fittings on a 20x20 aluminium tube backbone:
//    deck_clamp - bolts to the deck underside, sockets the vertical tube
//    elbow      - 90 deg corner, vertical tube -> horizontal arm
//    cradle     - front end of the arm, carries the lidar's 3 feet
//
//  WHY A METAL BACKBONE, not one printed part: the drop is ~337 mm,
//  which does not fit the N2's 300 mm bed, and PLA creeps under a
//  sustained cantilever load outdoors. Structurally either would do -
//  a 20x20x2 alu tube deflects 0.012 mm at the lidar under its own
//  0.25 kg - so the driver is bed size and creep, not stiffness.
//
//  THE RULE THAT SHAPES EVERYTHING: nothing may cross the scan plane.
//  So the arm and the cradle live entirely BELOW the beam band, and the
//  vertical tube - which must cross it - is parked at the chassis front
//  face, inside the angular shadow the chassis already casts. That is
//  asserted, not assumed.
//
//  FRAME: origin at the UNDERSIDE OF THE LIDAR'S FEET, lidar vendor XY.
//  Robot forward = local -X (head forward, motor tail rearward).
//  Rearward = +X, so the chassis front face is at +OVERHANG of the head.
// =====================================================================

FM_PART = "assembly"; // deck_clamp|elbow|cradle|assembly|clash_beam|clash_lidar
$fn     = 72;

// ---------------------------------------------------------------------
//  ROBOT GEOMETRY  ***  CONFIRM ALL FIVE ON THE REAL VEHICLE  ***
//  These are read off the Under-Deck Sensor Plan figures, not measured.
// ---------------------------------------------------------------------
DECK_Z    = 620;    // deck UNDERSIDE above ground
BEAM_Z    = 320;    // target scan plane above ground   <-- the design knob
CHASSIS_W = 1053;   // body width at the scan height (sets coverage)
OVERHANG  = 200;    // head axis ahead of the chassis front face
KIN_Z     = 540;    // Kinect optical centre above ground
KIN_X     = 0;      // Kinect front face, relative to the chassis face
KIN_TILT  = 20;     // down-tilt actually commanded (NOT necessarily max)
KIN_VFOV  = 38;     // vertical field of view
RANGE_CAP = 8000;   // scan max_range
DIVE      = 2;      // worst-case suspension nose-dive

// ---------------------------------------------------------------------
//  LIDAR - copied from ydlidar_x2_box_v2.scad (2026-08-03), same source
//  meshes in ref/. Validated here by the clash_lidar check.
// ---------------------------------------------------------------------
LID_X      = [ 0.42, 96.65];
LID_Y      = [ 0.30, 60.80];
HEAD       = [40.40, 30.55];
HEAD_D     = 60.50;
HEAD_Z     = [48.32, 65.32];
OPT_Z      = [59.30, 64.00];   // laser window
FOOT_Z     = 14.669;           // feet underside, in the vendor frame
LEG_H      = 15.00;            // feet underside -> body underside
LIDAR_FEET = [[5.12,30.60],[76.39,12.59],[76.39,48.59]];

// ---------------------------------------------------------------------
//  TUNABLES
// ---------------------------------------------------------------------
TUBE      = 20.0;   // square alu tube, across flats
TUBE_CL   = 0.35;   // socket clearance per side
SOCK_W    = 3.2;    // socket wall
SOCK_L    = 55.0;   // socket engagement length
CRADLE_T  = 6.0;
PLATE_T   = 7.0;    // deck clamp flange
FLANGE    = [86, 86];
GUSSET    = 3.5;
DRIVER_CLR= 6.0;    // working room round a foot screw for a hex key

// --- shroud clearance -------------------------------------------------
// An earlier revision carried a SEPARATE sacrificial impact guard: splayed
// walls on L-feet, bolted to the cradle through heat-set inserts. It was
// deleted when the cradle became a C-section, because the C's roof and rear
// wall do the same job with no bolted joint and no walls beside the lidar.
// Its whole parameter block went with it; only this clearance survives.
CLR_GAP = 6.0;      // clear gap, shroud inner face to the lidar envelope

m3_free   = 3.4;
m3_cb     = 6.5;
m3_cbh    = 3.2;
m4_free   = 4.5;    // tube cross-bolts
M5_free   = 5.5;    // deck screws
M5_cb     = 10.0;
M5_cbh    = 4.0;
DECK_PAT  = 62.0;   // deck screw square pitch

// ---------------------------------------------------------------------
//  DERIVED
// ---------------------------------------------------------------------
BEAM_LO  = OPT_Z[0]  - FOOT_Z;      // 44.631 above the feet
BEAM_HI  = OPT_Z[1]  - FOOT_Z;      // 49.331
BEAM_MID = (BEAM_LO + BEAM_HI)/2;
TOP_H    = HEAD_Z[1] - FOOT_Z;      // 50.651, top of the rotating head
BODY_H   = LEG_H;                   // underside of the lidar body

MOUNT_Z  = BEAM_Z - BEAM_MID;       // feet plane, above ground
ZDECK    = DECK_Z - MOUNT_Z;        // deck underside, in LOCAL z
FACE_X   = HEAD[0] + OVERHANG;      // chassis front face, in LOCAL x

// coverage: the body's front corners are the only blockers
BLOCK    = 2*atan((CHASSIS_W/2)/OVERHANG);
COVER    = 360 - BLOCK;

// nose-dive: where the tilted beam meets the floor
STRIKE   = BEAM_Z / tan(DIVE);

// roof over the top - defined here because the Kinect check needs its height
ROOF_CLR = 2.5;                       // roof underside above the head top
ROOF_T   = 4.0;
WALL_T   = 5.0;                       // rear wall thickness
SIDE_M   = 4.0;                       // base/roof margin past the lidar in Y
ROOF_Z0  = TOP_H + ROOF_CLR;
ROOF_Z1  = ROOF_Z0 + ROOF_T;
REAR_IN  = LID_X[1] + CLR_GAP;        // inner face of the rear wall

// Kinect cone: lower edge, and the lidar's most-forward tall point
CONE     = KIN_TILT + KIN_VFOV/2;
LID_NOSE = OVERHANG + (HEAD[0] - LID_X[0]);   // lidar front edge ahead of face
CONE_REQ = tan(CONE) * (LID_NOSE - KIN_X);    // depth the cone needs
MOUNT_TOP= ROOF_Z1;                           // tallest point of the mount
CONE_AVL = KIN_Z - (MOUNT_Z + MOUNT_TOP);     // depth actually available

// The rear wall HAS to cross the beam band to reach the roof. That is only
// legal because it sits directly behind the lidar, inside the shadow the
// chassis already casts. Measured, not assumed.
RW_HALF  = atan(max(LID_Y[1] + SIDE_M - HEAD[1],
                    HEAD[1] - (LID_Y[0] - SIDE_M)) / (REAR_IN - HEAD[0]));

// vertical tube: parked behind the face, must sit inside the chassis shadow
VT_X     = FACE_X + TUBE/2 + SOCK_W;          // its centre, local x
VT_HALF  = atan((TUBE/2 + SOCK_W) / (VT_X - HEAD[0]));

// arm sits under the cradle plate
ARM_Z    = [-CRADLE_T - TUBE, -CRADLE_T];
SOCK_HALF= (TUBE + 2*TUBE_CL)/2 + SOCK_W;

// *** THE THREE FOOT SCREWS DRIVE THE ARM LAYOUT ***
// They enter from BELOW, so the arm must leave a hex key room at each one.
// The socket is therefore sized to fill exactly the X gap between the front
// foot and the two rear feet, instead of running the length of the cradle.
FX        = [for (p=LIDAR_FEET) p[0]];
GAP0      = min(FX) + m3_cb/2 + DRIVER_CLR;   // behind the front foot
GAP1      = max(FX) - m3_cb/2 - DRIVER_CLR;   // ahead of the rear feet
CR_SOCK_L = GAP1 - GAP0;
// past the socket the bare tube still runs under the cradle - check that too
TUBE_CLR  = min([for (p=LIDAR_FEET)
                   if (abs(p[1]-HEAD[1]) > 1) abs(p[1]-HEAD[1]) - m3_cb/2 - TUBE/2]);

echo(str("FM_PART = ", FM_PART));
echo(str("scan plane ", BEAM_Z, " mm;  feet plane ", MOUNT_Z,
         " mm;  deck-to-arm drop ", ZDECK - ARM_Z[0],
         " mm (NOT a cut length - cut the post to CUT LIST below)"));
echo(str("COVERAGE ", COVER, " deg usable  /  ", BLOCK, " deg masked",
         "   => mask sector +/-", BLOCK/2));
echo(str("nose-dive strike ", STRIKE, " mm  vs range cap ", RANGE_CAP,
         "   margin ", STRIKE - RANGE_CAP));
echo(str("Kinect cone: needs ", CONE_REQ, " mm, has ", CONE_AVL,
         " mm,  margin ", CONE_AVL - CONE_REQ, " mm"));
echo(str("rear wall subtends +/-", RW_HALF,
         " deg, inside the ", BLOCK/2, " deg chassis shadow"));
echo(str("vertical tube subtends +/-", VT_HALF,
         " deg, inside the ", BLOCK/2, " deg chassis shadow"));

// --- hard stops -------------------------------------------------------
assert(STRIKE > RANGE_CAP,
       "nose-dive puts the beam on the floor INSIDE max_range - raise BEAM_Z or cut RANGE_CAP");
assert(CONE_AVL > CONE_REQ,
       "the lidar head pokes into the Kinect's depth cone - lower BEAM_Z, cut KIN_TILT, or pull OVERHANG in");
assert(VT_HALF < BLOCK/2,
       "the vertical tube is OUTSIDE the chassis shadow - it would cut a fresh blind sector");
assert(ARM_Z[1] < BEAM_LO,
       "the arm rises into the beam band");
assert(CRADLE_T - m3_cbh > 2.0, "cradle too thin under the foot counterbores");
assert(ZDECK > TOP_H + 20, "the deck is not clear of the lidar head");
assert(MOUNT_Z > 0, "the feet plane is below ground");
assert(SOCK_L > 2.5*TUBE, "tube socket engagement under 2.5 x tube width");
assert(CR_SOCK_L > 2.2*TUBE,
       "cradle socket too short once the foot screws are cleared");
assert(ROOF_Z0 > BEAM_HI + 2,
       "the roof underside is inside the laser band - raise ROOF_CLR");
assert(ROOF_Z0 > TOP_H + 1,
       "the roof would foul the top of the rotating head");
assert(ROOF_Z0 - R_IN > BEAM_HI,
       "the inner roof fillet dips into the laser band - cut R_IN");
assert(REAR_IN > LID_X[1],
       "the rear wall is inside the lidar envelope");
assert(RW_HALF < BLOCK/2,
       "the rear wall is OUTSIDE the chassis shadow - it would cut a fresh blind sector");
assert(CLR_GAP > 4, "shroud is too close to the lidar envelope");
for (b = UBOLT) for (f = LIDAR_FEET)
  assert(norm([b[0]-f[0], b[1]-f[1]]) > (M5_cb + m3_cb)/2 + 1,
         "a U mounting bolt fouls a lidar foot screw");
assert(TUBE_CLR > 3.0,
       "the arm tube crowds a foot screw counterbore - narrow TUBE or offset the arm");

// ---------------------------------------------------------------------
//  HELPERS
// ---------------------------------------------------------------------
module rrect(xr, yr, r) {
  hull() for (x=[xr[0]+r, xr[1]-r], y=[yr[0]+r, yr[1]-r])
    translate([x,y]) circle(r=r);
}
// a square socket: outer block minus the tube pocket, cross-bolted
module socket(len, bolts=true) {
  b = TUBE + 2*TUBE_CL;
  difference() {
    translate([0, -(b/2+SOCK_W), -(b/2+SOCK_W)])
      cube([len, b+2*SOCK_W, b+2*SOCK_W]);
    translate([-1, -b/2, -b/2]) cube([len+2, b, b]);
    if (bolts) for (i=[0.28, 0.75])
      translate([len*i, 0, -(b/2+SOCK_W+1)])
        cylinder(d=m4_free, h=b+2*SOCK_W+2);
  }
}
module tube_ghost(len) {
  color("Silver") translate([0,-TUBE/2,-TUBE/2]) cube([len, TUBE, TUBE]);
}
module lidar_ghost() {
  for (n=[1:5]) color("DimGray")
    translate([0,0,-FOOT_Z]) translate([0,61.10,0]) rotate([90,0,0])
      import(str("ref/Lidar_assy - YDLIDAR_X2_Assy-1 Part_", n, "-1.STL"));
}
module beam_disc() {
  translate([HEAD[0], HEAD[1], BEAM_LO]) cylinder(d=900, h=BEAM_HI-BEAM_LO);
}

// ---------------------------------------------------------------------
//  CRADLE - a U lying on its side, opening FORWARD. Base under the
//  lidar, a rear wall behind it, and a roof over the top. No side walls.
//
//  The roof is free: a 2D lidar is blinded only by what sits IN its own
//  plane, so a slab overhead costs no coverage at all. The roof underside
//  clears the top of the rotating head, and the rear wall lives behind
//  the lidar inside the already-masked rear sector.
//
//  PRINTS ON ITS SIDE (rotate 90 about X): the whole C profile then lies
//  in the bed plane and extrudes straight up - zero overhang, and ~1400
//  mm2 of bed contact. Printing it base-down would leave the roof as a
//  110 mm unsupported bridge.
// ---------------------------------------------------------------------
CR_X     = [LID_X[0] - SIDE_M, REAR_IN + WALL_T];
CR_Y     = [LID_Y[0] - SIDE_M, LID_Y[1] + SIDE_M];
UBOLT    = [for (x=[25,62], y=[6,55]) [x,y]];

// Styling. The part prints on its side, so the XZ profile can be shaped
// as much as we like at ZERO overhang cost - that is where all the
// smoothing goes. Nothing here moves a functional surface: the roof
// underside, the base top, the rear wall face and every hole are
// untouched, and the clash checks re-run to prove it.
R_OUT  = 6.0;    // outer corner radius of the C profile
R_IN   = 3.5;    // fillet at the two inner corners. Capped by the beam:
                 // ROOF_Z0 - R_IN must stay above BEAM_HI.
R_EDGE = 1.2;    // knocks the sharp tips off the two front lips
CH_Y   = 1.2;    // 45 deg chamfer on both side faces

// C profile, drawn in (lidar X, lidar Z)
module prof() {
  offset(R_EDGE) offset(-R_EDGE) difference() {
    hull() for (x = [CR_X[0]+R_OUT, CR_X[1]-R_OUT],
                y = [-CRADLE_T+R_OUT, ROOF_Z1-R_OUT])
      translate([x,y]) circle(r=R_OUT);
    hull() for (x = [CR_X[0]-40, REAR_IN-R_IN], y = [R_IN, ROOF_Z0-R_IN])
      translate([x,y]) circle(r=R_IN);
  }
}

// The side chamfer is STEPPED, not hulled. hull() takes the CONVEX hull,
// and this profile is a C - hulling it fills the cavity solid and drops a
// slab straight through the laser band. Cost 1189 mm3 of blind sector the
// first time. Stacked offsets cannot fill anything.
CH_N = 10;   // steps across the side chamfer - 0.12 mm each, invisible in print
module c_body() {
  W = CR_Y[1] - CR_Y[0];
  translate([0, CR_Y[1], 0]) rotate([90,0,0]) union() {
    translate([0,0,CH_Y]) linear_extrude(W - 2*CH_Y) prof();
    for (i = [0:CH_N-1]) {
      t = CH_Y/CH_N;
      o = -CH_Y * (1 - i/CH_N);
      // The 0.01 is a MERGE overlap and must grow INWARD on both sides.
      // Extruding the far side upward from W-(i+1)*t pushed the i=0 step to
      // W+0.01, i.e. 0.01 mm proud of the side face - and that face is the
      // one that lands on the bed, so the cradle exported to z = -0.01.
      translate([0,0,i*t])              linear_extrude(t + 0.01) offset(o) prof();
      translate([0,0,W-(i+1)*t-0.01])   linear_extrude(t + 0.01) offset(o) prof();
    }
  }
}

module cradle() {
  difference() {
    c_body();
    for (p = LIDAR_FEET) translate([p[0], p[1], 0]) {                // 3 lidar screws
      translate([0,0,-CRADLE_T-1]) cylinder(d=m3_free, h=CRADLE_T+2);
      translate([0,0,-CRADLE_T-0.01]) cylinder(d=m3_cb, h=m3_cbh+0.01);
    }
    for (b = UBOLT) translate([b[0], b[1], -CRADLE_T-1])             // mount to robot
      cylinder(d=M5_free, h=CRADLE_T+2);
  }
}

module elbow() {
  b = TUBE + 2*TUBE_CL + 2*SOCK_W;
  union() {
    // arm socket, opening forward (-x)
    translate([VT_X - b/2, HEAD[1], ARM_Z[1]-TUBE/2])
      rotate([0,0,180]) socket(SOCK_L);
    // vertical socket, opening up
    translate([VT_X, HEAD[1], ARM_Z[1]-TUBE/2])
      rotate([0,-90,0]) socket(SOCK_L);
    // corner gusset, entirely below the arm's top face
    hull() {
      translate([VT_X - b/2, HEAD[1]-GUSSET/2, ARM_Z[0]-b/2+TUBE/2])
        cube([b, GUSSET, 0.1]);
      translate([VT_X - b/2 - SOCK_L*0.7, HEAD[1]-GUSSET/2, ARM_Z[0]])
        cube([0.1, GUSSET, 0.1]);
    }
  }
}

// ---------------------------------------------------------------------
//  DECK CLAMP - flange to the deck underside + vertical tube socket
// ---------------------------------------------------------------------
module deck_clamp() {
  b = TUBE + 2*TUBE_CL + 2*SOCK_W;
  difference() {
    union() {
      translate([VT_X, HEAD[1], ZDECK - PLATE_T])
        linear_extrude(PLATE_T)
          rrect([-FLANGE[0]/2, FLANGE[0]/2], [-FLANGE[1]/2, FLANGE[1]/2], 8);
      translate([VT_X, HEAD[1], ZDECK - PLATE_T - SOCK_L])
        rotate([0,-90,0]) socket(SOCK_L);
      // two gussets tying the flange down onto the socket
      for (sy=[-1,1]) hull() {
        translate([VT_X-b/2, HEAD[1]+sy*GUSSET/2, ZDECK-PLATE_T-0.1])
          cube([b, GUSSET, 0.1]);
        translate([VT_X-b/2, HEAD[1]+sy*(FLANGE[1]/2-GUSSET), ZDECK-PLATE_T-0.1])
          cube([b, GUSSET, 0.1]);
      }
    }
    for (sx=[-1,1], sy=[-1,1])
      translate([VT_X + sx*DECK_PAT/2, HEAD[1] + sy*DECK_PAT/2, 0]) {
        translate([0,0,ZDECK-PLATE_T-1]) cylinder(d=M5_free, h=PLATE_T+2);
        translate([0,0,ZDECK-M5_cbh]) cylinder(d=M5_cb, h=M5_cbh+1);
      }
  }
}

// ---------------------------------------------------------------------
//  ARM / POST lengths
// ---------------------------------------------------------------------
ARM_LEN  = (VT_X - SOCK_HALF) - GAP0;
POST_LEN = ZDECK - PLATE_T - (ARM_Z[1]-TUBE/2);
echo(str("FOOT SCREW ACCESS: socket spans x ", GAP0, "..", GAP1,
         " (len ", CR_SOCK_L, "),  bare tube clears the rear counterbores by ",
         TUBE_CLR, " mm"));
echo(str("C-SECTION base X ", CR_X, " Y ", CR_Y,
         ";  roof ", ROOF_Z0, "..", ROOF_Z1, " (head top ", TOP_H,
         ", beam ", BEAM_LO, "..", BEAM_HI, ")"));
echo(str("CUT LIST: horizontal arm ", ARM_LEN,
         " mm,  vertical post ", POST_LEN, " mm  (20x20 alu)"));

module printed() { cradle(); elbow(); deck_clamp(); }
module tubes() {
  translate([GAP0, HEAD[1], ARM_Z[1]-TUBE/2]) tube_ghost(ARM_LEN);
  translate([VT_X, HEAD[1], ARM_Z[1]-TUBE/2]) rotate([0,-90,0]) tube_ghost(POST_LEN);
}

// ---------------------------------------------------------------------
//  DISPATCH - unknown part renders nothing, deliberately
// ---------------------------------------------------------------------
// Print orientations. Each lands at z >= 0 with no support needed:
// cradle    - feet face on the bed, tube socket rising
// elbow     - arm socket lying, vertical socket rising
// deck_clamp- flange face on the bed, socket rising
EL_MIN    = ARM_Z[1] - TUBE/2 - SOCK_HALF;
// the U prints plate-down / walls-up, so it just lifts to z = 0
// prints on its SIDE: the C profile lies in the bed plane, extrudes up
if (FM_PART == "cradle")          translate([0,0,-CR_Y[0]]) rotate([90,0,0])
                                    translate([0,0,CRADLE_T]) cradle();
else if (FM_PART == "elbow")      translate([0,0,-EL_MIN]) elbow();
else if (FM_PART == "deck_clamp") translate([0,0,ZDECK]) rotate([180,0,0]) deck_clamp();
else if (FM_PART == "assembly") { printed(); tubes(); %lidar_ghost(); }
else if (FM_PART == "clash_beam")
  // Everything FORWARD of the rear wall, against the beam band. Must be
  // EMPTY. The rear wall itself is excluded on purpose - it has to cross
  // the band to reach the roof, and the RW_HALF assert is what covers it.
  intersection() {
    union() { printed(); tubes(); }
    beam_disc();
    translate([-500, -500, -500]) cube([500+REAR_IN-0.05, 1000, 1000]);   // 0.05 back off the coincident rear face
  }
else if (FM_PART == "clash_lidar")
  intersection() { union() { printed(); tubes(); } lidar_ghost(); }
else echo("*** UNKNOWN FM_PART - nothing rendered ***");
