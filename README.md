# 3D Models

Dieses Repo sammelt meine OpenSCAD-Dateien für persönliche 3D-Druckprojekte.

Der Fokus liegt auf den editierbaren Konstruktionsdateien (`.scad`). Exportierte Druckdateien wie STL, 3MF, G-Code und Bambu-G-Code werden hier bewusst nicht gespeichert, weil sie meist aus den OpenSCAD-Dateien neu erzeugt werden können und schnell groß werden.

## Projekte

| Datei | Zweck |
| --- | --- |
| `Bithalter.scad` | Parametrischer Hex-Bit-Halter mit Wandmontage und Beschriftung |
| `hex_bit_holder_60.scad` | Kompakter Hex-Bit-Halter mit 60 Plätzen und Schraublöchern |
| `edding500.scad` | Halter für fünf Edding-500-Marker |
| `Haube_für_Repater.scad` | Schutzhaube mit Montagerahmen, passend für einen Steckdosen-/Repeater-Bereich |
| `Universal_atapter_Staubsauger.scad` | Universeller Staubsauger-Adapter mit rechteckigem Einlass, Trichter und 90-Grad-Bogen |
| `absauger_tellerscheifer.scad` | Staubabsaug-Adapter für einen Tellerschleifer mit Staubsaugeranschluss |
| `m32_import.scad` | OpenSCAD-Wrapper für ein importiertes M32-STL, aktuell für Bosch-GAS-35-Anpassungen vorbereitet |

Weitere Messwerte und Arbeitsnotizen stehen in [`PROJECT_NOTES.md`](PROJECT_NOTES.md).

## Arbeitsweise

1. `.scad`-Datei in OpenSCAD öffnen.
2. Parameter oben in der Datei anpassen.
3. Vorschau prüfen.
4. Rendern und als STL oder 3MF exportieren.
5. In Bambu Studio, OrcaSlicer oder einem anderen Slicer vorbereiten.
6. Nur die geänderte `.scad`-Datei und wichtige Notizen committen.

## Was ins Repo gehört

- OpenSCAD-Quelldateien (`*.scad`)
- kurze Projektnotizen, Maße und Druckhinweise
- README- und Dokumentationsdateien

## Was nicht ins Repo gehört

- exportierte STL-Dateien (`*.stl`)
- 3MF-Dateien (`*.3mf`)
- G-Code und Bambu-G-Code (`*.gcode`, `*.bgcode`)
- temporäre Dateien

Diese Dateien sind in `.gitignore` ausgeschlossen.

## Hinweise

Viele Modelle sind parametrisch aufgebaut. Wenn ein Teil nicht passt, ist meistens der beste Weg, zuerst die Maße am echten Objekt zu messen und dann die Parameter im Kopfbereich der jeweiligen `.scad`-Datei anzupassen.

Bei Steck-, Schlauch- und Schraubverbindungen immer etwas Spiel einplanen. Gedruckte Innenmaße werden je nach Material, Drucker, Düse und Slicer-Einstellungen oft etwas enger als konstruiert.
