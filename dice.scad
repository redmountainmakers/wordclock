
module dice(num = 1) {
	//	    	 one			two			 three		  four		    five		six
	dice_layout =[ "0000E0000", "00C000H00", "00C0E0G00", "A0C000G0I", "A0C0E0G0I", "A0CD0FG0I"];
	linear_extrude(height=10) {

		if (search("A", dice_layout[num-1])) translate([-10,-10]) circle(3); 
		if (search("B", dice_layout[num-1])) translate([0,-10]) circle(3);
		if (search("C", dice_layout[num-1])) translate([10,-10]) circle(3);
		
		if (search("D", dice_layout[num-1])) translate([-10,0]) circle(3);	
		if (search("E", dice_layout[num-1])) translate([0,0]) circle(3);		//center		
		if (search("F", dice_layout[num-1])) translate([10,0]) circle(3);
					
		if (search("G", dice_layout[num-1])) translate([-10,10]) circle(3);	
		if (search("H", dice_layout[num-1])) translate([0,10]) circle(3);
		if (search("I", dice_layout[num-1])) translate([10,10]) circle(3);
	}
}


												
						// if (i<6) translate([48, 20, 0]) scale([0.3,0.3]) dice(i+1);
						// dice_1 = [46,20];
						// dice_2 = [44,31];
						// if (i==6) {
							// translate(dice_1) scale([0.3,0.3]) dice(5);
							// translate(dice_2) scale([0.3,0.3]) dice(2);
						// }
						// if (i==7) {
							// translate(dice_1) scale([0.3,0.3]) dice(4);
							// translate(dice_2) scale([0.3,0.3]) dice(4);
						// }
						// if (i==8) {
							// translate(dice_1) scale([0.3,0.3]) dice(6);
							// translate(dice_2) scale([0.3,0.3]) dice(3);
						// }
						// if (i==9) {
							// translate(dice_1) scale([0.3,0.3]) dice(5);
							// translate(dice_2) scale([0.3,0.3]) dice(5);
						// }
						// if (i==10) {
							// translate(dice_1) scale([0.3,0.3]) dice(6);
							// translate(dice_2) scale([0.3,0.3]) dice(5);
						// }
						// if (i==11) {
							// translate(dice_1) scale([0.3,0.3]) dice(6);
							// translate(dice_2) scale([0.3,0.3]) dice(6);
						// }