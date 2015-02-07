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
				color("aqua") cylinder(disc_thickness,r=clock_r); // clock disc				
				
				// see-through slots (circle-cube-circle)
				for (i=[0:(len(mins)-1)]) {
					width = clock_r - 55;
					angle=(i+1)*360/len(mins);
					rotate(90-angle) translate([44,-10.5,-0.5]) {
						linear_extrude(height=disc_thickness+1) {
							translate([0,5]) circle(5);
							translate([width,5]) circle(5);
						}
						cube([width,10,disc_thickness+1]);
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

hours_disc();

// move this disc below
translate([0,0,-8]) minutes_disc();