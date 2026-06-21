# Project Notes

## M32 / Bosch GAS 35 adapter

- Source mesh used for the current OpenSCAD wrapper: `/Users/frank/Downloads/m32.stl`
- Current editable wrapper: `m32_import.scad`
- Measured STL bounds: about `45.0 x 39.6 x 84.4 mm`
- Mesh check from the X2D session: binary STL, about 17,412 triangles, closed mesh, no obvious open edges
- Bosch GAS 35 hose target used so far: nominal `35 mm`
- Current OpenSCAD clearance: `0.6 mm`, so `target_socket_diameter = 35.6 mm`
- Important fit note: the smaller original inner diameter should stay unchanged, not scale with the Bosch side
- Smaller original inner diameter estimate: about `30.8 to 30.9 mm`

The current safe default in `m32_import.scad` is:

```scad
variant = "original";
```

Avoid using `variant = "scale_bosch35"` for the final adapter if the smaller connector must remain at its original size. That variant scales the whole imported mesh.

For the next design pass, modify only the Bosch hose socket side and keep the smaller connector geometry unchanged.
