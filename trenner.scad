// =========================================================================
// PARAMETER - Hier kannst du die Maße flexibel anpassen
// =========================================================================

karten_breite   = 111;    // Breite der Karteikarte (in mm)
karten_hoehe    = 71;     // Höhe der Karteikarte mit Reiter (ca. 70.5 mm)
karten_staerke  = 0.9;    // Dicke der Trennkarte (1.0 mm ist ideal)

reiter_breite   = 14;     // Breite des Reiters oben (14 mm)
reiter_hoehe    = 10;     // Höhe des Reiters, der oben herausragt (in mm)

// SAUBERE REITEREINSTELLUNG
anzahl_positionen = 9;    // Wie viele Tab-Positionen soll es insgesamt geben? (z.B. 5 oder 6)
reiter_position   = 8;    // Aktuelle Position: 0 ist ganz links, 
                          // (anzahl_positionen - 1) ist ganz rechts.
                          // Bei 5 Positionen sind das die Zahlen: 0, 1, 2, 3, 4

ecken_radius    = 2.0;    // Abrundung der Ecken unten und am Reiter
$fn             = 30;     // Auflösung der Rundungen

// =========================================================================
// BERECHNUNGEN & MODELLIERUNG
// =========================================================================

// Der mathematisch exakte Bereich, in dem sich der Reiter bewegen darf
verfuegbarer_weg = karten_breite - reiter_breite;

// Berechnet den exakten Schrittabstand für eine perfekt symmetrische Verteilung
schritt_weite = (anzahl_positionen > 1) ? (verfuegbarer_weg / (anzahl_positionen - 1)) : 0;

// Die finale X-Position für den aktuellen Reiter
reiter_x = reiter_position * schritt_weite;

module abgerundete_platte(w, h, d, r) {
    translate([r, r, 0])
    minkowski() {
        cube([w - 2*r, h - 2*r, d / 2]);
        cylinder(r = r, h = d / 2);
    }
}

module abgerundetes_rechteck_mit_reiter(w, h, d, r) {
    translate([r, 0, 0])
    minkowski() {
        cube([w - 2*r, h - r, d / 2]);
        cylinder(r = r, h = d / 2);
    }
}

// Hauptmodell mit Material-Aussparungen
difference() {
    // Das ursprüngliche finale 3D-Modell (Körper + Reiter)
    union() {
        // 1. Die Hauptkarte
        abgerundete_platte(karten_breite, karten_hoehe, karten_staerke, ecken_radius);
        
        // 2. Der Reiter (Tab) oben drauf
        translate([reiter_x, karten_hoehe - ecken_radius, 0])
            abgerundetes_rechteck_mit_reiter(reiter_breite, reiter_hoehe + ecken_radius, karten_staerke, ecken_radius);
    }

    // 3. MATERIAL-AUSSPARUNGEN (3 Fenster in der Mitte)
    rand_aussen_x  = 10;  
    rand_unten     = 10;  
    rand_oben      = 20;  
    steg_breite    = 10;  
    
    verfuegbare_breite = karten_breite - (2 * rand_aussen_x) - (2 * steg_breite);
    fenster_breite     = verfuegbare_breite / 3;
    fenster_hoehe      = karten_hoehe - rand_unten - rand_oben;

    for (f = [0 : 2]) {
        x_pos = rand_aussen_x + f * (fenster_breite + steg_breite);
        
        translate([x_pos, rand_unten, -0.1])
            abgerundete_platte(fenster_breite, fenster_hoehe, karten_staerke + 0.2, 1.5);
    }
}