// Example combining MCAD/fonts.scad with search() function.

use <MCAD/fonts.scad>

thisFont=8bit_polyfont();
x_shift=thisFont[0][0];
y_shift=thisFont[0][1];

hours=["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"];
mins=["o-clock", "o-five", "ten", "fifteen", "twenty", "twenty-five", "thirty", "thirty-five", "forty", "forty-five", "fifty", "fifty-five"];

module clock_words(radius=20.0, letter_depth=2.0, center_offset=0, words) {
	for (i=[0:(len(words)-1)]) assign(angle=(i+1)*360/len(words), letters=search(words[i],thisFont[2],1,1) ) {
		rotate(90-angle) translate([radius,center_offset])		
		// extrude each letter
		for(j=[0:(len(letters)-1)] ) translate([j*x_shift,-y_shift/2]) {
			linear_extrude(height=letter_depth) polygon(points=thisFont[2][letters[j]][6][0],paths=thisFont[2][letters[j]][6][1]);
		}
	}
}

// hours disc
difference() {
	union() {	
		// see-through slots
		difference() {
			cylinder(5,r=137);
			for (i=[0:(len(mins)-1)]) assign(angle=(i+1)*360/len(mins)) {
				rotate(90-angle) translate([40,-11])
				translate([0,0,-2.5]) cube([90,10,y_shift]);
			}
		}
		// bumps
		for (i=[0:(len(mins)-1)]) assign(angle=(i+1)*360/len(mins)) {
			rotate(90-angle) translate([127,-11])
			translate([5,3,-13]) cube([4,4,18]);
		}
		color("blue") clock_words(radius=40,letter_depth=6, center_offset=4, words=hours);
		translate([0, 0, -18]) cylinder(18, 24, 24);
	}
	translate([0,0,-5]) cylinder(15, 18, 18);	
}


// minutes disc
translate([0,0,-8]) difference() {
	union() {
		cylinder(5,r=132);
		// bumps
		for (i=[0:(len(mins)-1)]) assign(angle=(i+1)*360/len(mins)) {
			rotate(90-angle) translate([122,-11])
			translate([5,3,-5]) cube([4,4,10]);
		}
		color("red") clock_words(radius=40,letter_depth=6, center_offset=-5, words=mins, disc_r=132);
		translate([0,0,-10]) cylinder(10, 30, 30);
	}
	translate([0,0,-20]) cylinder(30, 25, 25);
}