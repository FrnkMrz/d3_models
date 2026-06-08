// ====================================================================
// Parametrischer Hex-Bit-Halter (6x10 Loecher)
// Version 26: Minkowski-Shift korrigiert, Text auf Rueckwand fixiert
// ====================================================================

// --- BASIS-EINSTELLUNGEN ---
breite = 200;           // Gesamte Breite des Halters (X-Achse) in mm
tiefe = 140;            // Gesamte Tiefe des Halters (Y-Achse) in mm

// --- HOEHEN DES KEILS ---
hoehe_hinten = 40;      // Hoehe des Blocks an der Rueckseite in mm
hoehe_vorne = 20;       // Flachere Frontwand, da kein Text mehr hier sitzt

// --- LOCH-RASTER & NEIGUNG ---
reihen_x = 8;           // Anzahl der Loecher nebeneinander (Breite)
reihen_y = 6;           // Anzahl der Loecher hintereinander (Tiefe)
neigung_winkel = 10;    // Neigung der Loecher nach vorne (in Grad)

// --- BIT-ABMESSUNGEN ---
bit_aussen_durchmesser = 7.4; // Aussendurchmesser (ueber Ecken) fuer 1/4 Zoll Hex-Bits
loch_tiefe = 15;        // Tiefe der Loecher in mm

// --- WANDMONTAGE (SCHRAUBEN-LASCHE) ---
mit_lasche = true;      // Auf true lassen fuer die Rueckwand mit Schraubloechern
laschen_dicke = 10;     // Massive 10mm Dicke fuer sicheren Halt an der Wand
laschen_hoehe = 65;     // Gesamthoehe der Rueckwand ab Boden in mm
loch_schraube = 4.5;    // Durchmesser des Schraubenschafts (fuer M4 Schrauben)
senkung_durchmesser = 9.0; // Maximaler Durchmesser des Senkkopfs
senkung_tiefe = 3.0;    // Tiefe der Kegelsenkung fuer den Schraubenkopf

// --- DESIGN-DETAILS & SCHRIFT ---
kanten_radius = 2.0;    // Radius fuer die Abrundung ALLER Aussenkanten in mm
text_inhalt = "frnkmrz"; // Dein gewuenschter Schriftzug
text_groesse = 14;      // Schrifthoehe in mm
text_tiefe = 1.5;       // Wie tief die Schrift eingepraegt wird in mm
wand_staerke = 4.0;     // Wandung des ausgehoehlten Gehaeuses
$fn = 24;               // Detailstufe fuer Rundungen (optimiert fuer Minkowski)


// --- SCHARFKANTIGE GRUND-MODULE ---

// Erzeugt die zweidimensionale Grundflaeche des Halters
module basis_block_2d(w, d) {
    square([w, d]);
}

// Baut einen scharfen Keil, dessen Oberseite von hinten nach vorne abfaellt
module keil_block_scharf(w, d, h_hinten, h_vorne) {
    hull() {
        linear_extrude(height = 0.1) basis_block_2d(w, d);
        
        translate([0, 0, h_hinten - 0.1])
            linear_extrude(height = 0.1) square([w, 0.1]);
            
        translate([0, 0, h_vorne - 0.1])
            linear_extrude(height = 0.1) translate([0, d - 0.1]) square([w, 0.1]);
    }
}

// Baut einen einfachen, quaderfoermigen Block fuer die Rueckwand
module flacher_block_scharf(w, d, h) {
    linear_extrude(height = h) basis_block_2d(w, d);
}


// --- HAUPTPROGRAMM (GEOMETRIE-BERECHNUNG) ---

difference() {
    
    // SCHRITT 1: Der perfekt positionierte und rundherum abgerundete Grundkoerper
    // Wir verschieben den gesamten Minkowski-Block um den Kantenradius nach oben/vorn/rechts,
    // damit die Aussenwaende exakt auf den gewuenschten Millimeter-Koordinaten landen.
    translate([kanten_radius, kanten_radius, kanten_radius]) {
        minkowski() {
            union() {
                // Ausgehoehlte Aussenhuelle des Keils
                difference() {
                    keil_block_scharf(breite - (kanten_radius*2), tiefe - (kanten_radius*2), hoehe_hinten - (kanten_radius*2), hoehe_vorne - (kanten_radius*2));
                    
                    // Innenaushoehlung von unten spart massiv Filament und Druckzeit
                    translate([wand_staerke, wand_staerke, -0.1])
                        keil_block_scharf(
                            breite - (kanten_radius*2) - (wand_staerke * 2), 
                            tiefe - (kanten_radius*2) - (wand_staerke * 2), 
                            hoehe_hinten - loch_tiefe - 4, 
                            hoehe_vorne - loch_tiefe - 4
                        );
                }
                
                // Interne Stabilisierungs-Strebe gegen Verbiegen beim Einstecken der Bits
                translate([(breite - kanten_radius*2) / 2 - 2, wand_staerke, 0])
                    keil_block_scharf(4, tiefe - (kanten_radius*2) - (wand_staerke * 2), hoehe_hinten - loch_tiefe - 4, hoehe_vorne - loch_tiefe - 4);
                
                // Stabile Rueckwand fuer die Wandmontage
                if (mit_lasche) {
                    flacher_block_scharf(breite - (kanten_radius*2), laschen_dicke - (kanten_radius*2), laschen_hoehe - (kanten_radius*2));
                }
            }
            
            // Die Minkowski-Kugel definiert den exakten Rundungsradius fuer alle Kanten
            sphere(r = kanten_radius);
        }
    }

    // SCHRITT 2: Ausschneiden der Sechskant-Loecher von oben
    for (pos_x = [breite / (reihen_x + 1) : breite / (reihen_x + 1) : breite - 0.1]) {
        for (pos_y = [laschen_dicke + (tiefe - laschen_dicke) / (reihen_y + 1) : (tiefe - laschen_dicke) / (reihen_y + 1) : tiefe - 0.1]) {
            
            anteil_y = (pos_y - laschen_dicke) / (tiefe - laschen_dicke);
            aktuelle_oberflaeche_z = hoehe_hinten - (anteil_y * (hoehe_hinten - hoehe_vorne));

            translate([pos_x, pos_y, aktuelle_oberflaeche_z + 0.5])
                rotate([-neigung_winkel, 0, 0])
                translate([0, 0, -loch_tiefe])
                cylinder(d = bit_aussen_durchmesser, h = loch_tiefe + 5, $fn = 6);
        }
    }

    // SCHRITT 3: Schraubloecher in die gerade Rueckwand bohren
    if (mit_lasche) {
        for (x_pos = [20, breite - 20]) {
            translate([x_pos, laschen_dicke + 1, laschen_hoehe - 15])
                rotate([90, 0, 0])
                cylinder(d = loch_schraube, h = laschen_dicke + 5);
            
            translate([x_pos, laschen_dicke + 0.1, laschen_hoehe - 15])
                rotate([90, 0, 0])
                cylinder(d1 = senkung_durchmesser, d2 = loch_schraube, h = senkung_tiefe + 0.1);
        }
    }

    // SCHRITT 4: HIER ERST DEN TEXT ABZIEHEN (Nach dem Minkowski-Schritt!)
    // Platziert exakt an der Vorderseite der massiven Lasche zwischen den Bohrungen
    translate([breite / 2, laschen_dicke + 0.1, laschen_hoehe - 15])
        rotate([90, 0, 0]) 
        linear_extrude(height = text_tiefe)
            mirror([1, 0, 0]) 
                text(
                    text = text_inhalt, 
                    size = text_groesse, 
                    font = "Arial:style=Regular", 
                    halign = "center", 
                    valign = "center"
                );

    // SCHRITT 5: Begrenzungsschnitt ganz unten fuer ein flaches Druckbett
    // Schneidet den untersten Millimeter ab, da die Ecken am Boden durch Minkowski rund geworden waeren.
    translate([-50, -50, -50])
        cube([breite + 100, tiefe + 200, 50]);
}