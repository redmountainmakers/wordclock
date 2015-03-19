include <gears.scad>
include <utils.scad>

disable_cover_plate		= true;
disable_hours_disc		= true;
disable_minutes_disc	= true; 
disable_base			= false;

enable_text_chamfer = false; // only for 3d-printing

clock_r = 97;
clearance = 0.5;
axis_r = 21; // no longer using center axis
mid_axis_r = 27;
magnet_r = 1.5;
magnet_h = 1.5;
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
	inner_h = disc_h + clearance + gear_h;
	HOURS = [
		"TWELVE",
		"0NE",
		"TW0",
		"THREE",
		"F0UR",
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
            translate([0,0,-.5]) ring(r1 = r*.425, r2 = r*.425 - 1.5, h = clearance);
            // small spacer ring
            translate([0,0,-.5]) ring(r1 = r - 0.1, r2 = r - 1.5, h = disc_h+clearance);
                                
            // axis that minutes rotates around
            mid_r = mid_axis_r - clearance/2;
            translate([0, 0, -inner_h]) cylinder(inner_h, mid_r, mid_r, $fn = 200);
        }
        
        // hours text
        chamfer(apply = enable_text_chamfer, outline_z=disc_h + 0.2) {
           color("dodgerblue") clock_words(from_edge=7.5, letter_depth=disc_h, font_size=font_size, words=HOURS);
        }
		
		rotate_360(12) {
			translate([r - magnet_r * 2,magnet_r,0]) cylinder(magnet_h, magnet_r, magnet_r, $fn=30);
		}
		// home
		rotate(12) translate([r - magnet_r * 2,magnet_r,0]) cylinder(magnet_h, magnet_r, magnet_r, $fn=30);
		
		// negative gear
		translate([0,0,-(inner_h + .5)]) gear(number_of_teeth=38, circular_pitch=220,
			hub_diameter=0, rim_width=0,
			hub_thickness=inner_h + 1,rim_thickness=inner_h + 1,gear_thickness=inner_h + 1);

		// // remove some material
        // rotate_360(12) {
            // translate([r*.85,-21,-disc_h]) cylinder(disc_h + 2, 6.2, 6.2);       
            // rotate(-2.5) translate([r*.32,14,-disc_h]) cylinder(disc_h + 2, 5, 5);
        // }
		
        // // remove some more material
        // rotate_360(3){
            // translate([r*.04,14,-disc_h]) cylinder(disc_h + 2, 6.5, 6.5);
        // }
		
		// main axis cutout
		axis_cutout_r = axis_r + (clearance/2);
		translate([0,0,-50]) cylinder(100, axis_cutout_r, axis_cutout_r, $fn = 100); // main axis cutout
    }
}

module minutes_disc() {
	r = clock_r - (wall_thickness + clearance);
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
				
		
				// center cylinder and gear
				translate([0,0,-gear_h]) gear(number_of_teeth=56,
						circular_pitch=220,
						hub_diameter=0,
						rim_width=0,
						rim_thickness=gear_h,
						hub_thickness=gear_h,
						gear_thickness=gear_h);
			}
				
            // minutes text		
            chamfer(apply = enable_text_chamfer, outline_z=disc_h + 0.2) {
                color("red") clock_words(from_edge=8.5, center_offset=-8.8, font_size=6.8, words=mins);
            }
			rotate_360(12) {
				translate([r*.9,13,0]) cylinder(magnet_h, magnet_r, magnet_r, $fn=30);
			}
			// home
			rotate(12) translate([r*.9,13,0]) cylinder(magnet_h, magnet_r, magnet_r, $fn=30);
		
        }

        // cut out center cylinder where hours disc fits in		
		cut_r = mid_axis_r + wall_thickness + clearance/2;
		translate([0,0,-20]) cylinder(30, r1=cut_r, r2=cut_r, $fn=300);
    }
}

module cool_cover_disc(r = clock_r) {
	wall_h = clock_h / 2;//(clock_h - disc_support_h + clearance);
	rect_w = r*.6;
	rect_h = r*.28;
    difference() {	
		union() {
			translate([0,0,-(wall_h-disc_h)]) ring(r1=r, r2=r - wall_thickness, h=wall_h); //side walls			
			ring(r1=r, r2=r-4, h=disc_h); // outer ring
			//disc_with_pattern(r-.5);
			cylinder(disc_h, r-.5, r-.5);
			translate([-(r*.38 + rect_w), -rect_h/2]) rounded_rect(rect_w, rect_h, disc_h, 6); // solid around text cut out
		}
		translate([-(r*.38 + (rect_w - 2)), -(rect_h-4)/2, -0.5]) rounded_rect(rect_w - 4, rect_h - 4, disc_h + 1, 4); // text cut out
		
		snapfit = r - (wall_thickness/2);
		translate([0,0,-wall_h+disc_h+0.01]) cylinder(snapfit_h + clearance, snapfit, snapfit, $fn = 200);
		
		// torus to make a small seam
		translate([0,0,-wall_h+disc_h]) rotate_extrude(convexity = 10, $fn = 400) translate([r + 3.9, 0, 0]) circle(r = 4, $fn = 200);
    }
}

module base_disc(r = clock_r) {
	wall_h = clock_h / 2;// disc_support_h - clearance;
	axis_h = clock_h - (disc_h/2);
	axis_support_h = axis_h - disc_h/2 - clearance*2 - disc_h;
	difference() {
		union() {			
			difference() {			
				min_r = mid_axis_r + wall_thickness;
				
				// support that both discs sit on
				ring(r1=min_r+2, r2=mid_axis_r-2, h=axis_support_h - 2);
				
				// cut where hours disc sits
				translate([0,0,axis_support_h-disc_h-gear_h]) cylinder(axis_support_h-disc_h-gear_h+0.1, mid_axis_r, mid_axis_r, $fn = 200);
				
				// cut where mins disc sits
				translate([0,0,axis_support_h-disc_h-gear_h]) ring(r1=min_r+5, r2 = min_r, h=axis_support_h-disc_h-gear_h+0.1);
			
				// add wiring holes
				rotate_360(6) {
					translate([20,-1.5, 3]) cube([20,2.5,2.5]);
				}
			}
			
			// main bottom
			difference() {
				union() {
					difference() {
						cylinder(wall_h + snapfit_h, r, r, $fn = 400);
						
						// allow the wall thickness to be thicker to support snap-fit notch
						inner_r = r - (wall_thickness * 1.25);
						translate([0,0,disc_h]) cylinder(wall_h + snapfit_h, inner_r, inner_r, $fn = 200);
						
						// notch for snap fit
						snapfit = r - (wall_thickness/2) - snapfit_tolerance;
						translate([0,0,wall_h]) ring(r1=snapfit + 10, r2=snapfit, h=snapfit_h+0.1); 
						
						// clear out a bunch of material from bottom
						translate([0,0,-0.5]) ring(r1=r*.85, r2=r*.4, h = disc_h + 1);
						
					 
					}
					
					// but leave a support structure on the bottom\
					spokes = 6;
					rotate_360(spokes){
						translate([0,-disc_h*4, 0]) cube([r - wall_thickness, disc_h*8, disc_h]);
					}
				}
				translate([.09, -1.2, 4]) scale(10) linear_extrude(height = 2, center = true, convexity = 10) import(file = "egypt pattern.dxf");
				//translate([-21, -54, 4]) scale(12) linear_extrude(height = 1, center = true, convexity = 10) import(file = "rmm.dxf");

				// torus to make a small seam
				translate([0,0,wall_h]) rotate_extrude(convexity = 10, $fn = 100) translate([r + 3.9, 0, 0]) circle(r = 4, $fn = 100);				
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
