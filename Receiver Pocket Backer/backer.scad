/************** BEST VIEWED IN A CODE EDITOR 80 COLUMNS WIDE *******************
*
* Packout Pocket Backer
* Benjamen Johnson <workshop.electronsmith.com>
* 20220702
* openSCAD Version: 2021.01
*******************************************************************************/
/*[Hidden]*/
COUNTERBORE=0;COUNTERSINK=1;INSERTNUT=2;
$fa = 2.5;
$fs = 0.02;
$dl = 0.02;

/*[Screw Parameters]*/
/*******************************************************************************
*
*
*
*
*
*
*
*
*
*
*
*
*******************************************************************************/
total_height = 79;
width1 = 72;

shape = [[

/*******************************************************************************
*
*******************************************************************************/


/*[Screw Parameters]*/
/*******************************************************************************
*
*      |----------|<-- counter_diameter
* ----  ---------- ---
*   |   \        /  |
*   |    \      /   | <--counter_depth
* total_  |    |   ---       
* depth   |    |
*   |     |    |
*   |     |    |
* -----    ----
*         |----|<-- hole_dia
*
*******************************************************************************/
// What type of hole to make
hole_type = 0;//[0:Counterbore, 1:Countersink, 2:Insert Nut]

// Diameter of the holes
hole_dia = 7;

// What angle countersink?
countersink_angle = 82; // [60,82,90,100,110,120]

// Depth of countersink or counterbore
counter_depth = 10;

// Counter bore diameter
counter_dia = 40;

// Nut depth
nut_depth = 4;

// What is the wrench size of the hex nut to be pressed
nut_size = 8.62;

// Calculate the point to point diameter of the pressed nut
pt_to_pt_hex_nut_dia = 2*(nut_size/2)/cos(30);

/*******************************************************************************
* Module for drilling counterbored or countersuck screw holes
*******************************************************************************/
module screw_hole(){
// Stick above the plane to get a good cut in uneven surfaces    
hole_depth = 15;
    
// Calculate the diameter of the countersink hole
countersink_dia = 2*tan(countersink_angle/2)*counter_depth+hole_dia;

    union(){
        translate([0,0,-hole_depth/2])
        cylinder(d=hole_dia,h=hole_depth,center=true);
        
        if(hole_type == COUNTERBORE)
            translate([0,0,-counter_depth/2])
            cylinder(d=counter_dia,h=counter_depth,center=true);
        
        else if(hole_type == COUNTERSINK)
            translate([0,0,-counter_depth/2])
            cylinder(d2=countersink_dia,d1=hole_dia,h=counter_depth,center=true);
        
        if(hole_type == INSERTNUT)
            translate([0,0,-nut_depth/2])
            cylinder(d=pt_to_pt_hex_nut_dia,h=nut_depth,center=true,$fn=6);

    }// end union
}