include <gears.scad>

$fn = 200;

gear(number_of_teeth=8, circular_pitch=220,
	hub_diameter=0, rim_width=0,
	hub_thickness=5,rim_thickness=5,gear_thickness=5);
				
translate([20, 20]){
	gear(number_of_teeth=8, circular_pitch=220,
		hub_diameter=0, rim_width=0,
		hub_thickness=5,rim_thickness=5,gear_thickness=5);
}