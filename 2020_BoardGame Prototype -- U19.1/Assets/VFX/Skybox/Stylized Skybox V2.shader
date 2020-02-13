Shader "Unlit/Stylized Skybox V2"
{
    Properties
    {
        _OffsetHorizon("Horizon Offset",  Range(-1, 1)) = 0
        _HorizonIntensity("Horizon Intensity",  Range(0, 10)) = 3.3
        _SunRadius("Sun Radius",  Range(0, 2)) = 0.1

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
            };

            struct v2f
            {
                float3 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half _SunRadius;
            half _HorizonIntensity, _OffsetHorizon;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;//TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed horizon = abs((i.uv.y * _HorizonIntensity) - _OffsetHorizon);

                float2 skyUV = i.worldPos.xz / i.worldPos.y;

                float sun = distance(i.uv.xyz, (_WorldSpaceLightPos0));
                float sunDisc = 1 - (sun / _SunRadius);
                sunDisc = saturate(sunDisc * 50);



                fixed4 col = frac(fixed4(skyUV.x, skyUV.y, 0, 1));
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
