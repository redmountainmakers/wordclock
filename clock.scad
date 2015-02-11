include <gears.scad>

clock_r = 104;
disc_thickness = 2.25;

hours = [
    "twelve",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven"
];
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

module clock_words(
    from_edge=6.0,
    letter_depth=disc_thickness,
    center_offset=0,
    font_size=12,
    words
) {
    for (i = [0 : len(words) - 1]) {
        angle = (i + 1) * 360 / len(mins);
        rotate(90 - angle) {
            translate([-clock_r + from_edge, center_offset]) {
                linear_extrude(height=letter_depth) {
                    text(words[i], size=font_size);
                }
            }
        }
    }
}

module hours_disc() {
    difference() {
        union() {
            if (!disable_hours_disc) {
                difference() {
                    // hours disc
                    $fn = 300; cylinder(disc_thickness, r=clock_r);

                    // see-through slots
                    for (i = [0 : len(mins) - 1]) {
                        width = clock_r - 55;
                        angle = (i + 1) * 360 / len(mins);
                        rotate(90 - angle) {
                            translate([52, 2, -0.5]) {
                                linear_extrude(height=disc_thickness + 1) {
                                    hull() {
                                        translate([0, 5]) circle(5.4);
                                        translate([width - 9, 5]) circle(5.4);
                                    }
                                }
                            }
                        }
                    }
                }
                
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
                rotate(10) translate([clock_r - 5, -10, -16]) cube([4, 4, 18]);
            }
            
            // hours text
            if (!disable_hours_text) {
                color("blue") clock_words(from_edge=8, center_offset=2.1, words=hours);
            }
            
            // center cylinder and gear
            if (!disable_hours_disc) {
                translate([0, 0, -16]) cylinder(16, 26, 26);
            }		
        }
		translate([0,0,-16.5])gear(number_of_teeth=36,
						circular_pitch=220,
						hub_diameter=0,
						rim_width=0,
						hub_thickness=17,rim_thickness=17,gear_thickness=17);
    }
}

module minutes_disc() {
    difference() {
        union() {
            if (!disable_minutes_disc) {
                // minutes disc
                $fn = 300; color("pink") cylinder(disc_thickness, r=clock_r - 6);
                
                // bumps
                for (i = [0 : len(mins) - 1]){
                    angle = (i + 1) * 360 / len(mins);
                    rotate(90-angle) translate([clock_r - 11, -10, -8]) cube([4,4,8]);
                }
                
                // home bump
                rotate(10) translate([clock_r - 11, -10, -8]) cube([4, 4, 8]);
            }
            
            // hours text
            if (!disable_minutes_text) {
                color("red") clock_words(from_edge=10, center_offset=-10, font_size=7, words=mins);
            }
            
            // center cylinder and gear
            if (!disable_minutes_disc) {
				translate([0,0,-3]) gear(number_of_teeth=50,
						circular_pitch=220,
						hub_diameter=0,
						rim_width=0,
						rim_thickness=5,hub_thickness=5);
            }
        }
        
        // cut out center cylinder where hours disc fits in
        if (!disable_minutes_disc) {
            translate([0,0,-20]) cylinder(30, 30 - 1.5, 25, $fn=300);
        }
    }
}

module fillet(r) {
    translate([r / 2, r / 2, 0]) difference() {
		square([r + 0.01, r + 0.01], center = true);
		translate([r/2, r/2]) circle(r = r, center = true);
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

module base_plate(height = 16, rounded = 12) {
	square_size = (clock_r * 1.8);
    move = (square_size/2) - (rounded/2);
	difference() {
		linear_extrude(height+1) translate([-move,-move]) minkowski() {			
			square(square_size-rounded);
			circle(rounded/2);
		}
		translate([-move+1,-move+1,1.5]) linear_extrude(height)minkowski() {			
			square(square_size-(rounded+2));
			circle(rounded/2);
		}
	}
	cylinder(29, 3.78, 3.78, $fn = 40);
	
	difference() {
		cylinder(height + 2.5, 28, 28);
		union() {
			translate([0, 0, -0.5]) cylinder(height + 4, 25, 25);
			for (j = [2:3:16]) {
				for (i = [0:45:179]) {
					rotate(i + j * 6) translate([0, -40, j]) cube([3, 80, 3]);
				}
			}
		}
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

module cool_cover_disc() {
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
}

module base_disc(height = 19) {
	// disc support with wiring/breathing holes
	difference() {
		cylinder(height, 28, 28);
		union() {
			translate([0, 0, -0.5]) cylinder(height + 1, 25, 25);
			for (j = [2:3:16]) {
				for (i = [0:45:179]) {
					rotate(i + j * 6) translate([0, -40, j]) cube([3, 80, 3]);
				}
			}
		}
	}
	
	// core spindle
	cylinder(28.25, 3.78, 3.78, $fn = 40);
	
	// switch platform
	translate([-clock_r + 1.25,0,0]) cube([10,10,12]);
	
	// main bottom
	difference() {
		cylinder(28, clock_r + 3, clock_r + 3, $fn = 200);
		translate([0,0,1]) cylinder(29, clock_r + 1.5, clock_r + 1.5, $fn = 200);
	}
}

// main clock parts
if (!disable_cover) {
    %translate([0, 0, 3.5]) cool_cover_disc();
}

difference() {
    union() {
        display_hour = 12;
        display_min  = 25;
        rotate((360 / 12) * (display_hour - 2)) {
            hours_disc();
        }
        rotate((360 / 60) * (display_min - 10)) {
            translate([0, 0, -3.5]) minutes_disc();
        }
    }
    if (!disable_hours_disc || !disable_hours_text ||
        !disable_minutes_disc || !disable_minutes_text) {
		union() {
			translate([0,0,-50]) cylinder(100, 4, 4, $fn = 100); // main axis cutout
			translate([0,0,-21]) cylinder(15, clock_r+4, clock_r+4); // normalize bottom
		}
    }
}

if (!disable_base) {
	%translate([0,0,-25.5]) base_disc();
}
