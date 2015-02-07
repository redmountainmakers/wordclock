clock_r = 104;
disc_thickness = 5;

hours=["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"];
mins=["o-clock", "o-five", "ten", "fifteen", "twenty", "twenty-five", "thirty", "thirty-five", "forty", "forty-five", "fifty", "fifty-five"];

module clock_words(from_center=46.0, letter_depth=disc_thickness, center_offset=0, font_size=8.5, words) {
	for (i=[0:(len(words)-1)]) {
		angle=(i+1)*360/len(mins);
		rotate(90-angle) translate([from_center,center_offset])
		linear_extrude(height=letter_depth) {
			text(words[i], size=font_size);
		}
	}
}

module hours_disc() {
	difference() {
		union() {	
			difference() {
				cylinder(disc_thickness,r=clock_r); // clock disc				
				
				// see-through slots
				for (i=[0:(len(mins)-1)]) {
					width = clock_r - 55;
					angle=(i+1)*360/len(mins);
					rotate(90-angle) translate([44,-10.5,-0.5]) {
						linear_extrude(height=disc_thickness+1) {
							hull() {
								translate([0,5]) circle(5);
								translate([width,5]) circle(5);
							}
						}
					}
				}
			}
			// bumps
			for (i=[0:(len(mins)-1)]) {
				angle=(i+1)*360/len(mins);
				rotate(90-angle) translate([clock_r - 5, -10, -15]) cube([4,4,18]);
			}
			color("blue") clock_words(center_offset=2, words=hours);
			translate([0, 0, -18]) cylinder(18, 24, 24);
		}
		translate([0,0,-5]) cylinder(15, 18, 18);	
	}
}

module minutes_disc() {
	difference() {
		union() {
			color("pink") cylinder(disc_thickness,r=clock_r-5);
			// bumps
			for (i=[0:(len(mins)-1)]){
				angle=(i+1)*360/len(mins);
				rotate(90-angle) translate([clock_r - 8 - 5, -10, -7]) cube([4,4,8]);
			}
			color("red") clock_words(from_center=48, center_offset=-8, font_size=7, words=mins);
			translate([0,0,-10]) cylinder(10, 30, 30);
		}
		translate([0,0,-20]) cylinder(30, 25, 25);
	}
}

module cover_plate() {
	square_size = clock_r * 1.9;
	move = (square_size/2);
	%difference() {
		translate([-move,-move]) linear_extrude(height=5) square(square_size);
		union() {
			translate([-move +6.4,-move + 6.5,5.5]) scale([0.82,0.82,0.82]) {
				for (j=[0:15]) {
					for(i=[0:15]) {
						translate([j*15,i*15,0]) rotate([180]) scale([0.25,0.25,0.25]) {
							sphere(r = 20);
							translate([0, 0, 20 * sin(30)]) cylinder(h = 30, r1 = 20 * cos(30), r2 = 0);
						}
					}
				}
				
			}
			translate([40,-9,-2]) minkowski() { 
				cube([60,18,6]);
				cylinder(r=2,h=6);
			}
		}
	}
}

// main clock parts
translate([0,0,8]) cover_plate();
hours_disc();
translate([0,0,-8]) minutes_disc();