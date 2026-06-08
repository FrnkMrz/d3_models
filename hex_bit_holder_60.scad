// ============================================================
//  Hex Bit Holder — 10 × 6 = 60 Löcher, Schraubenhalterung
//  Basierend auf Original "Hex Bit Holder for 95 pieces" von maxv
// ============================================================

// --- Parameter ---

cols        = 10;        // Spalten
rows        = 6;         // Reihen
pitch       = 14;        // Abstand Lochzentrum zu Lochzentrum (mm)
                         // Original ≈ 10 mm → hier 14 mm für mehr Platz

hex_af      = 6.6;       // Hex-Loch Schlüsselweite across flats (1/4" = 6.35mm + Spiel)
hole_depth  = 33;        // Tiefe der Bit-Aufnahme (mm)
chamfer     = 1.5;       // Einführ-Fase am Locheingang

wall_xy     = (pitch - hex_af) / 2;  // Wandstärke zwischen Löchern ≈ 3.7 mm
margin      = 8;         // Randabstand von Löchern zu Gehäusekante

body_depth  = hole_depth + 4;  // Gesamt-Gehäusetiefe (= Lochtiefe + Rückwand)
body_w      = cols * pitch + 2 * margin;
body_h      = rows * pitch + 2 * margin;

// Schrauben (M4 Senkkopf)
screw_d     = 4.5;       // Schraubenlochdurchmesser
csk_d       = 9.0;       // Senkkopf-Durchmesser
csk_depth   = 4.5;       // Senkkopf-Tiefe
screw_margin = 5;        // Abstand Schraubenloch von Gehäusekante

// Pegboard 25mm Raster — optionale zweite Lochreihe
pegboard_pitch = 25;

$fn = 36;

// ============================================================
//  Hilfsfunktionen
// ============================================================

// Hex-Prismus (across flats = af, Tiefe = d)
module hex_prism(af, d) {
    rotate([0, 0, 30])
    cylinder(h = d, r = (af / 2) / cos(30), $fn = 6);
}

// Senkkopf-Schraubenloch (von vorne, Richtung -Z)
module countersunk_hole(depth) {
    union() {
        cylinder(h = depth + 0.1, d = screw_d);
        translate([0, 0, depth - csk_depth])
            cylinder(h = csk_depth + 0.1, d1 = screw_d, d2 = csk_d);
    }
}

// ============================================================
//  Schraubenhalterung (4 Ecken + Pegboard-Reihe oben/unten)
// ============================================================

module screw_holes() {
    off = screw_margin;
    // 4 Eck-Schraubenlöcher
    for (x = [off, body_w - off])
        for (y = [off, body_h - off])
            translate([x, y, body_depth - csk_depth])
                countersunk_hole(body_depth);

    // Zusätzliche Pegboard-Löcher (25mm Raster, oben und unten)
    peg_y_bottom = off;
    peg_y_top    = body_h - off;
    peg_x_start  = margin;
    for (i = [0 : floor((body_w - 2*margin) / pegboard_pitch)])
        for (py = [peg_y_bottom, peg_y_top]) {
            px = peg_x_start + i * pegboard_pitch;
            if (px > off + 1 && px < body_w - off - 1)  // nicht über Eck-Löcher
                translate([px, py, body_depth - csk_depth])
                    countersunk_hole(body_depth);
        }
}

// ============================================================
//  Haupt-Modell
// ============================================================

difference() {
    // Grundkörper
    cube([body_w, body_h, body_depth]);

    // Hex-Bit Löcher (von vorne, Richtung -Z)
    for (col = [0 : cols - 1])
        for (row = [0 : rows - 1]) {
            x = margin + col * pitch + pitch/2;
            y = margin + row * pitch + pitch/2;
            translate([x, y, body_depth - hole_depth]) {
                // Einführ-Fase
                translate([0, 0, hole_depth - chamfer])
                    cylinder(h = chamfer + 0.1,
                             r1 = hex_af/2 / cos(30) + chamfer,
                             r2 = hex_af/2 / cos(30),
                             $fn = 6);
                // Hex-Loch
                hex_prism(hex_af, hole_depth);
            }
        }

    // Schraubenlöcher
    screw_holes();
}

// ============================================================
//  Info (wird in OpenSCAD Console ausgegeben)
// ============================================================
echo(str("Gehäuse: ", body_w, " × ", body_h, " × ", body_depth, " mm"));
echo(str("Löcher:  ", cols, " × ", rows, " = ", cols*rows));
echo(str("Abstand: ", pitch, " mm Mitte-Mitte  (Wandstärke: ", wall_xy, " mm)"));
