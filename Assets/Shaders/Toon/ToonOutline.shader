// Flat outline colour for the inverted-hull shells baked into the ship FBX.
// The shells already have flipped normals, so normal back-face culling hides
// the side facing the camera. The shader has no ShadowCaster pass, so the
// shells never shadow the hull they wrap.
Shader "StellarDelivery/ToonOutline"
{
    Properties
    {
        _OutlineColor ("Outline Color", Color) = (0.02, 0.02, 0.04, 1)
        _ExtraWidth ("Extra Width (m)", Range(0, 0.1)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        Pass
        {
            Name "Outline"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                half4 _OutlineColor;
                float _ExtraWidth;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                half fogFactor : TEXCOORD0;
            };

            Varyings Vert(Attributes input)
            {
                Varyings o;
                UNITY_SETUP_INSTANCE_ID(input);
                // Shell normals point inward, so push against them to widen the line.
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                positionWS -= TransformObjectToWorldNormal(input.normalOS) * _ExtraWidth;
                o.positionCS = TransformWorldToHClip(positionWS);
                o.fogFactor = ComputeFogFactor(o.positionCS.z);
                return o;
            }

            half4 Frag(Varyings input) : SV_Target
            {
                return half4(MixFog(_OutlineColor.rgb, input.fogFactor), 1);
            }
            ENDHLSL
        }
    }
}
