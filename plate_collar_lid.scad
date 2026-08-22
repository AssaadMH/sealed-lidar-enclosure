// One N2 plate holding the two flat V2 parts: collar + lid.
//
// Built by IMPORTING the exported STLs rather than re-deriving the geometry,
// so the plate is guaranteed to be the same solids that passed stlcheck and
// the clash checks. It also leaves ydlidar_x2_box_v2.scad untouched, which
// matters: editing that file would make it newer than stl_v2/*.stl and trip
// the staleness rule for no reason.
//
// PrusaSlicer's CLI would not do this itself - passing two STLs slices them
// separately and the second overwrites the first, and --merge produced the
// lid alone. Placing them here is deterministic.
//
// Export (needs the NIGHTLY + manifold; 2021.01 cannot boolean imported
// meshes at all):
//   openscad.exe --backend=manifold -o stl_v2/ydlidar_x2_v2_collar+lid_plate.stl \
//     --export-format=binstl plate_collar_lid.scad

GAP = 10;                       // clear space between the two parts

// measured extents of the two exported STLs
COLLAR_X = [ -3.48, 100.55];
LID_X    = [  2.60,  78.20];    // both share Y -7.25 .. 68.35, so no Y shift

DX = (COLLAR_X[1] + GAP) - LID_X[0];

echo(str("PLATE: collar ", COLLAR_X[1]-COLLAR_X[0], " wide + gap ", GAP,
         " + lid ", LID_X[1]-LID_X[0], " wide"));
echo(str("PLATE TOTAL X = ", (LID_X[1] + DX) - COLLAR_X[0], "  (bed is 300)"));

import("stl_v2/ydlidar_x2_v2_collar.stl");
translate([DX, 0, 0]) import("stl_v2/ydlidar_x2_v2_lid.stl");
