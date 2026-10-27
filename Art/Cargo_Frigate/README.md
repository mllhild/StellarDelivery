# Cargo_Frigate

Cargo ships that match Frigate_Explorer in size (about 59 m long), built for efficient transport and fast loading and unloading in the fleet's anime/Starsector toon style. All four variants share one hull: a grey armoured bow with the bridge, a cargo spine in the middle and an engine block at the stern with two main engines and radiator fins. Accents are blue, and the markings (registration, cargo type and stripes) are white. Each variant keeps turret slots for self-defence, like the explorers. The nose points to -Y in Blender.

The source `.blend` holds all four variants as separate collections, each with its own root `Cargo_Frigate_<Variant>_Root`. Each variant is also exported to its own `.fbx` in `Assets/Models/Cargo_Frigate/` (same export settings as the other ships; materials are set up by `ToonMaterialPostprocessor`). New materials: `Cargo_Grey`, `Cargo_Grey2`, `Cargo_Blue` and `Tank_Red`.

| Variant | Registration | Triangles | Cargo section |
|---|---|---|---|
| Container | CF-11 | ~6k | Stacked 12 m containers in blue rack frames, with a white gantry crane on rails over the stacks for loading and unloading. |
| Bulk | CF-12 | ~7k | A row of holds under blue hatch covers, with one hold open to show its ore load, and a swinging conveyor boom for unloading. |
| Tanker | CF-13 | ~9k | Red fuel tanks (the red marks them as tanks) with white bands, held in blue frames and linked by pipes to a loading manifold. |
| Carrier | CF-14 | ~12k | An enclosed RO-RO vehicle hangar with a side ramp and rovers, plus an open cradle deck where shuttles sit in clamps in numbered bays. |

Renders: `render_variants.png` shows all four side by side, and `render_<variant>_{hero,side,rear,top}.png` shows each one.
