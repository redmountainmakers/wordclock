include <gears.scad>

$fn = 200;

module motor_gear(motor_mount_d=7.8, teeth=10) {
	difference() {
		gear(number_of_teeth=teeth, circular_pitch=220,
			hub_diameter=0, rim_width=0,
							bore_diameter=2,
			hub_thickness=5,rim_thickness=5,gear_thickness=5);
		
		translate([0,0,1.1]) cylinder(3.9, motor_mount_d/2, motor_mount_d/2);
	}
}

module worm_motor_gear(notch_r = 2.6, axis_h = 2.5) {
    difference() {
        union() {
            translate([0,0,3]) cylinder(2, 3.5, 3.5);
            translate([0,0,5]) cylinder(axis_h, 1, .7);
            gear(number_of_teeth=9, circular_pitch=220,
                hub_diameter=0, rim_width=0, bore_diameter=0,
                hub_thickness=4,rim_thickness=4,gear_thickness=4);
        }
        for (i = [0 : 2 : 43]) {
            rotate(i) translate([notch_r,0,3]) cylinder(2, 1, 1);
        }        
    }
}

module magnet_hole(magnet_r = 1.5) {
	difference() {
		cube([10, 10, 2.25]);
		translate([5, 5, 2.25 - 1.5]) cylinder(1.55, magnet_r, magnet_r, $fn=30);
	}
}

translate([50,0]) worm_motor_gear();
translate([50,35]) worm_motor_gear(2.7);
translate([50,70]) worm_motor_gear(2.8);
translate([50,105]) worm_motor_gear(2.9);

translate([-50,0]) magnet_hole(1.45);
translate([-50,10]) magnet_hole(1.475);
translate([-50,20]) magnet_hole(1.5);
translate([-50,30]) magnet_hole(1.525);
translate([-50,40]) magnet_hole(1.55);



