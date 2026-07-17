// =========================================================================
// PARAMETER - Hier kannst du die Maße flexibel anpassen
// =========================================================================

fach_breite     = 70;   // Innenmaß Breite des Fachs (in mm)
fach_tiefe      = 12;   // Innenmaß Tiefe des Fachs (in mm)
fach_hoehe      = 60;   // Innere Höhe der Fächer (in mm)
anzahl_faecher  = 6;    // Anzahl der Fächer HINTEREINANDER

wand_staerke    = 2;    // Dicke der Trennwände und Außenwände
boden_staerke   = 2;    // Dicke des Bodens unter den Fächern

rand_breite     = 5;    // Wie weit steht der Stabilisierungsrand unten über
rand_hoehe      = 6;    // Wie hoch ist der Stabilisierungsrand unten

ecken_radius    = 3;    // Radius für die abgerundeten Außenkanten (oben & seitlich)
$fn             = 40;   // Auflösung der Rundungen (höher = glatter)

// TEXT PARAMETER
text_inhalt     = "frnkmrz"; // Der Text, der graviert wird
text_groesse    = 10;        // Höhe der Buchstaben
text_tiefe      = 1;         // Wie tief die Gravur sein soll (1mm)

// =========================================================================
// BERECHNUNGEN & MODELLIERUNG
// =========================================================================

// Gesamtmaße der Hauptbox (ohne äußeren Rand)
gesamt_breite = fach_breite + (wand_staerke * 2);
gesamt_tiefe  = (fach_tiefe * anzahl_faecher) + (wand_staerke * (anzahl_faecher + 1));
gesamt_hoehe  = fach_hoehe + boden_staerke;

difference() {
    // 1. GRUNDKÖRPER (Hauptbox + vollrund abgetönter Sockel)
    union() {
        // Hauptbox: Vertikale Kanten und obere horizontale Kante abgerundet
        translate([ecken_radius, ecken_radius, 0])
        minkowski() {
            cube([gesamt_breite - 2*ecken_radius, gesamt_tiefe - 2*ecken_radius, gesamt_hoehe - ecken_radius]);
            union() {
                cylinder(r = ecken_radius, h = 1);
                translate([0, 0, 1]) sphere(r = ecken_radius);
            }
        }
        
        // Stabilisierungsrand unten: Rundung an Außen- UND Innenseite zum Hauptkörper
        // Erreicht durch ein Minkowski-Objekt mit einer Kugel auf exakter Höhe
        translate([-rand_breite + ecken_radius, -rand_breite + ecken_radius, 0])
        minkowski() {
            cube([gesamt_breite + (rand_breite * 2) - 2*ecken_radius, gesamt_tiefe + (rand_breite * 2) - 2*ecken_radius, rand_hoehe - ecken_radius]);
            sphere(r = ecken_radius);
        }
    }

    // 2. ABSCHNEIDEN DER BODENUNTERSEITE
    // Da die Kugel den Sockel auch nach unten krümmt, rasieren wir die Unterseite bei Z=0 glatt
    translate([-rand_breite - 10, -rand_breite - 10, -ecken_radius * 2])
        cube([gesamt_breite + (rand_breite * 2) + 20, gesamt_tiefe + (rand_breite * 2) + 20, ecken_radius * 2]);

    // 3. AUSSCHNEIDEN DER FÄCHER
    for (i = [0 : anzahl_faecher - 1]) {
        pos_y = wand_staerke + i * (fach_tiefe + wand_staerke);
        
        translate([wand_staerke, pos_y, boden_staerke])
            cube([fach_breite, fach_tiefe, gesamt_hoehe + 10]);
    }

    // 4. TEXT-GRAVUR VORNE (Vorschau-optimiert)
    translate([gesamt_breite / 2, 0.1, rand_hoehe + (gesamt_hoehe - rand_hoehe) / 2])
    rotate([90, 0, 0])
    linear_extrude(height = text_tiefe + 0.1) 
        text(text_inhalt, size = text_groesse, font = "Arial:style=Bold", halign = "center", valign = "center");
}