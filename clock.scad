// Example combining MCAD/fonts.scad with search() function.

use <MCAD/fonts.scad>

clock_r = 100;
disc_thickness = 5;

hours=["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"];
mins=["o-clock", "o-five", "ten", "fifteen", "twenty", "twenty-five", "thirty", "thirty-five", "forty", "forty-five", "fifty", "fifty-five"];

module clock_words(from_center=46.0, letter_depth=disc_thickness, center_offset=0, words) {
	for (i=[0:(len(words)-1)]) {
		angle=(i+1)*360/len(mins);
		rotate(90-angle) translate([from_center,center_offset])
		linear_extrude(height=letter_depth) {
			text(words[i], size=7);
		}
	}
}

// hours disc
difference() {
	union() {	
		// see-through slots
		difference() {
			color("aqua") cylinder(disc_thickness,r=clock_r);
			for (i=[0:(len(mins)-1)]) {
				angle=(i+1)*360/len(mins);
				rotate(90-angle) translate([44,-10.5,-0.5])
				cube([clock_r-50,10,disc_thickness+1]);
			}
		}
		// bumps
		for (i=[0:(len(mins)-1)]) assign(angle=(i+1)*360/len(mins)) {
			rotate(90-angle) translate([clock_r - 5, -10, -15]) cube([4,4,18]);
		}
		color("blue") clock_words(center_offset=2, words=hours);
		translate([0, 0, -18]) cylinder(18, 24, 24);
	}
	translate([0,0,-5]) cylinder(15, 18, 18);	
}


// minutes disc
translate([0,0,-8]) difference() {
	union() {
		color("pink") cylinder(disc_thickness,r=clock_r-5);
		// bumps
		for (i=[0:(len(mins)-1)]){
			angle=(i+1)*360/len(mins);
			rotate(90-angle) translate([clock_r - 8 - 5, -10, -7]) cube([4,4,8]);
		}
		color("red") clock_words(from_center=48, center_offset=-8, words=mins);
		translate([0,0,-10]) cylinder(10, 30, 30);
	}
	translate([0,0,-20]) cylinder(30, 25, 25);
}
