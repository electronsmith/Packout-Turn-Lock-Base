/************** BEST VIEWED IN A CODE EDITOR 80 COLUMNS WIDE *******************
*
* Packout Turn Lock Base
* Benjamen Johnson <workshop.electronsmith.com>
* 20220613
* openSCAD Version: 2021.01
*******************************************************************************/
/*[Hidden]*/
COUNTERBORE=0;COUNTERSINK=1;INSERTNUT=2;
$fa = 2.5;
$fs = 0.02;
$dl = 0.02;

/*[Edit me]*/
/*******************************************************************************
*
*******************************************************************************/
Part = "FULL CUP"; //[BASE ONLY,FULL CUP]

/*[Base Parameters]*/
/*******************************************************************************
*
*******************************************************************************/
// Diameter of the botton of the base
bottom_dia = 68;

// Angle of the side of the packout receiver
draft_angle = 30;

// Total hieght of the base
total_height = 14;

/*[Lock Parameters]*/
/*******************************************************************************
*
*******************************************************************************/
// height of the fisrt tab (most Packout receivers)
first_tab_height = 8;

//height of the second Tab (Packout ammo can receiver)
second_tab_height = 10.3;

second_tab_inner_dia =70.15;

first_tab_outer_dia = 0;

first_tab_angle = 60;
second_tab_angle = 32;
third_tab_angle = 4;

/*
height = 12.75;
a = height*tan(draft_angle);
top_dia = bottom_dia+2*a;
second_tab_inner_dia = bottom_dia +(inner_top_dia-bottom_dia)*(second_tab_height/total_height);
*/
/*[Cup Parameters]*/
/*******************************************************************************
*
*******************************************************************************/
// Diameter of the outside of the cup
outer_cup_dia = 102;

cup_height_adj = 0; //[-50:0.1:50]

//Cup wall thickness
cup_thickness = 3;

cup_cut_dia = 170;
cup_cut_x = 50;
cup_cut_z = 65;


/*[Magnet Parameters]*/
/*******************************************************************************
*
*******************************************************************************/
// Magnet Count
magnet_count = 1; //[1,3]
// Diameter of the base magnet
magnet_dia = 52;

// Thickness of the cup floor (how much material covers the magnet)
floor_thickness = 2;

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
* Make it
*******************************************************************************/
difference(){
    union(){

        rotate([0,0,40]){
        cylinder(h=second_tab_height,d1=bottom_dia,d2=second_tab_inner_dia);

        translate([0,0,second_tab_height])    
        cylinder(h=total_height-second_tab_height,d=second_tab_inner_dia);    

        for(i=[0:120:360])
            rotate([0,0,i])
            make_tabs();
        } //union
        
        //cup
        if(Part == "FULL CUP")
            translate([0,0,outer_cup_dia/2+cup_height_adj])
            difference(){
                sphere(d=outer_cup_dia);
                sphere(d=outer_cup_dia-2*cup_thickness);
                
                translate([cup_cut_x,0,cup_cut_z])
                rotate([90,0,0])
                cylinder(h=outer_cup_dia,d=cup_cut_dia,center=true);
            } //difference                
    }//union
    
    //Magnet cutout
    if(Part == "FULL CUP")
        if(magnet_count == 1)
            translate([0,0,-$dl])
            cylinder(h=total_height-floor_thickness,d=magnet_dia);
        else
            for(i=[0:120:240])
                rotate([0,0,i+60])
                translate([magnet_dia/2+3,0,-$dl])
                cylinder(h=total_height-floor_thickness,d=magnet_dia);
    
    if(Part == "BASE ONLY")
        translate([0,0,-$dl])
        rotate([180,0,0])
        screw_hole();
} //difference

/*******************************************************************************
* Make the tabs
*******************************************************************************/
module make_tabs(){
//tab_dia = bottom_dia+2*first_tab_height*tan(draft_angle);
//tab_dia = bottom_dia+2*first_tab_height*0.577;
tab_dia= 77.23;

    difference(){
        cylinder(h = first_tab_height, d1 = bottom_dia,d2 = tab_dia);
        
        translate([-tab_dia/2,0,-first_tab_height/2])
        cube([tab_dia,tab_dia/2,2*first_tab_height]);
        
        rotate([0,0,180-first_tab_angle])
        translate([-tab_dia/2,0,-first_tab_height/2])
        cube([tab_dia,tab_dia/2,2*first_tab_height]);

        //make inclined step
        translate([0,0,6])
        rotate([60,0,180-first_tab_angle])
        translate([-tab_dia/2,0,-first_tab_height/2])
        cube([tab_dia,tab_dia/2,2*first_tab_height]);
    }//difference
    
    translate([0,0,first_tab_height])
    difference(){
        // added $dl to height to fix weird non-manifold error
        cylinder(h = second_tab_height-first_tab_height+$dl,d = tab_dia);
        
        translate([-tab_dia/2,0,-second_tab_height/2])
        cube([tab_dia,tab_dia/2,2*second_tab_height]);
        
        rotate([0,0,180-second_tab_angle])
        translate([-tab_dia/2,0,-second_tab_height/2])
        cube([tab_dia,tab_dia/2,2*second_tab_height]);
        
        //make_inclined step
        translate([0,0,0])
        rotate([60,0,180-second_tab_angle])
        translate([-tab_dia/2,0,-first_tab_height/2])
        cube([tab_dia,tab_dia/2,2*first_tab_height]);

    }//difference

    translate([0,0,second_tab_height])
    difference(){
        cylinder(h = total_height-second_tab_height, d = tab_dia);
        
        translate([-tab_dia/2,0,-total_height/2])
        cube([tab_dia,tab_dia/2,2*total_height]);
        
        rotate([0,0,180-third_tab_angle])
        translate([-tab_dia/2,0,-total_height/2])
        cube([tab_dia,tab_dia/2,2*total_height]);
    }//difference

}//module
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
