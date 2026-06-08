// Starter wrapper for /Users/frank/Downloads/m32.stl
//
// STL bounds from file:
//   min: [105.497, 108.185, 0.000]
//   max: [150.503, 147.815, 84.401]
//   size: [45.006, 39.630, 84.401]

stl_file = "/Users/frank/Downloads/m32.stl";

// Bosch GAS 35 hoses are nominally 35 mm.
// Use a little clearance because printed holes usually come out slightly tight.
bosch_hose_diameter = 35;
fit_clearance = 0.6;
target_socket_diameter = bosch_hose_diameter + fit_clearance;

// The source file name suggests a 32 mm socket. If that is correct,
// this scales the whole imported adapter to fit a 35 mm Bosch hose.
source_socket_diameter = 32;
bosch_scale = target_socket_diameter / source_socket_diameter;

// Put the model center on X/Y origin and keep the bottom on Z=0.
module m32_centered() {
  translate([-127.9999, -128.0000, 0])
    import(stl_file, convexity = 10);
}

// Raw import, useful when checking the original STL coordinates.
module m32_raw() {
  import(stl_file, convexity = 10);
}

// Variant 1: scale the whole part from nominal 32 mm to Bosch 35 mm.
// Do not use this if the smaller connector must stay unchanged.
module m32_scaled_for_bosch_gas35() {
  scale([bosch_scale, bosch_scale, bosch_scale])
    m32_centered();
}

// Variant 2: keep the outside unchanged and enlarge only a centered socket.
// Adjust socket_depth if the hose should insert deeper or shallower.
module m32_with_35mm_center_socket(socket_depth = 45) {
  difference() {
    m32_centered();

    translate([0, 0, -1])
      cylinder(h = socket_depth + 1, d = target_socket_diameter, $fn = 96);
  }
}

// Choose one:
//   "original"       unchanged centered STL
//   "scale_bosch35"  whole part scaled from 32 mm to 35 mm
//   "cut_bosch35"    only a centered 35 mm socket is cut/enlarged
variant = "original";

if (variant == "scale_bosch35") {
  m32_scaled_for_bosch_gas35();
} else if (variant == "cut_bosch35") {
  m32_with_35mm_center_socket();
} else {
  m32_centered();
}
