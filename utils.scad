
module clock_words(
    from_edge=4,
    letter_depth=3.25, //disc_thickness+1,
    center_offset=0,
    font_size=11.5,
    words
) {
    for (i = [0 : len(words) - 1]) {
        angle = (i + 1) * 360 / len(words);
        rotate(90 - angle) {
            translate([-clock_r + from_edge, center_offset,-0.5]) {
                linear_extrude(height=letter_depth) {
                    text(words[i], size=font_size, font="Gunplay");
                }
            }
        }
    }
}

module fillet(r) {
    translate([r / 2, r / 2, 0]) difference() {
        square([r + 0.01, r + 0.01], center = true);
        translate([r/2, r/2]) circle(r = r, center = true);
    }
}

module rounded_rect(w=51, l=21, h=2.25, r=6) {
	translate([r, r, 0]) linear_extrude(height = h) minkowski() {
		square([w-r*2, l-r*2]);
		circle(r);
	}
}

module ring(r1=104, r2=101, h=2.25) {
    difference() {
        cylinder(h, r1, r1, $fn = 200);
        translate([0,0,-0.5]) cylinder(h + 1, r2, r2, $fn = 200);
    }
}

module disc_with_pattern(r=104, h=2.25) {
	difference() {
		cylinder(h, r1=r, r2=r, $fn = 200);
		translate([-r-1,-r-4,2]) scale(3) linear_extrude(height = h, center = true, convexity = 10) {
			// TODO: figure out pattern from radius
			for (k = [0:5:r / 1.4]) {
				for (i = [0:3:r / 1.4]) {
				   translate([k, i]) import (file = "egypt pattern.dxf");
				}
				for (j = [0:3:r / 1.4]) {
					   translate([k + 2.5, j+1.5]) import (file = "egypt pattern.dxf");
				}
			}
		}
	}
}

module disc_with_slots(r=104, h=2.25, slots=12, slot_width=100, slot_r=5, offset=[50,0,-0.5]){
    difference() {
        cylinder(h, r, r, $fn=300);

        // see-through slots
        for (i = [0 : slots - 1]) {
            angle = (i + 1) * 360 / slots;
            rotate(90 - angle) {
                translate(offset) {
                    linear_extrude(height=h + 1) {
                        hull() {
                            translate([0, slot_r]) circle(slot_r);
                            translate([slot_width - (slot_r*2), slot_r]) circle(slot_r);
                        }
                    }
                }
            }
        }
    }
}

module chamfer(apply = false, outline_z = 2.45, outline_r=0.6) {
    children();
    if (apply) {
        // subtract some of the hours text from the first layer
        // text is offset by -0.5 and first layer is 0.3mm -> want to offset by:
        outline_z = disc_thickness + 0.2;
        // outline distance away from main text
        outline_r = 0.8;
        for (theta = [0 : 30 : 359]) {
            translate([outline_r * cos(theta), outline_r * sin(theta), outline_z]) {
                children();
            }
        }
    }
}

module rotate_360(count = 12) {
	for (i = [0 : count - 1]) {
		angle = (i + 1) * 360 / count;
		rotate(90 - angle) {
			children();
		}
	}
}

module straight_nub(w = 2, h = 4, l = 10) {
	difference() {
		cube([w,l*2,h]);
		 rotate([45,0,0])cube([w+1,l*2,h]);
	}
}

module circular_nub(r = 100, w = 2, h = 6.75) {
	intersection() {
		ring(r,r-w,h);
		rotate([0,40,0]) translate([-h, r - (h*2), -h-4.5]) cube([40, w*8, w*8]);
	}
}


//rounded_rect(50, 100, 4, 6);
//cube([50, 100, 4]);