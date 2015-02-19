include <gears.scad>
include <utils.scad>

disable_cover_plate = true;
disable_hours_disc = true;
disable_hours_text = true;
disable_minutes_disc = false;
disable_minutes_text = true;
disable_base = true;

enable_text_chamfer = true; // only for 3d-printing

clock_r = 97;
motor_r = 12;
motor_h = 16;
clearance = 0.5;
axis_r = 3.7;
disc_thickness = 2.25;
wall_thickness = 2;
font_size = clock_r * .11; // scale font based on radius

module hours_disc() {
	r = clock_r - (wall_thickness + clearance);
	bump_h = disc_thickness + clearance + 4;
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
                    disc_with_slots(r=r, slot_width=r*.5, offset=[r*.5,1,-0.5]);

					// small spacer ring
					translate([0,0,-.5]) ring(r1 = 34, r2 = 34 - 1.5, h = clearance);
					
                    // bumps
                    for (i = [0 : len(HOURS) - 1]) {
                        angle = (i + 1) * 360 / len(HOURS);
                        rotate(90 - angle) {
                            translate([r - 4.2, -22, -bump_h]) cylinder(bump_h, 1.5, 1.5);
                        }
                    }

                    // home bump
                    rotate(-4) translate([r - 4.2, -22, -bump_h]) cylinder(bump_h, 1.5, 1.5);

                    // center cylinder
                    translate([0, 0, -bump_h]) cylinder(bump_h, 26, 26, $fn = 200);
                }
            }
            // hours text
            if (!disable_hours_text || !disable_hours_disc) {
                color("blue") clock_words(from_edge=8, font_size=font_size, words=HOURS);
				if (enable_text_chamfer) {
				   // subtract some of the hours text from the first layer
				   // text is offset by -0.5 and first layer is 0.3mm -> want to offset by:
				   outline_z = disc_thickness + 0.2;
				   // outline distance away from main text
				   outline_r = 0.8;
				   for (theta = [0 : 30 : 359]) {
					   translate([outline_r * cos(theta), outline_r * sin(theta), outline_z]) {
						   color("dodgerblue") clock_words(from_edge=8, font_size=font_size, words=HOURS);
					   }
				   }
			   }
            }
        }
        if (!disable_hours_disc) {
            translate([0,0,-(bump_h + .5)]) gear(number_of_teeth=36, circular_pitch=220,
                hub_diameter=0, rim_width=0,
                hub_thickness=bump_h + 1,rim_thickness=bump_h + 1,gear_thickness=bump_h + 1);
        }
    }
}

module minutes_disc() {
	r = clock_r - (wall_thickness + clearance + 3.5);
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
                    disc_with_slots(r = r, slot_width=r*.7, slot_r=font_size*.6, offset=[r*.5,-12,-0.5]);

                    // bumps
                    for (i = [0 : len(mins) - 1]) {
                        angle = (i + 1) * 360 / len(mins);
                        rotate(90 - angle) {
                            translate([r - 4.2, -22, -4]) cylinder(4, 1.5, 1.5);
                        }
                    }

                    // home bump
                    rotate(-4) translate([r - 4.2, -22, -4]) cylinder(4, 1.5, 1.5);

                    // center cylinder and gear
                    translate([0,0,-4]) gear(number_of_teeth=52,
                            circular_pitch=220,
                            hub_diameter=0,
                            rim_width=0,
                            rim_thickness=4,
                            hub_thickness=4);
                }
            }
            // minutes text
            if (!disable_minutes_text || !disable_minutes_disc) {
                color("red") clock_words(from_edge=10, center_offset=-8.8, font_size=6.5, words=mins);
				if (enable_text_chamfer) {
				   // subtract some of the minutes text from the first layer
				   // text is offset by -0.5 and first layer is 0.3mm -> want to offset by:
				   outline_z = disc_thickness + 0.2;
				   // outline distance away from main text
				   outline_r = 0.6;
				   for (theta = [0 : 30 : 359]) {
					   translate([outline_r * cos(theta), outline_r * sin(theta), outline_z]) {
						   color("mediumvioletred") clock_words(from_edge=10, center_offset=-8.8, font_size=6.5, words=mins);
					   }
				   }
			   }
            }
        }

        // cut out center cylinder where hours disc fits in
        if (!disable_minutes_disc) {
            gap_between_discs = 2.75;
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

module cool_cover_disc(r = clock_r, h=17) {
	rect_w = r*.6;
	rect_h = r*.28;
    difference() {	
		union() {
			translate([0,0,-(h-disc_thickness)-4]) ring(r1=r, r2=r - wall_thickness, h=h+4); //side walls			
			ring(r1=r, r2=r-3, h=disc_thickness); // outer ring
			disc_with_pattern(r-.5);
			translate([-(r*.38 + rect_w), -rect_h/2]) rounded_rect(rect_w, rect_h, disc_thickness, 6); // solid around text cut out
			cylinder(disc_thickness, 6, 6, $fn = 40); // spot for cover to glue on main axis
		}
		translate([-(r*.38 + (rect_w - 2)), -(rect_h-4)/2, -0.5]) rounded_rect(rect_w - 4, rect_h - 4, disc_thickness + 1, 4); // text cut out
		translate([0,0,-4.25]) cylinder(6, axis_r + 0.3, axis_r + 0.3, $fn = 40); // axis notch
		
		snapfit = r - (wall_thickness/2);
		translate([0,0,-(h+disc_thickness)]) cylinder(5, snapfit, snapfit,$fn = 200);
    }
}

module base_disc(r = clock_r, height = 16, disc_support = 19) {
    // disc support with motor holes
	difference() {
		ring(r1=28, r2=28-(wall_thickness*2), h = disc_support);
		translate([-20,0, 0]) cylinder(motor_h + 0.5, motor_r + 1, motor_r + 1); // motor 1
		translate([30, 0, 0]) cylinder(motor_h + 0.5, motor_r + 1, motor_r + 1); // motor 2
	}

    // core spindle
    cylinder(29, axis_r, axis_r, $fn = 40);

    // switch platform
    translate([clock_r - (wall_thickness + 10),0,0]) cube([10,10,12]);

    // main bottom
	snapfit = r - (wall_thickness/2);
    difference() {
        cylinder(height - disc_thickness, r, r, $fn = 200);
        translate([0,0,disc_thickness]) cylinder(height - disc_thickness, r - wall_thickness, r - wall_thickness, $fn = 200);
		translate([0,0,height-disc_thickness-4]) ring(r1=snapfit + 10, r2=snapfit, h=4.5); // notch for snap fit
    }
}

// main clock parts
if (!disable_cover_plate) {
    translate([0, 0, disc_thickness + clearance]) cool_cover_disc();
}

difference() {
    union() {
        display_hour = 11;
        display_min  = 25;
        rotate((360 / 12) * (display_hour - 2)) hours_disc();
        rotate((360 / 60) * (display_min - 10)) translate([0, 0, -(disc_thickness + clearance)]) minutes_disc();
    }
    if (!disable_hours_disc || !disable_hours_text ||
        !disable_minutes_disc || !disable_minutes_text) {
        union() {
            translate([0,0,-50]) cylinder(100, 4, 4, $fn = 100); // main axis cutout
        }
    }
}

if (!disable_base) {
    translate([0,0,-25.75]) base_disc();
}
