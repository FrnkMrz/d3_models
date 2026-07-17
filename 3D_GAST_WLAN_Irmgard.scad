// =========================================================================
// GAST-WLAN IRMGARD - REINER QR-CODE (V6 - Ohne Text & Ohne Center-Platte)
// =========================================================================
// Dieses Skript flacht die unerwünschte Platte in der Mitte des QR-Codes ab,
// indem dieser Bereich aus der Erhebung herausgeschnitten wird.
// =========================================================================

// --- Globale Einstellungen ---
$fn = 60;

// --- Einstellbare Parameter (Maße in Millimeter) ---
qr_bilddatei = "Irmgard_Gast_WLAN QR-Code.png"; // Deine QR-Code-Bilddatei

qr_size = 70;           // Kantenlänge des QR-Codes
base_margin = 5;        // Randabstand um den QR-Code (5mm)
base_thickness = 2.0;   // Dicke der Grundplatte
qr_elevation = 1.0;     // Höhe der überstehenden Pixel

// --- Parameter für das Entfernen der Platte in der Mitte ---
// Falls noch Reste der Platte sichtbar sind, diese Werte leicht erhöhen.
mitte_breite = 25;      // Breite der flachzulegenden Zone in der Mitte (X-Achse)
mitte_laenge = 35;      // Länge der flachzulegenden Zone in der Mitte (Y-Achse)

// --- Berechnete Maße ---
base_size = qr_size + (2 * base_margin); 

// --- Hauptmodell zusammenbauen ---
union() {
    // 1. Die quadratische Grundplatte
    rounded_base(base_size, base_size, base_thickness, 4);

    // 2. Der QR-Code mit freigestellter Mitte
    translate([0, 0, base_thickness]) {
        difference() {
            // Der originale QR-Code
            qr_code_generator();
            
            // Subtraktion: Schneidet die Erhebung in der Mitte weg (wird flach wie die Grundplatte)
            cube([mitte_breite, mitte_laenge, qr_elevation * 3], center = true);
        }
    }
}

// --- Hilfsmodule ---

// Modul für die abgerundete Grundplatte
module rounded_base(w, l, h, r) {
    linear_extrude(height = h) {
        minkowski() {
            square([w - 2*r, l - 2*r], center = true);
            circle(r = r);
        }
    }
}

// Modul zum Importieren und Skalieren des QR-Codes
module qr_code_generator() {
    scale_factor_xy = qr_size / 100;
    
    scale([scale_factor_xy, scale_factor_xy, qr_elevation / 100]) {
        surface(file = qr_bilddatei, center = true, invert = true);
    }
}