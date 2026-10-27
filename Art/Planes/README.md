# Planes

Six combat space planes in the fleet's anime/Starsector toon style. This is the second set: none of them has wings or an aircraft silhouette. Each one is built around its weapons and thrusters as modular sci-fi hardware. They range from about 5 to 18 m long, against 59 m for a frigate (`render_scale.png` shows them next to Cargo_Frigate_Container). The nose points to -Y in Blender.

Colour schemes:
- **Fighters:** grey base (`Cargo_Grey`, `Cargo_Grey2`), blue accents (`Cargo_Blue`) and white markings (`Mil_White`).
- **Bombers and the missile boat:** dark grey base (`War_Grey`, `War_Grey2`), dark blue accents (`War_Blue`) and magenta markings (`Civ_Magenta`). The missile boat uses the bomber scheme because it is a heavy strike craft.

`Assets/Models/Planes/Planes.blend` holds all six as separate collections, each with its own root `Plane_<Name>_Root`. Each plane is also exported to its own `Plane_<Name>.fbx` (same export settings as the other ships; materials are set up by `ToonMaterialPostprocessor`).

| Plane | Role | Crew | Size (L × W × H) | Triangles | Design |
|---|---|---|---|---|---|
| `Plane_FighterHeavy` (F-11) | Firepower fighter | 1 | 13.7 × 6.4 × 3.7 m | ~3.7k | An armoured cockpit capsule riding a spinal railgun that sticks out 6 m ahead, with charge coils and a glowing core. Two triple-barrel rotary cannons sit on side arms with ammo drums, and a square block of four engines is at the back |
| `Plane_FighterAgile` (F-12) | Agility fighter | 1 | 5.4 × 6.6 × 6.3 m | ~5.2k | Gyroscope layout: a compact octagonal cockpit core inside a 6 m thruster ring. Four thruster pods on the ring each carry an outward vectoring nozzle for omnidirectional moves. Twin guns sit under the core |
| `Plane_FighterMissile` (F-21) | Missile fighter | 2 | 11.8 × 7.1 × 4.7 m | ~4.1k | A tall hexagonal hull with the pilot's visor up front and the weapons officer in a raised dorsal dome. An X-frame carries four revolver missile drums with six tubes each. It has a sensor probe on the nose and two stacked engines |
| `Plane_Bomber` (B-31) | Bomber | 1 | 13.8 × 4.6 × 4.0 m | ~5.0k | A cockpit pod and engine block clamped on top of a 12 m torpedo, the craft's main weapon and spine. Angled armour plates shield the sides, and there is a point-defence turret underneath |
| `Plane_BomberHeavy` (B-32) | Heavy bomber | 3 | 18.1 × 8.9 × 3.3 m | ~9.2k | A rectangular frame: twin hull booms joined by a front bridge (pilot and bombardier, with a glass blister) and an aft engine block with radiators. Between the booms is an open rack of eight bombs. Two dorsal turrets cover the rear (one with the gunner's dome) and a ventral turret sits under the bridge |
| `Plane_MissileBoat` (M-41) | Missile boat | 2 | 14.0 × 7.6 × 5.8 m | ~4.7k | Asymmetric: a launcher block with 12 forward tubes and 15 vertical cells, a two-seat cockpit sponson on the right, and a sensor housing with a dish and a long sensor boom on the left. Two anti-ship missiles hang below, and radiators sit over the three engines |

Renders: `render_lineup.png` shows all six (fighters in front, bombers behind), `render_scale.png` compares them with a frigate, and `render_<name>_{hero,side,rear,top}.png` shows each one.
