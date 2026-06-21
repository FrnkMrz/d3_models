// --- PARAMETER ---
breite_einlass = 80;   // Die lange Seite oben
tiefe_einlass = 40;     // Die kurze Seite oben
wand = 2.5;             // Wandstärke
d_sauger = 35;          // Innendurchmesser Schlauch
l_kragen = 30;          // 1 cm Rand oben am Schleifer
l_trichter = 20;        // Länge des Trichters nach unten
l_hals = 10;            // NEU: 1 cm gerades Rohr zwischen Trichter und Bogen
r_bogen = 30;           // Radius des Knicks
l_verlaengerung = 80;   // 5 cm Rohr am Ende

$fn = 64; 

// Berechnete Maße für die Hülle
d_aussen = d_sauger + (wand * 2);
d_innen = d_sauger;

module absaugadapter_final_fix() {
    difference() {
        // --- AUSSENHÜLLE ---
        union() {
            // 1. Der gerade Kragen oben
            translate([-breite_einlass/2, -tiefe_einlass/2, 0])
                cube([breite_einlass, tiefe_einlass, l_kragen]);
            
            // 2. Der Trichter (geht bis Z = -30)
            hull() {
                translate([-breite_einlass/2, -tiefe_einlass/2, 0.1])
                    cube([breite_einlass, tiefe_einlass, 0.1]);
                
                translate([0, 0, -l_trichter])
                    cylinder(d = d_aussen, h = 0.1);
            }

            // 3. NEU: Das gerade Zwischenstück (Hals)
            // Geht von Z = -30 bis Z = -40
            translate([0, 0, -l_trichter - l_hals])
                cylinder(d = d_aussen, h = l_hals);

            // 4. Der 90-Grad-Bogen (nach rechts)
            // Er setzt jetzt am Ende des Halses an (Z = -40)
            translate([r_bogen, 0, -l_trichter - l_hals]) 
                rotate([-90, 0, 180]) 
                rotate_extrude(angle = 90) 
                translate([r_bogen, 0, 0]) 
                circle(d = d_aussen);

            // 5. Die 5 cm Rohrverlängerung
            // Startet am Ende des Bogens (Z = -40 - 30 = -70)
            translate([r_bogen, 0, -l_trichter - l_hals - r_bogen])
                rotate([0, 90, 0])
                cylinder(d = d_aussen, h = l_verlaengerung);
        }

        // --- INNENRAUM (Luftkanal zum Abziehen) ---
        union() {
            // Kragen innen
            translate([-(breite_einlass/2 - wand), -(tiefe_einlass/2 - wand), -1])
                cube([breite_einlass - (wand * 2), tiefe_einlass - (wand * 2), l_kragen + 2]);
            
            // Trichter innen
            hull() {
                translate([-(breite_einlass/2 - wand), -(tiefe_einlass/2 - wand), 0.2])
                    cube([breite_einlass - (wand * 2), tiefe_einlass - (wand * 2), 0.1]);
                
                translate([0, 0, -l_trichter - 0.1])
                    cylinder(d = d_innen, h = 0.1);
            }

            // Hals innen
            translate([0, 0, -l_trichter - l_hals - 0.1])
                cylinder(d = d_innen, h = l_hals + 0.2);

            // Bogen innen
            translate([r_bogen, 0, -l_trichter - l_hals]) 
                rotate([-90, 0, 180]) 
                rotate_extrude(angle = 90) 
                translate([r_bogen, 0, 0]) 
                circle(d = d_innen);

            // Verlängerung innen
            translate([r_bogen - 0.1, 0, -l_trichter - l_hals - r_bogen])
                rotate([0, 90, 0])
                cylinder(d = d_innen, h = l_verlaengerung + 1);
        }
    }
}

// Modell rendern
absaugadapter_final_fix();
