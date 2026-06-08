// ==========================================
// --- STEUERUNG (Welches Teil drucken?) ---
// ==========================================
drucke_rahmen = 1; // 1 = Rahmen anzeigen, 0 = ausblenden
drucke_haube  = 1   ; // 1 = Haube anzeigen,  0 = ausblenden

// HIER den Abstand für die Vorschau-Zeichnung einstellen:
// (z. B. 40 für die Explosionsansicht, 0 für den Passungstest)
abstand_zeichnung = 40; 

// ==========================================
// --- PARAMETER (Garantiert passend für Busch-Jaeger) ---
// ==========================================
// Der Steckdosenrahmen ist 81x81mm. 86mm Innenraum bietet perfekt Luft.
innen_breite = 86;   
innen_hoehe = 86;   
innen_tiefe = 55;    

wand = 3.0;              // Standard-Wandstärke der Haube (vorne, hinten, oben)
rahmen_staerke = 4.0;    // JETZT EINSTELLBAR: Die Dicke der Grundplatte vom Rahmen
flansch = 15;            // Breite der Grundplatte am Rahmen
toleranz = 0.4;          // Spielraum für die Gleitschienen
r_ecke = 5;              // Radius für die abgerundeten Ecken (Rahmen & Haube)

// Maße der Führungsschienen (Clips)
clip_breite = 4.0;   // Breite der Schiene
clip_tiefe  = 8.0;   // Clips stehen 8mm hoch
clip_laenge = (innen_hoehe + (flansch * 2)) * 0.65; // 65% der Gesamthöhe

$fn = 64;            // Hohe Auflösung

// ==========================================
// --- MODULE ---
// ==========================================

// 1. MONTAGE-RAHMEN (Mit runden Ecken und einstellbarer Stärke)
module montagerahmen_neu() {
    b_rahmen = innen_breite + (flansch * 2);
    h_rahmen = innen_hoehe + (flansch * 2);

    difference() {
        // Grundplatte mit abgerundeten Ecken via Minkowski
        translate([0, 0, rahmen_staerke / 2])
        minkowski() {
            cube([b_rahmen - (r_ecke * 2), h_rahmen - (r_ecke * 2), rahmen_staerke - 1], center=true);
            cylinder(r=r_ecke, h=1, center=true);
        }
        
        // Ausschnitt innen bleibt absolut frei für die Steckdose (86x86mm)
        translate([-innen_breite/2, -innen_hoehe/2, -1])
            cube([innen_breite, innen_hoehe, rahmen_staerke + 2]);
        
        // 4x Senkkopf-Schraublöcher
        offset_x = innen_breite/2 + flansch/2;
        offset_y = innen_hoehe/2 + flansch/2;
        for (x = [-offset_x, offset_x]) {
            for (y = [-offset_y, offset_y]) {
                translate([x, y, -1])
                    cylinder(d1=4, d2=8, h=rahmen_staerke + 2);
            }
        }
    }
    
    // Clips: Starten AUF dem Flansch und nutzen dynamisch die 'rahmen_staerke' als Basis
    for (spiegel = [0, 1]) {
        mirror([spiegel, 0, 0]) {
            translate([innen_breite/2 + toleranz, -clip_laenge/2, rahmen_staerke])
                cube([clip_breite, clip_laenge, clip_tiefe]);
        }
    }
}

// 2. DIE SCHUTZHAUBE (Mit durchgehenden Führungsnuten)
module schutzhaube_neu() {
    b_aussen = innen_breite + (wand * 2.0) + ((clip_breite + toleranz) * 2.0);
    h_aussen = innen_hoehe + (wand * 2.0);
    t_aussen = innen_tiefe + wand;
    
    nut_schlitz_laenge = (innen_hoehe / 2.0) + (clip_laenge / 2.0);

    difference() {
        // Außenkörper mit schönen Rundungen
        translate([0, 0, t_aussen / 2.0])
        minkowski() {
            cube([b_aussen - (r_ecke * 2.0), h_aussen - (r_ecke * 2.0), t_aussen - 2.0], center=true);
            cylinder(r=r_ecke, h=2, center=true);
        }
        
        // Innenraum: Bleibt komplett eckig und vollkommen frei (86x86mm)
        translate([-innen_breite/2.0, -innen_hoehe/2.0, -1])
            cube([innen_breite, innen_hoehe, innen_tiefe + 0.1]);
        
        // Die Führungsnuten: Werden jetzt bis zur kompletten Innenhöhe durchgeschoben
        for (spiegel = [0, 1]) {
            mirror([spiegel, 0, 0]) {
                translate([innen_breite/2.0, -innen_hoehe/2.0 - 1.0, -1])
                    cube([clip_breite + (toleranz * 2.0), nut_schlitz_laenge + 1.0, innen_tiefe + 1.0]);
            }
        }
        
        // Belüftung Vorne auf Ganzzahlen umgestellt (Keine Syntaxfehler mehr)
        for (x = [-32 : 8 : 32]) {
            for (z = [12 : 10 : innen_tiefe - 10]) {
                translate([x, h_aussen/2.0 + 1.0, z])
                    rotate([90, 0, 0])
                    cylinder(d=3.5, h=wand + 10.0);
            }
        }
        
        // Belüftung Unten (Ebenfalls saubere Ganzzahlen)
        for (x = [-32 : 8 : 32]) {
            for (y = [-32 : 8 : 32]) {
                translate([x, y, innen_tiefe - 1.0])
                    cylinder(d=3.0, h=wand + 5.0);
            }
        }
    }
}

// ==========================================
// --- AUSGABE ---
// ==========================================
if (drucke_rahmen == 1) {
    color("DarkGreen") 
        montagerahmen_neu();
}

if (drucke_haube == 1) {
    // Berücksichtigt beim Zusammenstecken (Abstand = 0) jetzt auch dynamisch die eingestellte Rahmenstärke
    z_versatz = (drucke_rahmen == 1) ? (abstand_zeichnung + rahmen_staerke) : 0;
    
    translate([0, 0, z_versatz]) 
        color("DarkGreen") 
        schutzhaube_neu();
}