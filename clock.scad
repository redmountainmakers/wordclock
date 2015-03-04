include <gears.scad>
include <utils.scad>

disable_cover_plate		= true;
disable_hours_disc		= true;
disable_minutes_disc	= true;
disable_base			= false;

enable_text_chamfer = false; // only for 3d-printing

clock_r = 97;
clearance = 0.5;
axis_r = 2.5;
mid_axis_r = 27;
disc_h = 2.25;
wall_thickness = 2;
gear_h = 4;
snapfit_h = 4;
snapfit_tolerance = 0.18;
font_size = clock_r * .105; // scale font based on radius

cd_rom_motor_r = 12;
cd_rom_motor_h = 16;
worm_gear_motor_h = 10;

disc_support_h = disc_h + worm_gear_motor_h + clearance;

clock_h = disc_h + clearance + // cover
		  disc_h + clearance + // hours disc
		  disc_h + gear_h + // mins disc + cylinder gear
		  disc_support_h; // base
		  ;
		  
echo("clock_h", clock_h);


module hours_disc() {
	r = clock_r - (wall_thickness + clearance);
	bump_h = disc_h + clearance + gear_h;
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
        color("lightblue") union() {
            // hours disc
            disc_with_slots(r=r, slot_width=r*.5, offset=[r*.5,1,-0.5]);

            // small spacer ring
            translate([0,0,-.5]) ring(r1 = 34, r2 = 34 - 1.5, h = clearance);
                                
            rotate_360(12) {
                mirror([0,0,1]) circular_nub(r,h=bump_h);
            }

            // home bump
            rotate(21) mirror([0,0,1]) circular_nub(r,h=bump_h);

            // axis that minutes rotates around
            mid_r = mid_axis_r - clearance/2;
            translate([0, 0, -bump_h]) cylinder(bump_h, mid_r, mid_r, $fn = 200);
        }
        
        // hours text
        chamfer(apply = enable_text_chamfer, outline_z=disc_h + 0.2) {
           color("dodgerblue") clock_words(from_edge=7.5, font_size=font_size, words=HOURS);
        }
		
		// negative gear
		translate([0,0,-(bump_h + .5)]) gear(number_of_teeth=38, circular_pitch=220,
			hub_diameter=0, rim_width=0,
			hub_thickness=bump_h + 1,rim_thickness=bump_h + 1,gear_thickness=bump_h + 1);

		// remove some material
        rotate_360(12) {
            translate([r*.85,-21,-0.5]) cylinder(disc_h + 1, 6.2, 6.2);       
            rotate(-2.5) translate([r*.32,14,-1]) cylinder(disc_h + 2, 5, 5);
        }
		
        // remove some more material
        rotate_360(3){
            translate([r*.04,14,-1]) cylinder(disc_h + 2, 6.5, 6.5);
        }
		
		// main axis cutout
		axis_cutout_r = axis_r + (clearance/2);
		translate([0,0,-50]) cylinder(100, axis_cutout_r, axis_cutout_r, $fn = 100); // main axis cutout
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
			color("pink") union() {
				// minutes disc (make it smaller)
				disc_with_slots(r = r - 2, slot_width=r, slot_r=font_size*.6, offset=[r*.5,-12,-0.5]);
				ring(r1=r, r2=r - 2, h = disc_h); // support ring around edge
				
				rotate_360(12) {
					rotate(13) translate([0, r -20, 0]) mirror([0,0,1]) straight_nub();
				}

				// home bump
				rotate(18) translate([0, r -20, 0]) mirror([0,0,1]) straight_nub();

				// center cylinder and gear
				translate([0,0,-gear_h]) gear(number_of_teeth=52,
						circular_pitch=220,
						hub_diameter=0,
						rim_width=0,
						rim_thickness=gear_h,
						hub_thickness=gear_h);
			}
				
            // minutes text		
            chamfer(apply = enable_text_chamfer, outline_z=disc_h + 0.2) {
                color("red") clock_words(from_edge=8.5, center_offset=-8.8, font_size=6.8, words=mins);
            }
        }

        // cut out center cylinder where hours disc fits in		
		cut_r = mid_axis_r + clearance/2;
		translate([0,0,-20]) cylinder(30, r1=cut_r, r2=cut_r, $fn=300);
    }
}

module cool_cover_disc(r = clock_r) {
	wall_h = (clock_h - disc_support_h + clearance);
	rect_w = r*.6;
	rect_h = r*.28;
    difference() {	
		union() {
			translate([0,0,-(wall_h-disc_h)-4]) ring(r1=r, r2=r - wall_thickness, h=wall_h+4); //side walls			
			ring(r1=r, r2=r-3, h=disc_h); // outer ring
			disc_with_pattern(r-.5);
			translate([-(r*.38 + rect_w), -rect_h/2]) rounded_rect(rect_w, rect_h, disc_h, 6); // solid around text cut out
			cylinder(disc_h, axis_r * 1.8, axis_r * 1.8, $fn = 40); // spot for cover to glue on main axis
		}
		translate([-(r*.38 + (rect_w - 2)), -(rect_h-4)/2, -0.5]) rounded_rect(rect_w - 4, rect_h - 4, disc_h + 1, 4); // text cut out
		
		axis_notch_r = axis_r - (clearance/2);
		axis_notch_h = disc_h/2;
		translate([0,0,-axis_notch_h]) cylinder(axis_notch_h + 0.1, axis_notch_r, axis_notch_r, $fn = 40); // axis notch
		
		snapfit = r - (wall_thickness/2);
		translate([0,0,-(wall_h+disc_h-clearance)-.01]) cylinder(snapfit_h + clearance, snapfit, snapfit, $fn = 200);
    }
}

module cd_rom_motor_base_disc(r = clock_r, height = 16, disc_support_r = mid_axis_r, disc_support_h = 19) {
	axis_h = 29;
	difference() {
		union() {
			// disc support with motor holes
            cylinder(disc_support_h-1, axis_r*6, axis_r, $fn = 60); // core spindle cone to strengthen for motor cut-out
            cylinder(axis_h, axis_r, axis_r, $fn = 60); // core spindle
            ring(r1=disc_support_r+wall_thickness, r2=disc_support_r-wall_thickness, h = disc_support_h);

			// switch platform
			rotate(-12) translate([clock_r - (wall_thickness + 10),0,0]) cube([10,10,12]);

			// main bottom
			snapfit = r - (wall_thickness/2) - 0.18; // snap tolerance
			difference() {
				cylinder(height - disc_h, r, r, $fn = 200);
				translate([0,0,disc_h]) cylinder(height - disc_h, r - wall_thickness * 1.5, r - wall_thickness*1.5, $fn = 200);
				translate([0,0,height-disc_h-4]) ring(r1=snapfit + 10, r2=snapfit, h=4.5); // notch for snap fit
                
                // clear out a bunch of material from bottom
                translate([0,0,-0.5]) ring(r1=r - 12, r2=r - r/2, h = disc_h + 1);
			}
            
            // but leave a support structure on the bottom
            rotate_360(12){
                translate([disc_support_r-wall_thickness,-disc_h*2, 0]) cube([r - disc_support_r, disc_h*4, disc_h]);
            }
		}
        // clear out spots for motors
        motor_r_cutout = motor_r + clearance;
        color("whitesmoke") translate([-12.5,0, 0.6]) cylinder(motor_h + clearance, motor_r_cutout, motor_r_cutout); // cut-out for motor 1 on spindle
        translate([-22,0, 0.6]) cylinder(motor_h + 10, motor_r_cutout, motor_r_cutout); // motor 1 move over so it can fit
        translate([34, 0, 0.6]) cylinder(motor_h + 10, motor_r_cutout, motor_r_cutout); // motor 2
    }    

    // overhang support (to be removed after print)
    color("darkred") translate([-2.5,0,0.5]) cylinder(motor_h+.75, 1.25, 1.25);
}

module disc_support(r = mid_axis_r, h = 9.5, support_thickness = 2.5) {	
	translate([0,0,disc_h]) intersection() {
		union() {
			ring(r1=r+support_thickness*.5, r2=r-support_thickness*.5, h = h - disc_h);
			translate([22,-support_thickness*.5,0]) cube([10,support_thickness,h - disc_h]);
		}
		translate([r,0,0]) cylinder(h-disc_h,4.4,2.2,$fn=40);
	}
}

module base_disc(r = clock_r) {
	wall_h = disc_support_h - clearance;
	axis_h = clock_h - (disc_h/2);
	axis_support_h = axis_h - disc_h/2 - clearance*2 - disc_h;
	difference() {
		union() {
            #cylinder(axis_h, axis_r, axis_r, $fn = 60); // core spindle
            cylinder(axis_support_h, axis_r*4, axis_r, $fn=80); // spindle support
			
			// switch platform
			//rotate(-12) translate([clock_r - (wall_thickness + 10),0,0]) cube([10,10,4]);

			rotate_360(12) {
				disc_support(mid_axis_r, disc_support_h);
			}
			
			// main bottom
			difference() {
				cylinder(wall_h, r, r, $fn = 200);
				
				// allow the wall thickness to be thicker to support snap-fit notch
				inner_r = r - (wall_thickness * 1.5);
				translate([0,0,disc_h]) cylinder(wall_h, inner_r, inner_r, $fn = 200);
				
				// notch for snap fit
				snapfit = r - (wall_thickness/2) - snapfit_tolerance;
				translate([0,0,wall_h-snapfit_h]) ring(r1=snapfit + 10, r2=snapfit, h=snapfit_h+0.1); 
                
                // clear out a bunch of material from bottom
                translate([0,0,-0.5]) ring(r1=r*.3, r2=0, h = disc_h + 1);
                translate([0,0,-0.5]) ring(r1=r*.6, r2=r*.4, h = disc_h + 1);
                translate([0,0,-0.5]) ring(r1=r*.9, r2=r*.7, h = disc_h + 1);
			}
            
            
            // but leave a support structure on the bottom
            difference() {
                rotate_360(12){
                    translate([0,-disc_h*2, 0]) cube([r - wall_thickness, disc_h*4, disc_h]);
                }
                union() {
                    rotate_360(12) {
                        translate([r*.5,0,-0.5]) cylinder(disc_h+1, 2, 2, $fn=40);
                        translate([r*.8,0,-0.5]) cylinder(disc_h+1, 2, 2, $fn=40);
                    }
                    
                    rotate_360(3) {
                        translate([8,0,-0.5]) cylinder(disc_h+1, 5.5, 5.5, $fn=40);
                    }
                }
            }
		}
    }
}
// main clock parts

// temporary intersection to reduce print size for prototyping
intersection() {

union() {

mins_z = disc_support_h + gear_h;
hours_z = mins_z + disc_h + clearance;
cover_z = hours_z + clearance + disc_h;

if (!disable_cover_plate) {
    translate([0, 0, cover_z]) cool_cover_disc();
}

if (!disable_hours_disc || !disable_minutes_disc) {
	display_hour = 11;
	display_min  = 25;
	if (!disable_hours_disc) {
		rotate((360 / 12) * (display_hour - 2)) translate([0, 0, hours_z]) hours_disc();
	}
	if (!disable_minutes_disc) {
		rotate((360 / 60) * (display_min - 10)) translate([0, 0, mins_z]) minutes_disc();
	}
}

if (!disable_base) {
	base_disc();
}

}

	translate([0,0,-200]) cylinder(400, 45, 45, $fn=100);}
