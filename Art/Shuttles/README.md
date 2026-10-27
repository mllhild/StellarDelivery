# Shuttles

Five small shuttles in the fleet's anime/Starsector toon style. They range from about 14 to 28 m long, against 59 m for a frigate (`render_scale.png` shows them next to Cargo_Frigate_Container). Each one uses the colours of the group it belongs to. The nose points to -Y in Blender.

`Assets/Models/Shuttles/Shuttles.blend` holds all five as separate collections, each with its own root `Shuttle_<Name>_Root`. Each shuttle is also exported to its own `Shuttle_<Name>.fbx` (same export settings as the other ships; materials are set up by `ToonMaterialPostprocessor`).

| Shuttle | Group and colours | Length | Triangles | Features |
|---|---|---|---|---|
| `Shuttle_Military` (SH-05) | Military: dark grey, dark blue, white markings, faction emblem | ~22 m | ~7.2k | Angular dropship with a glass cockpit, dorsal and chin turrets, wing-tip engine pods, twin canted fins, side doors, rear ramp and landing skids |
| `Shuttle_Luxury` (*ORCHID*) | Wealthy civilian: white, light blue, magenta | ~19 m | ~18k | Sleek teardrop hull with a large glass canopy, a glass sky dome, a row of panorama windows, a magenta swoosh, nacelles on swept pylons, a V-tail and a lit halo ring at the stern. One discreet ventral turret slot |
| `Shuttle_Rundown` (*LUCKY 7*) | Poor civilian: faded teal over grime, with rust and mismatched patch panels | ~17 m | ~4.2k | Patchwork hull with bolted-on plates, a grille over the cockpit window, two mismatched engines, a strapped-on fuel tank, a roof cargo pod, exposed pipes, a bent antenna, a single working nav light, a pink neon name and an improvised roof gun |
| `Shuttle_Bus` (ROUTE 7) | Poor civilian: faded teal "ORBITAL TRANSIT" livery with patches | ~28 m | ~10k | Long boxy people mover with rows of windows (some lit, some boarded up), a side door with a step, a ROUTE 7 sign, a roof rack piled with luggage, three mismatched engines, a strapped-on booster, landing legs and an improvised rear roof gun |
| `Shuttle_Drone` (SV-01) | Automated, explorer colours: white, navy, orange | ~14 m | ~8.6k | No cockpit. A lidar dome on the nose, a camera ball under the chin, a dorsal dish, side phased arrays, an orange sensor ring with four sensor pods, two forward sensor booms, an antenna cluster, RCS blocks, an ion engine and a small ventral turret |

Renders: `render_lineup.png` shows all five, `render_scale.png` compares them with a frigate, and `render_<name>_{hero,side,rear,top}.png` shows each one.
