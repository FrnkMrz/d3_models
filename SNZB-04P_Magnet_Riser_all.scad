// Distanzhalter (Riser) fuer den Zigbee-Kontaktsensor-Magneten "Kuechentuer"

$fn = 40; // Aufloesung fuer die Rundungen

// --- Parameter ---
magnet_length   = 27;   // mm, Magnet-Laenge
magnet_width    = 12;   // mm, Magnet-Breite
clearance       = 0.4;  // mm, Spiel rundum in der Tasche

pocket_depth    = 2;    // mm, wie tief der Magnet in der Tasche versenkt wird
base_margin     = 2;    // mm, Rand um den Magneten fuer stabile Wandstaerke
corner_radius   = 1.5;  // mm, Rundungsradius fuer alle Aussenkanten (X, Y und Oben)

// TEXT PARAMETER
text_tiefe      = 1.0;  // mm, wie tief der Text eingeprägt wird

// ABSTÄNDE FÜR DEN MULTIPLE-DRUCK
abstand_x       = 10;   // mm, Freiraum zwischen den Objekten auf dem Druckbett

// HIER DIE GEWÜNSCHTEN HÖHEN EINTRAGEN (von 10mm bis 40mm in 5mm Schritten)
riser_hoehen = [10, 15, 20, 25, 30, 35, 40]; 

base_length = magnet_length + 2 * base_margin;
base_width  = magnet_width + 2 * base_margin;

pocket_length = magnet_length + clearance;
pocket_width  = magnet_width + clearance;

module riser(hoehe) {
    // Schrifthöhe dynamisch anpassen
    aktuelle_text_groesse = min(5.5, hoehe - pocket_depth - 3);
    text_string = str(hoehe, "mm");

    difference() {
        // Grundkoerper mit abgerundeten Ecken
        minkowski() {
            translate([corner_radius, corner_radius, 0])
            cube([
                base_length - 2 * corner_radius, 
                base_width - 2 * corner_radius, 
                hoehe - corner_radius
            ]);
            sphere(r = corner_radius);
        }

        // Tasche fuer den Magneten
        translate([
            (base_length - pocket_length) / 2,
            (base_width - pocket_width) / 2,
            hoehe - pocket_depth
        ])
        linear_extrude(height = pocket_depth + 0.1) {
            hull() {
                r = corner_radius * 0.5;
                translate([r, r, 0]) circle(r=r);
                translate([pocket_length-r, r, 0]) circle(r=r);
                translate([r, pocket_width-r, 0]) circle(r=r);
                translate([pocket_length-r, pocket_width-r, 0]) circle(r=r);
            }
        }
        
        // TEXT-PRÄGUNG VORNE (Richtung korrigiert)
        // Wir starten den Text INSIDE der Wand (bei Y = text_tiefe)
        // und extrudieren nach außen (Richtung Y = 0), um das Material abzuziehen.
        translate([base_length / 2, text_tiefe, (hoehe - pocket_depth) / 2])
        rotate([90, 0, 0])
        linear_extrude(height = text_tiefe + 0.2) {
            text(text_string, size = aktuelle_text_groesse, font = "Arial:style=Bold", halign = "center", valign = "center");
        }
        
        // Abschneiden des Kugel-Ueberstands an der Unterseite
        translate([-5, -5, -corner_radius])
        cube([base_length + 10, base_width + 10, corner_radius]);
    }
}

// Schleife generiert die Objekte nebeneinander
for (i = [0 : len(riser_hoehen) - 1]) {
    x_pos = i * (base_length + abstand_x);
    translate([x_pos, 0, 0])
        riser(riser_hoehen[i]);
}