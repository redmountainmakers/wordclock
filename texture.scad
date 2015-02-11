
clock_r = 104;
disc_thickness = 2.25;

difference() {
	cylinder(disc_thickness, clock_r+3, clock_r+3, $fn = 200);
	translate([0,0,-0.5])cylinder(disc_thickness + 1, clock_r, clock_r, $fn = 200);
}
difference() {
	cylinder(disc_thickness, clock_r, clock_r, $fn = 200);
	union() {
		translate([-96,-9, -0.5]) linear_extrude(height=disc_thickness + 1)minkowski(){
			square([48, 18]);
			circle((12/2));
		}
		translate([0,0,-5]) cylinder(6, 4, 4, $fn = 40);
	}	
	difference() {
		translate([-clock_r-1,-clock_r-4,2]) scale(3) linear_extrude(height = 4, center = true, convexity = 10) {
			for (k = [0:5:clock_r /1.4]) {
				for (i = [0:3:clock_r /1.4]) {
				   translate([k, i]) import (file = "egypt pattern.dxf");
				}
				for (j = [0:3:clock_r /1.4]) {
					   translate([k + 2.5, j+1.5]) import (file = "egypt pattern.dxf");
				}
			}
		}
		union() {
			translate([0,0,0]) cylinder(disc_thickness, 6, 6, $fn = 40);	
			translate([-98,-10, -0.5]) linear_extrude(height=disc_thickness + 1) minkowski(){
				square([51, 21]);
				circle((14/2));
			}
		}
	}
}