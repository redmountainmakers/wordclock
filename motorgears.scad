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

translate([25,0]) worm_motor_gear();
translate([25,25]) worm_motor_gear(2.7);
translate([25,50]) worm_motor_gear(2.8);
translate([25,75]) worm_motor_gear(2.9);

// translate([75,0]) motor_gear(7.1);
// translate([75,25]) motor_gear(7.2);
// translate([75,50]) motor_gear(7);

// translate([25,0]) motor_gear(5.8, 9);
// translate([25,25]) motor_gear(5.9, 9);
// translate([25,50]) motor_gear(6, 9);