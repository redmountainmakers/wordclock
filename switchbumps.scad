include <utils.scad>

module straight_nub(w = 2, h = 4, l = 10) {
	difference() {
		cube([w,l*2,h]);
		 translate([-0.5,-8,-2]) rotate([20,0,0])cube([w+1,l*2,h]);
	}
}

module circular_nub(r = 100, w = 2, h = 6.75) {
	intersection() {
		ring(r,r-w,h);
		rotate([0,40,0]) translate([-h, r - (h*2), -h-4.5]) cube([40, w*8, w*8]);
	}
}

// rotate_360(12) {
	// circular_nub();
// }
rotate_360(12) {
	circular_nub(90);
}

rotate_360(12) {
	translate([0, 67, 0]) straight_nub();
}
