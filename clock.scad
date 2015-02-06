// Example combining MCAD/fonts.scad with search() function.

use <MCAD/fonts.scad>

thisFont=8bit_polyfont();
x_shift=thisFont[0][0];
y_shift=thisFont[0][1];

hours=["one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve"];
mins=["o-clock", "o-five", "ten", "fifteen", "twenty", "twenty-five", "thirty", "thirty-five", "forty", "forty-five", "fifty", "fifty-five"];

module clock_words(radius=20.0, letter_depth=2.0, center_offset=0, words, includeSlots=false) {
	difference() {
		color("yellow") cylinder(5,r=136);
		if (includeSlots) {
			for (i=[0:(len(words)-1)]) assign(handAngle=(i+1)*360/len(words)) {
				rotate(90-handAngle) translate([radius,-center_offset-10])
				translate([0,0,-2.5]) cube([90,10,y_shift]);
			}
		}
	}
		color("red")
		for (i=[0:(len(words)-1)]) assign(handAngle=(i+1)*360/len(words), letters=search(words[i],thisFont[2],1,1) ) {
			rotate(90-handAngle) translate([radius,center_offset])
		
				// extrude letters
				for(j=[0:(len(letters)-1)] ) translate([j*x_shift,-y_shift/2]) {
					linear_extrude(height=letter_depth) polygon(points=thisFont[2][letters[j]][6][0],paths=thisFont[2][letters[j]][6][1]);
		}
	}
}


//color("red") clock_hour_words(word_offset=24,word_height=3.0);

	
union() {
	clock_words(radius=40,letter_depth=6, center_offset=4, words=hours, includeSlots=true);
	translate([0, 0, -10]) cylinder(10, 24, 24);
}



translate([0,0,-8]) difference() {
	union() {
		clock_words(radius=40,letter_depth=6, center_offset=-8, words=mins);
		translate([0,0,-10]) cylinder(10, 30, 30);
	}
	translate([0,0,-20]) cylinder(30, 25, 25);
}