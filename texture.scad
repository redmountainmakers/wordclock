
difference() {
cube([18,18,3]);

translate([0,-2,2]) scale(1.2) linear_extrude(height = 4, center = true, convexity = 10) {
	for (k = [0:5:20]) {
		for (i = [0:3:18]) {
		   translate([k, i]) import (file = "egypt pattern.dxf");
		}
		for (j = [0:3:18]) {
			   translate([k + 2.5, j+1.5]) import (file = "egypt pattern.dxf");
		}
	}
}
}