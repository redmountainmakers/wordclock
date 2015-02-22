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

motor_gear(6.9);
translate([25,25]) motor_gear(5.6, 9);