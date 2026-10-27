# Planes (first attempt)

The first, more aircraft-like set of combat planes. It was superseded by the sci-fi set in `Art/Planes/` and is kept here for reference. Files are in `Assets/Models/Planes/Planes_first_attempt/` with the same names and roots as the current set.

Six combat space planes in the fleet's anime/Starsector toon style. They range from about 12 to 22 m long including guns and ordnance, against 59 m for a frigate (`render_scale.png` shows them next to Cargo_Frigate_Container). The nose points to -Y in Blender.

Colour schemes:
- **Fighters:** grey base (`Cargo_Grey`, `Cargo_Grey2` belly), blue accents (`Cargo_Blue`) and white markings (`Mil_White`).
- **Bombers and the missile boat:** dark grey base (`War_Grey`, `War_Grey2` belly), dark blue accents (`War_Blue`) and magenta markings (`Civ_Magenta`). The missile boat uses the bomber scheme because it is a heavy strike craft.

`Planes.blend` holds all six as separate collections, each with its own root `Plane_<Name>_Root`. Each plane is also exported to its own `Plane_<Name>.fbx` (same export settings as the other ships; materials are set up by `ToonMaterialPostprocessor`).

| Plane | Role | Crew | Length | Triangles | Features |
|---|---|---|---|---|---|
| `Plane_FighterHeavy` (F-11) | Firepower fighter | 1 | ~16 m | ~3.1k | Twin heavy chin cannons reaching past the nose, two wing gun pods, intakes beside the cockpit, twin engines and canted fins |
| `Plane_FighterAgile` (F-12) | Agility fighter | 1 | ~12 m | ~3.4k | Slim body, canards, swept wings with vernier thruster pods on the tips, RCS blocks, a main engine plus two auxiliary engines, twin light guns |
| `Plane_FighterMissile` (F-21) | Missile fighter | 2 (tandem) | ~17 m | ~5.0k | Tandem canopy, radar nose, delta wings with three missiles under each wing, quad-tube launchers on the wing tips, two belly missiles |
| `Plane_Bomber` (B-31) | Bomber | 1 | ~19 m | ~5.0k | Broad armoured body, an 8 m torpedo slung under the belly, a bomb under each stub wing, nose gun, twin engines |
| `Plane_BomberHeavy` (B-32) | Heavy bomber | 3 (pilot and bombardier side by side, plus a gunner) | ~22 m | ~9.5k | Glass bombardier nose, a manned dorsal bubble turret, a tail turret and a ventral turret (all covering the rear), an open bomb bay with three bombs, four torpedoes under the wings, four engines |
| `Plane_MissileBoat` (M-41) | Missile boat | 2 (tandem) | ~21 m | ~4.5k | Two launcher pods with 12 vertical cells each (armed cells in magenta) and six forward tubes each, two large anti-ship missiles under the pods, a radar dome and three engines |

Renders: `render_lineup.png` shows all six (fighters in front, bombers behind), `render_scale.png` compares them with a frigate, and `render_<name>_{hero,side,rear,top}.png` shows each one.
