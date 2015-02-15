include <gears.scad>
include <utils.scad>

disable_cover_plate = true;
disable_hours_disc = true;
disable_hours_text = true;
disable_minutes_disc = true;
disable_minutes_text = true;
disable_base = false;

enable_text_chamfer = true; // only for 3d-printing

clock_r = 104;
axis_r = 3.7;
disc_thickness = 2.25;
wall_thickness = 2;

module hours_disc() {
	HOURS = [
		"TWELVE",
		"ONE",
		"TWO",
		"THREE",
		"FOUR",
		"FIVE",
		"SIX",
		"SEVEN",
		"EIGHT",
		"NINE",
		"TEN",
		"ELEVEN"
	];
    difference() {
        difference() {
            if (!disable_hours_disc) {
                color("lightblue") union() {
                    // hours disc
                    disc_with_slots();

                    // bumps
                    for (i = [0 : len(mins) - 1]) {
                        angle = (i + 1) * 360 / len(mins);
                        rotate(90 - angle) {
                            translate([clock_r - 5, -10, -16]) {
                                cube([4, 4, 18]);
                            }
                        }
                    }

                    // home bump
                    rotate(4) translate([clock_r - 5, -10, -16]) cube([4, 4, 18]);

                    // center cylinder
                    translate([0, 0, -16]) cylinder(16, 26, 26, $fn = 200);
                }
            }
            // hours text
            if (!disable_hours_text || !disable_hours_disc) {
                color("blue") clock_words(from_edge=6.5, center_offset=0.5, words=HOURS);
				if (enable_text_chamfer) {
				   // subtract some of the hours text from the first layer
				   // text is offset by -0.5 and first layer is 0.3mm -> want to offset by:
				   outline_z = disc_thickness + 0.2;
				   // outline distance away from main text
				   outline_r = 0.8;
				   for (theta = [0 : 30 : 359]) {
					   translate([outline_r * cos(theta), outline_r * sin(theta), outline_z]) {
						   color("dodgerblue") clock_words(
							   from_edge=6.5,
							   center_offset=0.5,
							   letter_depth=1,
							   words=HOURS);
					   }
				   }
			   }
            }
        }
        if (!disable_hours_disc) {
            translate([0,0,-16.5]) gear(number_of_teeth=36, circular_pitch=220,
                hub_diameter=0, rim_width=0,
                hub_thickness=17,rim_thickness=17,gear_thickness=17);
        }
    }
}

module minutes_disc() {
	mins = [
		"o'clock",
		"oh five",
		"ten",
		"fifteen",
		"twenty",
		"twenty-five",
		"thirty",
		"thirty-five",
		"forty",
		"forty-five",
		"fifty",
		"fifty-five"
	];
    difference() {
        difference() {
            if (!disable_minutes_disc) {
                color("pink") union() {
                    // minutes disc (make it smaller)
                    disc_with_slots(r = clock_r - 6, slot_width=clock_r - 45, slot_r=6.8, offset=[50,-12.6,-0.5]);

                    // bumps
                    for (i = [0 : len(mins) - 1]){
                        angle = (i + 1) * 360 / len(mins);
                        rotate(90-angle) translate([90, 22, -8]) cube([4,4,8]);
                    }

                    // home bump
                    rotate(4) translate([90, 22, -8]) cube([4, 4, 8]);

                    // center cylinder and gear
                    translate([0,0,-3]) gear(number_of_teeth=52,
                            circular_pitch=220,
                            hub_diameter=0,
                            rim_width=0,
                            rim_thickness=5,
                            hub_thickness=5);
                }
            }
            // minutes text
            if (!disable_minutes_text || !disable_minutes_disc) {
                color("red") clock_words(from_edge=10, center_offset=-9.5, font_size=6.5, words=mins);
				if (enable_text_chamfer) {
				   // subtract some of the minutes text from the first layer
				   // text is offset by -0.5 and first layer is 0.3mm -> want to offset by:
				   outline_z = disc_thickness + 0.2;
				   // outline distance away from main text
				   outline_r = 0.6;
				   for (theta = [0 : 30 : 359]) {
					   translate([outline_r * cos(theta), outline_r * sin(theta), outline_z]) {
						   color("mediumvioletred") clock_words(
							   from_edge=10,
							   center_offset=-9.5,
							   font_size=6.5,
							   letter_depth=1,
							   words=mins);
					   }
				   }
			   }
            }
        }

        // cut out center cylinder where hours disc fits in
        if (!disable_minutes_disc) {
            gap_between_discs = 2;
            translate([0,0,-20]) cylinder(
                30,
                r1=30 - gap_between_discs,
                r2=30 - gap_between_discs,
                $fn=300);
        }
    }
}

module cover_plate() {
    square_size = (clock_r * 1.8);
    rounded = 12;
    move = (square_size/2) - (rounded/2);

    difference() {
        linear_extrude(height=disc_thickness) difference(){
            translate([-move,-move]) minkowski() {
                square(square_size-rounded);
                circle(rounded/2);
            }
            union() {
                translate([-move-6,14.9]) fillet(rounded);
                translate([-move-14,-9]) minkowski(){
                    square([52, 18]);
                    circle((rounded/2));
                }
                translate([-move-6,-14.9]) rotate(180) mirror() fillet(rounded);
            }
        }

        translate([0,0,-5]) cylinder(6, 4, 4, $fn = 40);
    }
}

module cover_disc() {
    difference() {
        cylinder(disc_thickness, clock_r + 3, clock_r + 3, $fn = 200);
        union() {
            translate([-96,-9, -0.5]) linear_extrude(height=disc_thickness + 1)minkowski(){
                square([48, 18]);
                circle((12/2));
            }
            translate([0,0,-5]) cylinder(6, 4, 4, $fn = 40);
        }
    }
}

module cool_cover_disc(h=16.5) {	
    difference() {	
		union() {
			translate([0,0,-(h-disc_thickness)]) ring(r1=clock_r + 3, r2=clock_r + 3 - wall_thickness, h=h); //side walls			
			ring(r1=clock_r + 3, r2=clock_r-2, h=disc_thickness); // outer ring
			disc_with_pattern(clock_r);
			translate([-93.5,-8, 0]) rounded_rect(54, 25, disc_thickness, 9); // solid around text cut out
			cylinder(disc_thickness, 6, 6, $fn = 40); // spot for cover to glue on main axis
		}		
		translate([-93.5,-8, -0.5]) rounded_rect(51, 22, disc_thickness + 1, 6); // text cut out
		translate([0,0,-4.25]) cylinder(6, axis_r + 0.3, axis_r + 0.3, $fn = 40); // axis notch
    }
}

module base_disc(r = clock_r + 3, height = 16, disc_support = 19) {
    // disc support with motor holes
	difference() {
		ring(r1=28, r2=28-(wall_thickness*2), h = disc_support);
		translate([-20,0, 0]) cylinder(16.5, 14.5, 14.5); // motor 1
		translate([30, 0, 0]) cylinder(16.5, 14.5, 14.5); // motor 2
	}

    // core spindle
    cylinder(28.25, axis_r, axis_r, $fn = 40);

    // switch platform
    translate([-clock_r + 1.25,0,0]) cube([10,10,12]);

    // main bottom
    difference() {
        cylinder(height - disc_thickness, r, r, $fn = 200);
        translate([0,0,1]) cylinder(height, r - wall_thickness, r - wall_thickness, $fn = 200);
    }
}

// main clock parts
if (!disable_cover_plate) {
    translate([0, 0, 3.25]) cool_cover_disc();
}

difference() {
    union() {
        display_hour = 12;
        display_min  = 25;
        rotate((360 / 12) * (display_hour - 2)) hours_disc();
        rotate((360 / 60) * (display_min - 10)) translate([0, 0, -(disc_thickness + 1.25)]) minutes_disc();
    }
    if (!disable_hours_disc || !disable_hours_text ||
        !disable_minutes_disc || !disable_minutes_text) {
        union() {
            translate([0,0,-50]) cylinder(100, 4, 4, $fn = 100); // main axis cutout
            translate([0,0,-21]) cylinder(14, clock_r+4, clock_r+4); // normalize bottom
        }
    }
}

if (!disable_base) {
    translate([0,0,-25.5]) base_disc();
}
