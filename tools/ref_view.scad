// Identify which reference part is which: one colour each, box coordinates.
// Each import is wrapped in its OWN transform (a transform with several
// children is an implicit union, which the old CGAL kernel chokes on).
D = "../ref/";
show_part = -1;   // -1 = all, else 1..5, 0 = holder, 6 = driver

module place() {
  translate([0, 61.10, 0]) rotate([90, 0, 0]) children();
}

if (show_part == -1 || show_part == 0)
  color("DimGray")     place() import(str(D, "Lidar_assy - Lidar_holder-1.STL"));
if (show_part == -1 || show_part == 1)
  color("Red")         place() import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_1-1.STL"));
if (show_part == -1 || show_part == 2)
  color("Orange")      place() import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_2-1.STL"));
if (show_part == -1 || show_part == 3)
  color("Yellow")      place() import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_3-1.STL"));
if (show_part == -1 || show_part == 4)
  color("LimeGreen")   place() import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_4-1.STL"));
if (show_part == -1 || show_part == 5)
  color("DodgerBlue")  place() import(str(D, "Lidar_assy - YDLIDAR_X2_Assy-1 Part_5-1.STL"));
if (show_part == -1 || show_part == 6)
  color("Magenta")     place() import(str(D, "Lidar_assy - YDLIDAR_driver-2.STL"));
