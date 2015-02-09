clock_r = 104;
disc_thickness = 2.25;

hours=["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"];
mins=["o-clock", "o-five", "ten", "fifteen", "twenty", "twenty-five", "thirty", "thirty-five", "forty", "forty-five", "fifty", "fifty-five"];

module clock_words(from_edge=6.0, letter_depth=disc_thickness, center_offset=0, font_size=12, words) {
	for (i=[0:(len(words)-1)]) {
		angle=(i+1)*360/len(mins);
		rotate(90-angle) translate([-clock_r+from_edge,center_offset])
		linear_extrude(height=letter_depth) {
			text(words[i], size=font_size);
		}
	}
}

module hours_disc() {
	difference() {
		union() {	
			difference() {
				$fn=300; cylinder(disc_thickness,r=clock_r); // clock disc				
				
				// see-through slots
				for (i=[0:(len(mins)-1)]) {
					width = clock_r - 55;
					angle=(i+1)*360/len(mins);
					rotate(90-angle) translate([52,2,-0.5]) {
						linear_extrude(height=disc_thickness+1) {
							hull() {
								translate([0,5]) circle(5.4);
								translate([width-9,5]) circle(5.4);
							}
						}
					}
				}
			}
			// bumps
			for (i=[0:(len(mins)-1)]) {
				angle=(i+1)*360/len(mins);
				rotate(90-angle) translate([clock_r - 5, -10, -16]) cube([4,4,18]);
			}
			// polarity bump
			rotate(4) translate([clock_r - 5, -10, -16]) cube([4,4,18]);
			color("blue") clock_words(from_edge=8, center_offset=2.1, words=hours);
			translate([0, 0, -12]) cylinder(12, 26, 26);
		}
		//translate([0,0,-5]) cylinder(12, 28, 18);	
	}
}

module minutes_disc() {
	difference() {
		union() {
			$fn=300; color("pink") cylinder(disc_thickness,r=clock_r-6);
			// bumps
			for (i=[0:(len(mins)-1)]){
				angle=(i+1)*360/len(mins);
				rotate(90-angle) translate([clock_r - 11, -10, -8]) cube([4,4,8]);
			}
			// polarity bump
			rotate(4) translate([clock_r - 8 - 5, -10, -8]) cube([4,4,8]);
			color("red") clock_words(from_edge=10, center_offset=-10, font_size=7, words=mins);
			translate([0,0,-10]) cylinder(10, 30, 30);
		}
		translate([0,0,-20]) cylinder(30, 30 - 1.5, 25);
	}
}

module cover_plate() {
	square_size = clock_r * 1.9;
	move = (square_size/2);
	//$fs = 8;
	%difference() {
		translate([-move,-move]) linear_extrude(height=5) square(square_size);
		
		// tear drop texture
		union() {
			// translate([-move +6.4,-move + 6.5,5.5]) scale([0.82,0.82,0.82]) {
				// for (j=[0:15]) {
					// for(i=[0:15]) {
						// translate([j*15,i*15,0]) rotate([180]) scale([0.25,0.25,0.25]) {
							// sphere(r = 20);
							// translate([0, 0, 20 * sin(30)]) cylinder(h = 30, r1 = 20 * cos(30), r2 = 0);
						// }
					// }
				// }				
			// }
			
			// main time cutout
			// translate([44,-9,-2]) minkowski() { 
				// cube([58,23,6]);
				// cylinder(r=2,h=6);
			// }
			translate([-30,1,-2]) rotate(136) linear_extrude(height=10) polygon([[0,0],[22,80],[80,22]]);
		}
	}
	//$fs = 10;
	//translate([48,-12,-2]) minkowski() 
	{ 
		//cube([58,24.5,6]);
		
		//cylinder(r=4,h=6);
	}
	
}

// main clock parts
	*translate([0,0,8]) cover_plate();
difference() 
{
	union() {
	/*rotate((360 / 12)*9)*/ hours_disc();
	translate([0,0,-3.5]) minutes_disc();
	}
	translate([0,0,-20]) cylinder(15, clock_r+4, clock_r+4);
}