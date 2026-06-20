// Parametrischer Clip-Stopfen fuer STEMA Bordwand
// SPREIZDUEBEL-PRINZIP (Perfekt fuer PETG!)
// Maßgeschneidert: Loch 25.0mm, Blech 1.5mm, Kappe 30.6mm

/* [Gemessene Dimensionen] */
kappen_durchmesser = 30.6; 
kappen_hoehe = 2.5;        
loch_durchmesser = 25.0;   
bordwand_staerke = 1.6;    

/* [Design Details] */
kappen_radius = 1.6; 
stopfen_tiefe = 8.0; // Etwas kuerzer, damit es knackig sitzt
wand_staerke = 1.8;  // Genug Fleisch fuer Stabilität, flexibel genug zum Biegen

/* [Clip Parameter] */
// Wie weit die Rastnase hinter dem Blech uebersteht
clip_uebermass = 0.3;  
// Breite der Schlitze, die den Kern flexibel machen
schlitz_breite = 2.0;  

/* [Aufloesung] */
$fn = 120;                 

module generiere_druckoptimierte_kappe(d, h, r) {
    rotate_extrude() {
        union() {
            translate([0, r])
                square([d/2, h - r]);
            square([(d/2) - r, h]);
            translate([(d/2) - r, r])
                circle(r = r);
        }
    }
}

module generiere_clip_stopfen() {
    // 1. Kappe (unten rund, oben flach fuer das Bett)
    generiere_druckoptimierte_kappe(d = kappen_durchmesser, h = kappen_hoehe, r = kappen_radius);
    
    // 2. Flexibler Clip-Kern
    translate([0, 0, kappen_hoehe]) {
        difference() {
            // Hauptkoerper aus zwei Teilen: Grundbolzen + Rastnase am Ende
            union() {
                // Hauptbolzen (mit 0.3mm Spielraum zum Loch)
                cylinder(d = loch_durchmesser - 0.3, h = stopfen_tiefe);
                
                // Die Rastnase sitzt exakt nach der Blechdicke (1.5mm)
                // Schraege nach unten, damit man es leichter reindruecken kann
                translate([0, 0, bordwand_staerke])
                    cylinder(d1 = loch_durchmesser + (clip_uebermass * 2), d2 = loch_durchmesser - 0.6, h = stopfen_tiefe - bordwand_staerke);
            }
            
            // Innen hohl machen fuer die Flexibilitaet
            translate([0, 0, -0.1])
                cylinder(d = loch_durchmesser - 0.3 - (2 * wand_staerke), h = stopfen_tiefe + 0.2);
            
            // Kreuzschlitz ausschneiden (X-Achse)
            translate([-schlitz_breite/2, -loch_durchmesser, -0.1])
                cube([schlitz_breite, loch_durchmesser * 2, stopfen_tiefe + 0.2]);
                
            // Kreuzschlitz ausschneiden (Y-Achse)
            translate([-loch_durchmesser, -schlitz_breite/2, -0.1])
                cube([loch_durchmesser * 2, schlitz_breite, stopfen_tiefe + 0.2]);
        }
    }
}

generiere_clip_stopfen();