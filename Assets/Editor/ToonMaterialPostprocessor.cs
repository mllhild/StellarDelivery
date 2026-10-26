using System.Collections.Generic;
using UnityEditor;
using UnityEditor.AssetImporters;
using UnityEngine;

// Builds toon materials for ship models imported from Blender.
// For every model under Assets/Models/, each FBX material gets the AnimeToon
// shader with the FBX base colour and emission. A material named "Outline"
// gets the ToonOutline shader. Per-material tweaks match the Blender file.
public class ToonMaterialPostprocessor : AssetPostprocessor
{
    const string ModelsFolder = "Assets/Models/";
    const string ToonShader = "StellarDelivery/AnimeToon";
    const string OutlineShader = "StellarDelivery/ToonOutline";

    struct Tweak
    {
        public Color? shadowTint;
        public float? rim;
        public float? spec;
    }

    // Values from the Blender materials, converted to sRGB.
    static readonly Dictionary<string, Tweak> Tweaks = new Dictionary<string, Tweak>
    {
        { "Hull_Navy", new Tweak { shadowTint = new Color(0.74f, 0.74f, 0.91f), rim = 0.12f } },
        { "Accent_Orange", new Tweak { shadowTint = new Color(0.85f, 0.70f, 0.76f) } },
        { "Accent_Yellow", new Tweak { shadowTint = new Color(0.88f, 0.76f, 0.76f) } },
        { "Cargo_Red", new Tweak { shadowTint = new Color(0.80f, 0.66f, 0.80f) } },
        { "Metal_Dark", new Tweak { shadowTint = new Color(0.80f, 0.80f, 0.91f), rim = 0.1f, spec = 0.3f } },
        { "Glass_Blue", new Tweak { rim = 0.4f, spec = 0.6f } },
        { "Engine_Glow", new Tweak { rim = 0f } },
        { "Light_Red", new Tweak { rim = 0f } },
        { "Light_Green", new Tweak { rim = 0f } },
    };

    public override uint GetVersion() => 1;

    void OnPreprocessMaterialDescription(MaterialDescription description, Material material, AnimationClip[] animations)
    {
        if (!assetPath.StartsWith(ModelsFolder))
            return;

        string name = StripSuffix(description.materialName);

        if (name == "Outline")
        {
            var outline = Shader.Find(OutlineShader);
            if (outline == null) return;
            material.shader = outline;
            if (TryGetLinearColor(description, "DiffuseColor", out var oc))
                material.SetColor("_OutlineColor", oc.gamma);
            return;
        }

        var shader = Shader.Find(ToonShader);
        if (shader == null) return;
        material.shader = shader;

        // FBX colours from Blender are linear; material colour properties expect sRGB.
        if (TryGetLinearColor(description, "DiffuseColor", out var baseColor))
            material.SetColor("_BaseColor", baseColor.gamma);

        if (description.TryGetProperty("DiffuseColor", out TexturePropertyDescription tex) && tex.texture != null)
            material.SetTexture("_BaseMap", tex.texture);

        if (TryGetLinearColor(description, "EmissiveColor", out var emission) && emission.maxColorComponent > 0f)
        {
            float strength = description.TryGetProperty("EmissiveFactor", out float f) ? f : 1f;
            material.SetColor("_EmissionColor", emission.gamma);
            material.SetFloat("_EmissionStrength", strength);
        }

        if (Tweaks.TryGetValue(name, out var t))
        {
            if (t.shadowTint.HasValue) material.SetColor("_ShadowTint", t.shadowTint.Value);
            if (t.rim.HasValue) material.SetFloat("_RimStrength", t.rim.Value);
            if (t.spec.HasValue) material.SetFloat("_SpecStrength", t.spec.Value);
        }
    }

    static bool TryGetLinearColor(MaterialDescription d, string prop, out Color c)
    {
        if (d.TryGetProperty(prop, out Vector4 v))
        {
            c = new Color(v.x, v.y, v.z, 1f);
            return true;
        }
        c = Color.black;
        return false;
    }

    // Blender adds ".001" style suffixes when names clash.
    static string StripSuffix(string n)
    {
        int dot = n.LastIndexOf('.');
        return dot > 0 && int.TryParse(n.Substring(dot + 1), out _) ? n.Substring(0, dot) : n;
    }
}
