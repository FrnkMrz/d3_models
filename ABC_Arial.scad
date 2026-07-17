// =========================================================================
// PARAMETER - Hier kannst du die Maße flexibel anpassen
// =========================================================================

buchstaben_hoehe    = 8;   // Exakte Höhe des Buchstabens (in mm)
buchstaben_staerke  = 1.0; // Dicke/Stärke für den 3D-Druck (1.0 mm)

// ABSTÄNDE AUF DEM DRUCKBETT
abstand_x           = 12;  // Horizontaler Abstand von Buchstabe zu Buchstabe
abstand_y           = 15;  // Vertikaler Abstand zwischen den Reihen

// Auflösung für Rundungen bei geschwungenen Buchstaben
$fn                 = 40;  
schrift_art         = "Arial:style=Bold"; 

// Das komplette Alphabet als Liste
alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

// =========================================================================
// BERECHNUNGEN & SCHLEIFE FOR 4 REIHEN
// =========================================================================

anzahl_pro_reihe = 7; // 4 Reihen: 3x7 + 1x5 = 26 Buchstaben

for (i = [0 : len(alphabet) - 1]) {
    // Berechne die aktuelle Reihe (0 bis 3)
    reihe = floor(i / anzahl_pro_reihe);
    
    // Berechne die aktuelle Spalte innerhalb der Reihe
    spalte = i % anzahl_pro_reihe;
    
    // Berechne die exakten Koordinaten auf dem Druckbett
    pos_x = spalte * abstand_x;
    // Reihe 0 ist oben, Reihe 3 unten (Y-Wert sinkt pro Reihe)
    pos_y = -reihe * abstand_y; 

    // Platziere und extrudiere jeden Buchstaben einzeln
    translate([pos_x, pos_y, 0]) {
        linear_extrude(height = buchstaben_staerke) {
            text(
                text   = alphabet[i], 
                size   = buchstaben_hoehe, 
                font   = schrift_art, 
                halign = "center", 
                valign = "center"
            );
        }
    }
}