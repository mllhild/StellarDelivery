// Anime-style cel shader for URP, matching the Blender "AnimeToon" node group:
// three hard light bands (cool shadow tint, mid, lit), a fresnel rim, a hard
// specular spot and flat emission. Receives and casts URP shadows.
Shader "StellarDelivery/AnimeToon"
{
    Properties
    {
        [MainColor] _BaseColor ("Base Color", Color) = (0.8, 0.8, 0.8, 1)
        [MainTexture] _BaseMap ("Base Map", 2D) = "white" {}

        [Header(Bands)]
        _ShadowTint ("Shadow Tint", Color) = (0.68, 0.71, 0.87, 1)
        _MidLevel ("Mid Level", Range(0, 1)) = 0.78
        _ShadowThreshold ("Shadow -> Mid Threshold", Range(0, 1)) = 0.05
        _LitThreshold ("Mid -> Lit Threshold", Range(0, 1)) = 0.18
        _BandSoftness ("Band Softness", Range(0.001, 0.2)) = 0.01
        _LightColorInfluence ("Light Color Influence", Range(0, 1)) = 0.5

        [Header(Rim)]
        _RimStrength ("Rim Strength", Range(0, 1)) = 0.25
        _RimThreshold ("Rim Threshold", Range(0, 1)) = 0.6
        _RimPower ("Rim Power", Range(0.5, 8)) = 1.6

        [Header(Specular)]
        _SpecStrength ("Spec Strength", Range(0, 1)) = 0.2
        _SpecSize ("Spec Size", Range(0.001, 1)) = 0.08

        [Header(Emission)]
        _EmissionColor ("Emission Color", Color) = (0, 0, 0, 1)
        _EmissionStrength ("Emission Strength", Float) = 0

        [Header(Other Lights)]
        _AdditionalLightStrength ("Additional Light Strength", Range(0, 2)) = 0.6
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

        CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            half4 _BaseColor;
            half4 _ShadowTint;
            half _MidLevel;
            half _ShadowThreshold;
            half _LitThreshold;
            half _BandSoftness;
            half _LightColorInfluence;
            half _RimStrength;
            half _RimThreshold;
            half _RimPower;
            half _SpecStrength;
            half _SpecSize;
            half4 _EmissionColor;
            half _EmissionStrength;
            half _AdditionalLightStrength;
        CBUFFER_END

        TEXTURE2D(_BaseMap);
        SAMPLER(sampler_BaseMap);
        ENDHLSL

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
            #pragma multi_compile _ _FORWARD_PLUS _CLUSTER_LIGHT_LOOP
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 positionWS : TEXCOORD1;
                half3 normalWS : TEXCOORD2;
                half fogFactor : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            Varyings Vert(Attributes input)
            {
                Varyings o = (Varyings)0;
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, o);
                VertexPositionInputs pos = GetVertexPositionInputs(input.positionOS.xyz);
                o.positionCS = pos.positionCS;
                o.positionWS = pos.positionWS;
                o.normalWS = TransformObjectToWorldNormal(input.normalOS);
                o.uv = TRANSFORM_TEX(input.uv, _BaseMap);
                o.fogFactor = ComputeFogFactor(pos.positionCS.z);
                return o;
            }

            // 0 = shadow, 0.5 = mid, 1 = lit, with a little smoothing to avoid aliasing.
            half Band(half light)
            {
                half mid = smoothstep(_ShadowThreshold - _BandSoftness, _ShadowThreshold + _BandSoftness, light);
                half lit = smoothstep(_LitThreshold - _BandSoftness, _LitThreshold + _BandSoftness, light);
                return 0.5 * mid + 0.5 * lit;
            }

            half3 BandColor(half band, half3 baseCol)
            {
                half3 shadowCol = baseCol * _ShadowTint.rgb;
                half3 midCol = lerp(shadowCol, baseCol, _MidLevel);
                return band < 0.5 ? lerp(shadowCol, midCol, band * 2) : lerp(midCol, baseCol, band * 2 - 1);
            }

            half4 Frag(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                half3 baseCol = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv).rgb * _BaseColor.rgb;
                half3 N = normalize(input.normalWS);
                half3 V = GetWorldSpaceNormalizeViewDir(input.positionWS);

                float4 shadowCoord = TransformWorldToShadowCoord(input.positionWS);
                Light mainLight = GetMainLight(shadowCoord);
                half NdotL = saturate(dot(N, mainLight.direction));
                half light = NdotL * mainLight.shadowAttenuation * mainLight.distanceAttenuation;
                half band = Band(light);

                half3 lightTint = lerp(half3(1, 1, 1), mainLight.color, _LightColorInfluence);
                half3 col = BandColor(band, baseCol) * lightTint;

                // Rim only on the lit and mid bands, like the Blender version.
                half fresnel = pow(1 - saturate(dot(N, V)), _RimPower);
                half rim = step(_RimThreshold, fresnel) * _RimStrength * step(0.25, band);

                // Hard specular spot on the fully lit band.
                half3 H = normalize(mainLight.direction + V);
                half spec = step(1 - _SpecSize, saturate(dot(N, H))) * _SpecStrength * step(0.75, band);
                col += (rim + spec) * lightTint;

                #if defined(_ADDITIONAL_LIGHTS) || defined(_FORWARD_PLUS) || defined(_CLUSTER_LIGHT_LOOP)
                InputData inputData = (InputData)0;
                inputData.positionWS = input.positionWS;
                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
                uint lightCount = GetAdditionalLightsCount();
                LIGHT_LOOP_BEGIN(lightCount)
                    Light l = GetAdditionalLight(lightIndex, input.positionWS, half4(1, 1, 1, 1));
                    half a = saturate(dot(N, l.direction)) * l.distanceAttenuation * l.shadowAttenuation;
                    half b = smoothstep(_LitThreshold - _BandSoftness, _LitThreshold + _BandSoftness, a);
                    col += baseCol * l.color * b * _AdditionalLightStrength;
                LIGHT_LOOP_END
                #endif

                col += _EmissionColor.rgb * _EmissionStrength;
                col = MixFog(col, input.fogFactor);
                return half4(col, 1);
            }
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull Back

            HLSLPROGRAM
            #pragma vertex ShadowVert
            #pragma fragment ShadowFrag
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

            float3 _LightDirection;
            float3 _LightPosition;

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            float4 ShadowVert(Attributes input) : SV_POSITION
            {
                UNITY_SETUP_INSTANCE_ID(input);
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
                #if defined(_CASTING_PUNCTUAL_LIGHT_SHADOW)
                    float3 lightDir = normalize(_LightPosition - positionWS);
                #else
                    float3 lightDir = _LightDirection;
                #endif
                float4 positionCS = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDir));
                #if UNITY_REVERSED_Z
                    positionCS.z = min(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #else
                    positionCS.z = max(positionCS.z, UNITY_NEAR_CLIP_VALUE);
                #endif
                return positionCS;
            }

            half4 ShadowFrag() : SV_Target { return 0; }
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }
            ZWrite On
            ColorMask R
            Cull Back

            HLSLPROGRAM
            #pragma vertex DepthVert
            #pragma fragment DepthFrag
            #pragma multi_compile_instancing

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            float4 DepthVert(Attributes input) : SV_POSITION
            {
                UNITY_SETUP_INSTANCE_ID(input);
                return TransformObjectToHClip(input.positionOS.xyz);
            }

            half DepthFrag() : SV_Target { return 0; }
            ENDHLSL
        }

        Pass
        {
            Name "DepthNormals"
            Tags { "LightMode" = "DepthNormals" }
            ZWrite On
            Cull Back

            HLSLPROGRAM
            #pragma vertex DNVert
            #pragma fragment DNFrag
            #pragma multi_compile_instancing

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half3 normalWS : TEXCOORD0;
            };

            Varyings DNVert(Attributes input)
            {
                Varyings o;
                UNITY_SETUP_INSTANCE_ID(input);
                o.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                o.normalWS = TransformObjectToWorldNormal(input.normalOS);
                return o;
            }

            half4 DNFrag(Varyings input) : SV_Target
            {
                return half4(NormalizeNormalPerPixel(input.normalWS), 0);
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
