// =========================================================================
// PARAMETER - Hier kannst du die Maße flexibel anpassen
// =========================================================================

zahl_text         = "18";   // Die gewünschte Zahl
zahl_hoehe        = 45;     // Gesamthöhe der Zahl in mm
zahl_dicke        = 10;     // Dicke/Tiefe der Ziffern selbst (in mm)

// PARAMETER FÜR DEN VERBINDUNGSBALKEN (UNTERSTRICH)
balken_hoehe      = 10 ;      // Wie hoch der Balken nach oben geht (in mm)
balken_dicke      = 14;     // Tiefe des Balkens nach hinten (in mm)
balken_rundung    = 3;      // Rundungsradius für die Enden des Balkens

// HIER KANNST DU DIE ZAHLEN HÖHER SETZEN (Weniger tief im Balken)
zahl_hoehen_versatz = 2;    // mm, um die die Zahl nach oben aus dem Balken gehoben wird

// DEINE BEWÄHRTEN BERICHNUNGS-WERTE FÜR DIE BREITE
balken_ueberstand_links  = 6;  // mm, wie weit der Balken links übersteht
balken_ueberstand_rechts = 4;  // mm, wie weit der Balken rechts übersteht

// PARAMETER FÜR DAS LOCH AUF DER RÜCKSEITE (DIREKT IM BALKEN)
loch_durchmesser  = 5.8;    // Durchmesser des Befestigungslochs (in mm)
loch_tiefe        = 7.0;    // Tiefe der Aussparung (0.5 cm = 5 mm)

// SCHRIFTART
schrift_art       = "Arial:style=Bold"; 
$fn               = 50;     // Auflösung für alle Rundungen

// =========================================================================
// AUTOMATISCHE BERECHNUNGEN (Basierend auf deinen überarbeiteten Werten)
// =========================================================================

X_links  = -25 - balken_ueberstand_links;
X_rechts =  32 + balken_ueberstand_rechts;

// =========================================================================
// MODELLIERUNG
// =========================================================================

difference() {
    // 1. GRUNDKÖRPER (Zahlen + abgerundeter Balken)
    union() {
        // Die Ziffern "18" - Jetzt flexibel nach oben verschiebbar via Parameter
        translate([0, (balken_hoehe / 2) + zahl_hoehen_versatz, 0])
        linear_extrude(height = zahl_dicke) {
            text(
                text   = zahl_text, 
                size   = zahl_hoehe, 
                font   = schrift_art, 
                halign = "center", 
                valign = "center"
            );
        }
        
        // Der schicke Verbindungsbalken mit abgerundeten Enden
        translate([0, -zahl_hoehe / 2, 0])
        linear_extrude(height = balken_dicke) {
            hull() {
                // Linker runder Endpunkt
                translate([X_links + balken_rundung, balken_hoehe / 2])
                    circle(r = balken_rundung);
                // Rechter runder Endpunkt
                translate([X_rechts - balken_rundung, balken_hoehe / 2])
                    circle(r = balken_rundung);
            }
        }
    }

    // 2. BEFESTIGUNGSLOCH IN DER RÜCKSEITE
    // Bleibt exakt im mathematischen Zentrum der "18"
    translate([0, -zahl_hoehe / 2 + balken_hoehe / 2, -0.1])
        cylinder(r = loch_durchmesser / 2, h = loch_tiefe + 0.1);
}