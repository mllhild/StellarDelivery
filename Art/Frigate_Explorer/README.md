# Frigate_Explorer

Exploration / cargo frigate, anime style with Starsector-like top-down silhouette.

- About 59 m long including the bow sensor prongs (hull about 48 m), 28 m wide across the wing tips. 1 Blender unit = 1 m.
- About 9.6k triangles (outline shells included), 171 objects under `Frigate_Root`.
- Source: `Assets/Models/Frigate_Explorer/Frigate_Explorer.blend`. Unity export: `Frigate_Explorer.fbx` (Forward -Z, Up Y, transforms baked, modifiers applied).

## Look
- Toon shader node group `AnimeToon` (EEVEE): 3 hard light bands (cool shadow tint, mid, lit), rim light and a hard specular spot.
- Outlines: inverted hull (Solidify modifier with flipped normals and an `Outline` material that culls back faces). The shells are baked into the FBX, so outlines also work in Unity with any shader that culls back faces.
- The Blender toon nodes don't carry over to Unity. Each material also has a Principled BSDF (Cycles output), so the FBX keeps base colours and emission.

## Layout
Arrowhead bow with twin sensor prongs and a sensor dome underneath, a stepped bridge tower with a mast, a sensor dish, a dorsal container rack, two side cargo pods with hatches, three main engines and two pod engines, canted fins, and nav lights.
