// Halter für 5 Edding 500 Marker mit abgerundeten Außenkanten 
// Einführschrägen, stabiler Bodenplatte und geprägtem Text vorne

$fn = 60; // Höhere Zylinder-Qualität

// Variablen
loch_dm = 21;      // Durchmesser der Löcher
wand_starke = 3;   // Wandstärke zwischen den Löchern und außen
hohe = 40;         // Höhe des eigentlichen Halters
boden = 5;         // Dicke des Bodens unter den Stiften
rundung = 2;       // Radius der Außenrundung in mm
fase_hohe = 2;     // Höhe des Einführtrichters oben
fase_dm = 23;      // Oberer Durchmesser des Trichters

// Variablen für die breite Bodenplatte
platte_hohe = 5;   // 0.5 cm hoch
platte_uberstand = 10; // 1.0 cm Überstand rundherum

// Berechnungen für die Positionen
abstand = loch_dm + wand_starke;
y_versatz = abstand * sin(60); 

// Haupt-Differenz-Block
difference() {
    // Kombinierter Grundkörper (Halter + Bodenplatte)
    union() {
        // 1. Die breite Bodenplatte (unten)
        minkowski() {
            hull() {
                translate([0, 0, 0]) cylinder(d=loch_dm + 2*wand_starke + 2*platte_uberstand - 2*rundung, h=platte_hohe - rundung);
                translate([abstand, 0, 0]) cylinder(d=loch_dm + 2*wand_starke + 2*platte_uberstand - 2*rundung, h=platte_hohe - rundung);
                translate([2*abstand, 0, 0]) cylinder(d=loch_dm + 2*wand_starke + 2*platte_uberstand - 2*rundung, h=platte_hohe - rundung);
                
                translate([abstand/2, y_versatz, 0]) cylinder(d=loch_dm + 2*wand_starke + 2*platte_uberstand - 2*rundung, h=platte_hohe - rundung);
                translate([3*abstand/2, y_versatz, 0]) cylinder(d=loch_dm + 2*wand_starke + 2*platte_uberstand - 2*rundung, h=platte_hohe - rundung);
            }
            sphere(r=rundung);
        }
        
        // 2. Der eigentliche Stifthalter (oben drauf)
        minkowski() {
            hull() {
                translate([0, 0, 0]) cylinder(d=loch_dm + 2*wand_starke - 2*rundung, h=hohe - rundung);
                translate([abstand, 0, 0]) cylinder(d=loch_dm + 2*wand_starke - 2*rundung, h=hohe - rundung);
                translate([2*abstand, 0, 0]) cylinder(d=loch_dm + 2*wand_starke - 2*rundung, h=hohe - rundung);
                
                translate([abstand/2, y_versatz, 0]) cylinder(d=loch_dm + 2*wand_starke - 2*rundung, h=hohe - rundung);
                translate([3*abstand/2, y_versatz, 0]) cylinder(d=loch_dm + 2*wand_starke - 2*rundung, h=hohe - rundung);
            }
            sphere(r=rundung);
        }
    }

    // Löcher für die Stifte (Hauptbohrung)
    translate([0, 0, boden]) cylinder(d=loch_dm, h=hohe + 10);
    translate([abstand, 0, boden]) cylinder(d=loch_dm, h=hohe + 10);
    translate([2*abstand, 0, boden]) cylinder(d=loch_dm, h=hohe + 10);
    
    translate([abstand/2, y_versatz, boden]) cylinder(d=loch_dm, h=hohe + 10);
    translate([3*abstand/2, y_versatz, boden]) cylinder(d=loch_dm, h=hohe + 10);

    // Einführschrägen (Trichter) oben an den Löchern ausschneiden
    translate([0, 0, hohe - fase_hohe]) cylinder(d1=loch_dm, d2=fase_dm, h=fase_hohe + 0.1);
    translate([abstand, 0, hohe - fase_hohe]) cylinder(d1=loch_dm, d2=fase_dm, h=fase_hohe + 0.1);
    translate([2*abstand, 0, hohe - fase_hohe]) cylinder(d1=loch_dm, d2=fase_dm, h=fase_hohe + 0.1);
    
    translate([abstand/2, y_versatz, hohe - fase_hohe]) cylinder(d1=loch_dm, d2=fase_dm, h=fase_hohe + 0.1);
    translate([3*abstand/2, y_versatz, hohe - fase_hohe]) cylinder(d1=loch_dm, d2=fase_dm, h=fase_hohe + 0.1);

    // Textprägung auf der langen Vorderseite (1 mm tief eingerückt)
    // Zentriert vor dem mittleren Zylinder platziert
    translate([abstand, -(loch_dm/2 + wand_starke - 1), hohe / 2]) {
        rotate([90, 0, 0]) { // Text aufrecht an die Wand stellen
            // Erste Zeile: edding
            translate([0, 4, 0])
                linear_extrude(height = 2) // 2 mm Dicke, ragt 1 mm in die Wand
                    text("edding", size = 7, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
            
            // Zweite Zeile: 500
            translate([0, -5, 0])
                linear_extrude(height = 2) 
                    text("500", size = 7, font = "Liberation Sans:style=Bold", halign = "center", valign = "center");
        }
    }
}