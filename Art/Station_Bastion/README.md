# Station_Bastion

A huge, non-rotating, pristine military station: the flag base of the faction whose emblem is shown in `faction_emblem_reference.png`. It uses the emblem's palette: ice white armour, deep faction blue, dark navy trim and ice-blue accents. All lights and contrast highlights are magenta or red.

- About 540 × 740 × 570 m including the command tower, keel spire and outrigger pads. 1 Blender unit = 1 m.
- About 119k triangles (outline shells included), 418 objects under `Bastion_Root`.
- Source: `Assets/Models/Station_Bastion/Station_Bastion.blend`. Unity: `Station_Bastion.fbx` (same export settings as the ships). New materials: `Mil_White`, `Mil_Blue`, `Mil_Deep`, `Mil_Ice`, `Mil_Gun` and `Light_Magenta`.

## Berths
| Berth | Type | Size | Notes |
|---|---|---|---|
| Main hangar, pad A1 | Capital hangar | 300 × 118 m pad in a 330 × 150 × 72 m hangar | Elite-style letterbox slot (136 × 46 m) in the bow. The slot frame has magenta and red guide lights. Inside: ribbed white and blue lining, cyan ceiling lights, a magenta centre guide line, three gantry cranes and six docking clamps. The full faction emblem sits above the slot. |
| Bays B1, B2, C1, C2 | Cruiser hangars | 212 × 76 m pads in 249 × 84 × 50 m bays | Two stacked bays in each wing block, each with a lit mouth frame and a gantry. |
| Pads C1, C2 | Cruiser pads | 212 × 80 m | On outrigger arms on both sides of the rear section, each with a control tower. |
| Pads D1–D4 | Destroyer pads | 120 × 62 m | On top of the wing blocks. |
| Pads 01–10 | Frigate pads | 76 × 46 m | Six on the forward deck and four on the rear deck around the command tower. |

The pads are clean military takes on Elite Dangerous pads: a dark checker deck, white and ice-blue borders, magenta corner chevrons, a simplified emblem (diamond, blades and three stars) at the centre, and working magenta and red edge lights on every pad.

## Faction emblem
The emblem is built as geometry (`emblem()` in the `ship_lib.py` text block), so it needs no textures in Unity. It comes in three variants:
- **Full emblem on its square flag,** with the diagonal stripes: on the wing and rear flanks.
- **Full emblem without the flag:** above the main slot.
- **Simplified emblem** (ring, upper blades, diamond and stars): on four vertical banners around the command tower.
- **Mark** (diamond, blades and stars): on every pad.

## Military detailing
- A command tower about 310 m above the deck, with a bridge, sensor rings, a dish and a mast with a magenta beacon.
- A keel spire underneath with a red tip light.
- 34 twin-barrel turrets on the top and bottom edges.
- VLS missile hatches on the rear deck.
- Four shield-emitter pylons with magenta tips.
- Armour panels, running lights in alternating magenta and red, and a rear reactor with radiator fins.

The renders show the capital ship in the main hangar, cruisers in bays B1 and C2 and on pad C1, destroyers on D1 and D4, and frigates on pads 01, 04 and 08.
