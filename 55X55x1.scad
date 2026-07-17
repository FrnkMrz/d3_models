// ==========================================
// PARAMETER - Hier kannst du die Maße ändern
// ==========================================

breite = 55;      // Gesamte Breite der Platte (X-Achse) in mm
laenge = 55;      // Gesamte Länge der Platte (Y-Achse) in mm
hoehe = 1;        // Stärke/Dicke der Platte (Z-Achse) in mm
radius = 3;       // Radius der abgerundeten Ecken in mm

$fn = 100;        // Auflösung der Rundungen (höherer Wert = glattere Kurven)

// ==========================================
// BERECHNUNG & GEOMETRIE
// ==========================================

// Wir verschieben die Zylinder so, dass die Außenkanten 
// exakt den oben definierten Maßen entsprechen.
versatz_x = (breite / 2) - radius;
versatz_y = (laenge / 2) - radius;

// Der hull-Befehl "umspannt" die vier Zylinder wie ein straffes Band
hull() {
    // Ecke hinten rechts
    translate([versatz_x, versatz_y, 0])
        cylinder(h = hoehe, r = radius, center = false);
        
    // Ecke hinten links
    translate([-versatz_x, versatz_y, 0])
        cylinder(h = hoehe, r = radius, center = false);
        
    // Ecke vorne rechts
    translate([versatz_x, -versatz_y, 0])
        cylinder(h = hoehe, r = radius, center = false);
        
    // Ecke vorne links
    translate([-versatz_x, -versatz_y, 0])
        cylinder(h = hoehe, r = radius, center = false);
}