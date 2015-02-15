
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
	linear_extrude(height = h) minkowski() {
		square([w-r, l-r]);
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

module disc_with_slots(r=104, h=2.25, slots=12, slot_width=104 - 55, slot_r=5.4, offset=[52,2,-0.5]){
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