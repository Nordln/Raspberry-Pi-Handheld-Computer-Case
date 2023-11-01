/* [Global settings] */

// Global rescaler (X*1mm)
rescaler = 1; 

// Min. facet render level (mm)
$fs = 0.1;  // Don't generate smaller facets than 0.1 mm

// Min angles render level (deg)
$fa = 10;    // Don't generate larger angles than 5 degrees

// Enable helper geometry
exploded = false; // [True, False]

// Enable helper geometry
debug = false; // [True, False]

// Split view
splitview = "All"; // ["All","Lid","Body"]

// Case Slicer 1
slicer1 = "None"; // ["None", "+x","+y","+z","-x","-y","-z"]

// Case Slicer 2
slicer2 = "None"; // ["None", "+x","+y","+z","-x","-y","-z"]

// Display Electronics
disp_elec = false; // [True, False]

// Horiz. spacing between debug parts (mm)
debug_spacing_y = 40;

// Vert. spacing between debug parts (mm)
debug_spacing_z = 160; 



//******* box measuremens *******

// Bottom panel x (mm)
bp_l = 106;

// Bottom panel y (mm)
bp_w = 100;

// global height (mm)
glob_h = 50;

/* [main box dimensions] */

long_sides_curve_r = 10;
short_sides_curve_r = 5;
long_sides_curve_h = 1;

// height of box (mm)
box_y = glob_h - 2 * long_sides_curve_r;

// Width of box bottom (mm)
box_x1 = bp_w - 2 * long_sides_curve_r;

// Width of box top (mm)
box_x2 = ((box_x1-long_sides_curve_r)*0.40) + long_sides_curve_r;

// lenght of box (mm)
box_z = bp_l + 2 * short_sides_curve_r; 



//******* screw measuremens *******

// screw tubes lenght (mm)
tube_y = 100;

// screw tubes diameter (mm)
tube_d = 16;

// screw tubes z separation (mm)
tubes_sep_z = 58;

// screw tubes x separation (mm)
tubes_sep_x = 48;

// screw tubes void z separation (mm)
tubes_sep_void_z = 56.8;

// screw tubes void x separation (mm)
tubes_sep_void_x = 47;

// screw head radius
screw_head_r = 2.7;

// screw length
screw_shaft_l = 13.4;

// screw r (ex thread)
screw_shaft_r_ex = 1.15; 

// screw r (inc thread)
screw_shaft_r_inc = 1.35;

// Bounding box dimentions (for output window only)
box_bb_x = box_x1 + 2*long_sides_curve_r + 2*short_sides_curve_r;
box_bb_y = box_y + 2*long_sides_curve_r + 2*short_sides_curve_r;
box_bb_z = box_z + 2*short_sides_curve_r + (2*long_sides_curve_h);
echo(Bounding_box_y=box_bb_y);
echo(Bounding_box_x=box_bb_x);
echo(Bounding_box_z=box_bb_z);

//Wall thickness (mm)
//wall_thickness = 5;
//Wall = 8;   // Wall thickness
//divide = 55; // split position


// trackball cutout 
tb_cutout_dim_x = 15; 
tb_cutout_dim_y = 14.7; 
tb_cutout_dim_z = 14.7; 
tb_cutout_pos_x = 40; 
tb_cutout_pos_y = -14.4/2 + 14.4/2; 
tb_cutout_pos_z = 0 - (128/2) + 26.2;
tb_cutout_rot_x = 0;
tb_cutout_rot_y = 0;
tb_cutout_rot_z = 20;

// port cutout 
port_cutout_dim_x = 58; 
port_cutout_dim_y = 34.8; 
port_cutout_dim_z = 10; 
port_cutout_pos_x = -18; 
port_cutout_pos_y = -20.0; 
port_cutout_pos_z = 60; 

// fan cutout 
fan_cutout_radius = 26.3/2; 
fan_cutout_h = 60; 
fan_cutout_pos_x = 20; 
fan_cutout_pos_y = 0; 
fan_cutout_pos_z = -50; 

// usb port cutout 
usb_cutout_radius = 3/2; 
usb_cutout_h = 60; 
usb_cutout_pos_x = -8; 
usb_cutout_pos_y = 12; 
usb_cutout_pos_z = -50; 
usb_length = 6.1; 


// part holder
partholder_dim_x = 6;
partholder_dim_y = 1;
partholder_dim_z = 10;
partholder_sm_dim_x = 60;
partholder_sm_dim_y = 1;
partholder_sm_dim_z = 3;


// part holder z separation (mm)
partholder_sep_z = 57;

// part holder x separation (mm)
partholder_sep_x = 40;

// part holder y position (mm)
partholder_pos_y = -19.5;


// Main geometry
// ***************************************************

// lid
if ((splitview == "Lid") || (splitview == "All")) difference() { featured_case();plane_mask("+y", -20);}
    
// body
if ((splitview == "Body") || (splitview == "All")) difference() { featured_case(); plane_mask("-y", 20);}

//translate([0,-30,0]) screw_voids();

// electronics
if (disp_elec) translate([0,-24,0]) electronics();

// helpers
if (debug) helpers();


// Intermediate components (centered)
//*****************************************************

// featured case
module featured_case() {
    difference() {
        case();
        
        //screw void cutouts
        translate([0,-30,0]) screw_voids();
        
        // port cutout 
        translate([port_cutout_pos_x,port_cutout_pos_y,port_cutout_pos_z]) cube([port_cutout_dim_x,port_cutout_dim_y,port_cutout_dim_z]);
        
        // fan cutout 
        translate([fan_cutout_pos_x,fan_cutout_pos_y,fan_cutout_pos_z]) cylinder(fan_cutout_h,fan_cutout_radius,fan_cutout_radius,center=true);

        // usb port cutout 
        hull() {
            translate([usb_cutout_pos_x,usb_cutout_pos_y,usb_cutout_pos_z]) cylinder(usb_cutout_h,usb_cutout_radius,usb_cutout_radius,center=true);
            translate([usb_cutout_pos_x,usb_cutout_pos_y + usb_length,usb_cutout_pos_z]) cylinder(usb_cutout_h,usb_cutout_radius,usb_cutout_radius,center=true);
        }
        
        // trackball cutout 
    translate([tb_cutout_pos_x,tb_cutout_pos_y,tb_cutout_pos_z]) rotate([tb_cutout_rot_x,tb_cutout_rot_y,tb_cutout_rot_z]) cube([tb_cutout_dim_x,tb_cutout_dim_y,tb_cutout_dim_z]);
    }
}


// hollowed case
module case() {
        difference() { // lid diff
            difference() { // hollow diff
                translate([0,0,0]) difference() {
                    difference() { // case lid
                        box(); // case outer
                        translate([0,0,0]) scale([0.96,0.93,0.955]) box(); // case inner shell, scaled
                    }
                    //translate([0,(box_bb_y/10)*3,0]) cube([box_bb_x,box_bb_y,box_bb_z],center=true); // lid divide
                    if ((slicer1 == "-x") || (slicer2 == "-x")) plane_mask("-x", 0);
                    if ((slicer1 == "+x") || (slicer2 == "+x")) plane_mask("+x", 0);
                    if ((slicer1 == "-y") || (slicer2 == "-y")) plane_mask("-y", 0);
                    if ((slicer1 == "+y") || (slicer2 == "+y")) plane_mask("+y", 0);
                    if ((slicer1 == "-z") || (slicer2 == "-z")) plane_mask("-z", 0);
                    if ((slicer1 == "+z") || (slicer2 == "+z")) plane_mask("+z", 0);
                }
            }
            
        // lid cutout
        translate([2.7,-20,0]) cube([68,30,115], center=true); //lid LCD window
        }
   
    //screw column addition    
    intersection() {
        color("yellow") screw_tubes();
        box();
    }
    
    // Pi4, UPS and touchscreen holding brackets 
    part_holders();
    
}

module part_holders() {
    
   hull() {
        translate([0-partholder_sep_x,partholder_pos_y,0-partholder_sep_z]) color("pink") part_holder();
        translate([0-partholder_sep_x - 5,partholder_pos_y + 10,0-partholder_sep_z]) color("pink") part_holder();
   }    
   
   hull() {
        translate([0-partholder_sep_x,partholder_pos_y,0+partholder_sep_z]) color("pink") part_holder();
        translate([0-partholder_sep_x - 5,partholder_pos_y+10,0+partholder_sep_z]) color("pink") part_holder();
   }
   
   hull() {
        translate([0+partholder_sep_x,partholder_pos_y,0-partholder_sep_z]) color("pink") part_holder();
        translate([0+partholder_sep_x + 5,partholder_pos_y+10,0-partholder_sep_z]) color("pink") part_holder();
   }
}

module screw_voids() {
   translate([0-tubes_sep_void_x,0,0-tubes_sep_void_z]) color("pink") rotate([90,0,0]) screw_void();
   translate([0+tubes_sep_void_x,0,0 + tubes_sep_void_z]) color("pink") rotate([90,0,0]) screw_void();
   translate([0-tubes_sep_void_x,0,0+tubes_sep_void_z]) color("pink") rotate([90,0,0]) screw_void();
   translate([0+tubes_sep_void_x,0,0-tubes_sep_void_z]) color("pink") rotate([90,0,0]) screw_void(); 
}

module screw_tubes() {
   translate([0-tubes_sep_x,0,0-tubes_sep_z]) color("Red") rotate([90,0,0]) screw_tube();
   translate([0+tubes_sep_x,0,0+tubes_sep_z]) color("Red") rotate([90,0,0]) screw_tube();
   translate([0-tubes_sep_x,0,0+tubes_sep_z]) color("Red") rotate([90,0,0]) screw_tube();
   translate([0+tubes_sep_x,0,0-tubes_sep_z]) color("Red") rotate([90,0,0]) screw_tube(); 
}

module electronics() {
    rotate([180,0,0]) translate([10,-20,-14]) raspi4b(); 
    translate([0,0,0]) raspi_LCD(); 
    translate([43.8,12,4.8]) raspi_HDMI_connector();
    rotate([180,0,0]) translate([10,-26.4,-14]) raspi_UPS(); // 6.4mm offset from Rpi board
}

// Core geometric primitives (centered)
//*******************************************************

module plane_mask(x, y) {
    if (x == "-x") translate([-100 - y,0,0]) cube([200,200,200], center=true); //-x
    if (x == "-y") translate([0,-100 - y,0]) cube([200,200,200], center=true); //-y 
    if (x == "-z") translate([0,0,-100 - y]) cube([200,200,200], center=true); //-z
    if (x == "+x") translate([100 + y,0,0]) cube([200,200,200], center=true); //+x
    if (x == "+y") translate([0,100 + y,0]) cube([200,200,200], center=true); //+y 
    if (x == "+z") translate([0,0,100 + y]) cube([200,200,200], center=true); //+z
}

// solid box shape
module box() {
    rotate ([0,0,0]) minkowski() {
       hull() {
            translate([0,0-box_y/2,0])cube([box_x1,0.001,box_z], center=true); // top plane
            translate([10,0+box_y/2,0]) cube([box_x2,0.001,box_z], center=true); // bottom plane
        }
        minkowski() {
                cylinder(r=long_sides_curve_r,h=long_sides_curve_h, center=true);
                sphere(r=short_sides_curve_r, $fn=20);
        }
    }
}

module box_bb(offset_x = 0,offset_y = 0,offset_z = 0,translate_x = 0,translate_y = 0,translate_z = 0) {
    translate([translate_x, translate_y, translate_z]) cube([box_bb_x - offset_x, box_bb_y - offset_y, box_bb_z - offset_z], center=true);
}

module raspi4b() {
     color("red") rotate ([-90,90,0]) translate([-40,-30,0]) import("Raspberry_pi_4_v0.5_ew.stl", center=true);
}

module raspi_LCD() {
    color("red") cube([77.6,7,121.6], center=true); // LCD backplane
    color("pink") translate([2.8,-0.1,0]) cube([66.7,7,112.7], center=true); // LCD viewable area
}

module raspi_UPS() {
    color("red") translate([2,0,-2.5]) cube([56,1.6,85], center=true); // UPS backplane
    color("red") translate([2,-11.1,1.5]) cube([40,20.6,77], center=true); // UPS battery module
}

module raspi_HDMI_connector() {
    color("red") cube([10,16.4,18.9], center=true);
}

module part_holder() {
    cube([partholder_dim_x,partholder_dim_y,partholder_dim_z], center=true);
}

module part_holder_sm() {
    cube([partholder_sm_dim_x,partholder_sm_dim_y,partholder_sm_dim_z], center=true);
}

module screw_tube() {
    cylinder(h=tube_y, r1=(tube_d/2), r2=(tube_d/2), center=true);
}

module screw_void() {
    cylinder(h=screw_shaft_l, r1=(screw_head_r), r2=(screw_head_r), center=true); // screw head
    translate([0,0,-4]) cylinder(h=screw_shaft_l, r1=(screw_shaft_r_inc), r2=(screw_shaft_r_inc), center=true); // screw shaft (inc thread)
    translate([0,0,-10]) cylinder(h=screw_shaft_l + 10, r1=(screw_shaft_r_ex), r2=(screw_shaft_r_ex), center=true); // screw shaft (ex thread)
}// screw_shaft_r   screw_shaft_r_inc  screw_shaft_r_ex   screw_head_r

//module box() {
//   color("Blue") cube([10,10,10], center=true);
//}

//module tube() {
   //color("Red") rotate([90,0,0]) cylinder(h=tube_y, r1=(tube_d/2), r2=(tube_d/4), center=true);
//}

//module ball() {
   //color("Green") sphere(r=(ball_d));
//}

// debug display

module helpers() {
    translate([0, 0 - debug_spacing_y*2 - box_y/2, debug_spacing_z * -1]) raspi4b();
    translate([0, 0 - debug_spacing_y*2 - box_y/2, debug_spacing_z * -2]) box();
    translate([0, 0 - debug_spacing_y*1 - tube_y/2, debug_spacing_z * -3]) screw_tubes();
    translate([0, 0 - debug_spacing_y*1 - tube_y/2, debug_spacing_z * -4]) screw_voids();
    //translate([0, 0 + debug_spacing_y*2 - ball_d/2, debug_spacing_z * -2]) ball();
}

echo(version=version());
// Written by Ed Watson <mail@edwardwatson.co.uk>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

              