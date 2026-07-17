// =========================================================================
// PARAMETRISCHE BOX MIT RECHTS/LINKS SCHARNIEREN (NEBENEINANDER DRUCKEN)
// =========================================================================
// Der Modus "both" zeigt nun beide Teile druckfertig auf dem Bett (Z=0):
// - Unterteil steht aufrecht.
// - Deckel liegt um 180° gedreht flach daneben auf seiner Oberseite.
// =========================================================================

/* [Hauptmaße der Box] */
// Äußere Breite der Box (X-Achse) in mm
box_width = 120; 
// Äußere Tiefe der Box (Y-Achse) ohne Scharnier in mm
box_depth = 85; 
// Höhe des Unterteils (Z-Achse) in mm
base_height = 48; 
// Höhe des Deckels (Z-Achse) in mm
lid_height = 48; 
// Wandstärke der Box in mm
wall_thickness = 2.4; 

/* [Scharnier-Einstellungen] */
// Maximale Breite eines der beiden Scharniere in mm
hinge_width = 20; 
// Lochdurchmesser für die M3-Schraube
hinge_pin_diameter = 3.2; 
// Außendurchmesser der Gelenkzylinder
hinge_outer_diameter = 8.0; 
// Extra Abstand/Versatz nach hinten (schützt die Wand und ermöglicht 180° Öffnung)
hinge_back_offset = 1.5; 
// Abstand zwischen den beweglichen Scharnierteilen in mm (Spielraum)
hinge_clearance = 0.5; 
// Abstand der Scharniere vom linken/rechten Außenrand in mm
hinge_edge_offset = 10; 

/* [Anzeige-Optionen] */
// "both" zeigt beide Teile druckfertig nebeneinander auf dem Bett.
// "base" zeigt nur das Unterteil.
// "lid" zeigt nur den Deckel (flach auf dem Kopf für den Druck).
render_part = "both"; // [both, base, lid]

/* [Details] */
$fn = 128; // Hohe Auflösung für die Gelenke

// =========================================================================
// INTERNE BERECHNUNGEN
// =========================================================================
hinge_y_center = box_depth + (hinge_outer_diameter / 2) + hinge_back_offset;

// Breitenberechnung der einzelnen Scharnier-Finger (3-teiliges System)
outer_segment_w = (hinge_width / 3) - (hinge_clearance / 2);
inner_segment_w = (hinge_width / 3) - hinge_clearance;

// =========================================================================
// HAUPTSTEUERUNG
// =========================================================================

if (render_part == "both") {
    // 1. Unterteil steht normal auf dem Bett
    base();
    
    // 2. Deckel liegt dahinter, um 180° gedreht flach auf seiner Oberseite (Z=0)
    // Er hat 15mm Abstand zum Scharnier des Unterteils
    translate([0, box_depth + hinge_outer_diameter + 15, 0])
        lid_flat_for_print();
} else if (render_part == "base") {
    base();
} else if (render_part == "lid") {
    lid_flat_for_print();
}

// =========================================================================
// SCHARNIER-MODULE (Mechanische Bauteile im geschlossenen Zustand)
// =========================================================================

// Einzelnes Scharniersegment mit Verbindungssteg zur Boxwand
module solid_hinge_segment(w, z_dir=-1) {
    difference() {
        union() {
            // Der runde Gelenkkörper
            rotate([0, 90, 0])
                cylinder(h=w, d=hinge_outer_diameter, center=false);
            
            // Stabiler Verbindungssteg zur Boxwand
            if (z_dir == 1) {
                // Steg nach oben gerichtet zur Deckelwand hin
                translate([0, -(hinge_y_center - box_depth), 0])
                    cube([w, hinge_y_center - box_depth, hinge_outer_diameter/2]);
            } else {
                // Steg nach unten gerichtet zur Unterteilwand hin
                translate([0, -(hinge_y_center - box_depth), -hinge_outer_diameter/2])
                    cube([w, hinge_y_center - box_depth, hinge_outer_diameter/2]);
            }
        }
        // Das M3-Durchgangsloch für die Schraube
        translate([-1, 0, 0])
            rotate([0, 90, 0])
                cylinder(h=w+2, d=hinge_pin_diameter, center=false);
    }
}

// Erzeugt die Scharnier-Körper für das Unterteil
module base_hinge_solid_at(x_pos) {
    translate([x_pos, hinge_y_center, base_height]) {
        solid_hinge_segment(outer_segment_w, z_dir=-1);
        translate([hinge_width - outer_segment_w, 0, 0])
            solid_hinge_segment(outer_segment_w, z_dir=-1);
    }
}

// Erzeugt die Scharnier-Körper für den Deckel (im geschlossenen Zustand)
module lid_hinge_solid_at(x_pos) {
    translate([x_pos + outer_segment_w + hinge_clearance/2, hinge_y_center, 0]) {
        solid_hinge_segment(inner_segment_w, z_dir=1);
    }
}

// Schneidet im Unterteil Platz für das mittlere Gelenk des Deckels frei
module base_hinge_cutout_at(x_pos) {
    translate([
        x_pos + outer_segment_w - hinge_clearance/2, 
        box_depth - 0.1, 
        base_height - hinge_outer_diameter/2 - 0.1
    ])
        cube([
            inner_segment_w + hinge_clearance, 
            (hinge_y_center - box_depth) + hinge_outer_diameter/2 + 1, 
            hinge_outer_diameter/2 + 0.5
        ]);
}

// Schneidet im Deckel Platz für die Gelenke des Unterteils frei
module lid_hinge_cutout_at(x_pos) {
    translate([
        x_pos - hinge_clearance, 
        box_depth - 0.1, 
        -0.1
    ])
        cube([
            outer_segment_w + hinge_clearance * 1.5, 
            (hinge_y_center - box_depth) + hinge_outer_diameter/2 + 1, 
            hinge_outer_diameter/2 + 0.5
        ]);
    
    translate([
        x_pos + hinge_width - outer_segment_w - hinge_clearance/2, 
        box_depth - 0.1, 
        -0.1
    ])
        cube([
            outer_segment_w + hinge_clearance * 1.5, 
            (hinge_y_center - box_depth) + hinge_outer_diameter/2 + 1, 
            hinge_outer_diameter/2 + 0.5
        ]);
}

// =========================================================================
// BOX UNTERTEIL (Base)
// =========================================================================
module base() {
    difference() {
        union() {
            difference() {
                cube([box_width, box_depth, base_height]);
                translate([wall_thickness, wall_thickness, wall_thickness])
                    cube([box_width - 2*wall_thickness, box_depth - 2*wall_thickness, base_height]);
            }
            base_hinge_solid_at(hinge_edge_offset);
            base_hinge_solid_at(box_width - hinge_edge_offset - hinge_width);
        }
        base_hinge_cutout_at(hinge_edge_offset);
        base_hinge_cutout_at(box_width - hinge_edge_offset - hinge_width);
    }
}

// =========================================================================
// BOX DECKEL (Hilfsmodul: Geschlossene Ausrichtung)
// =========================================================================
module lid_closed() {
    difference() {
        union() {
            difference() {
                cube([box_width, box_depth, lid_height]);
                translate([wall_thickness, wall_thickness, -1])
                    cube([box_width - 2*wall_thickness, box_depth - 2*wall_thickness, lid_height - wall_thickness + 1]);
            }
            lid_hinge_solid_at(hinge_edge_offset);
            lid_hinge_solid_at(box_width - hinge_edge_offset - hinge_width);
        }
        lid_hinge_cutout_at(hinge_edge_offset);
        lid_hinge_cutout_at(box_width - hinge_edge_offset - hinge_width);
    }
}

// =========================================================================
// BOX DECKEL (Druckbereite Ausrichtung: Flach auf der Oberseite)
// =========================================================================
module lid_flat_for_print() {
    // Nimmt den perfekt ausgerichteten geschlossenen Deckel, rotiert ihn um 180°
    // und verschiebt ihn so auf der Y-Achse, dass er sauber positioniert ist.
    translate([0, box_depth, lid_height])
        rotate([180, 0, 0])
            lid_closed();
}