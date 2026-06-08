// ==========================================
// Staubabsaug-Adapter für Bosch Tellerschleifer
// Perfekt fluchtender Übergang ohne Stufen
// ==========================================

/* [Globale Einstellungen] */
// Höhere Werte liefern rundere Rohre, verlängern aber die Rechenzeit
$fn = 100; 

// Wandstärke des Adapters in mm
wandstaerke = 3.0;

/* [Abmessungen Schleifer-Anschluss] */
// Innendurchmesser des Adapters (wird über den Stutzen gesteckt)
schleifer_innen = 27.40;
// Länge des geraden, senkrechten Anschlusses am Schleifer
schleifer_laenge = 25.0;

/* [Abmessungen Übergangstrichter] */
// Länge des Trichters (wird breiter und gleitet in den Knick über)
trichter_laenge = 15.0;

/* [Abmessungen Staubsauger-Anschluss] */
// Innendurchmesser des Adapters (Staubsaugerrohr kommt HINEIN)
sauger_innen = 34.80;
// Länge des abgewinkelten Anschlusses für den Staubsauger
sauger_laenge = 30.0;

/* [Winkel] */
// Knickwinkel in Grad am oberen Ende des Trichters
knick_winkel = 15.0;

// Berechneter Außendurchmesser für das Staubsauger-Ende
sauger_aussen = sauger_innen + (2 * wandstaerke);

// Berechneter Versatz basierend auf dem Knickwinkel für perfekten Übergang
versatz_y = sin(knick_winkel) * (trichter_laenge / 2);

// ==========================================
// Hauptprogramm (Konstruktion)
// ==========================================

difference() {
    // 1. AUSSENFORM
    union() {
        // Teil 1: Gerader Schleifer-Anschluss an der Basis
        cylinder(h = schleifer_laenge, d = schleifer_innen + (2 * wandstaerke));
        
        // Teil 2: Der fließende Übergangstrichter (verbindet Basis und Knick stufenlos)
        translate([0, 0, schleifer_laenge])
        hull() {
            cylinder(h = 0.1, d = schleifer_innen + (2 * wandstaerke));
            
            // Die obere Scheibe ist exakt so geneigt und verschoben wie das Folgerohr
            translate([0, -versatz_y, trichter_laenge])
            rotate([knick_winkel, 0, 0])
            cylinder(h = 0.1, d = sauger_aussen);
        }
        
        // Teil 3: Das Staubsaugerrohr (sitzt ohne Lücke oder Stufe auf dem Trichter)
        translate([0, -versatz_y, schleifer_laenge + trichter_laenge])
        rotate([knick_winkel, 0, 0])
        cylinder(h = sauger_laenge, d = sauger_aussen);
    }

    // 2. INNENFORM (Hohlraum für den Luftstrom)
    union() {
        // Kanal: Schleifer-Anschluss
        translate([0, 0, -1])
        cylinder(h = schleifer_laenge + 1.1, d = schleifer_innen);
        
        // Kanal: Übergangstrichter innen
        translate([0, 0, schleifer_laenge - 0.05])
        hull() {
            cylinder(h = 0.1, d = schleifer_innen);
            
            translate([0, -versatz_y, trichter_laenge + 0.05])
            rotate([knick_winkel, 0, 0])
            cylinder(h = 0.1, d = sauger_innen);
        }
        
        // Kanal: Geknickter Staubsauger-Anschluss
        translate([0, -versatz_y, schleifer_laenge + trichter_laenge])
        rotate([knick_winkel, 0, 0])
        translate([0, 0, -0.1])
        cylinder(h = sauger_laenge + 0.2, d = sauger_innen);
    }
}