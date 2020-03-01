// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox OOT"
{
	Properties
	{
		_SunRadius("Sun Radius", Range( 0 , 1)) = 0
		_HorizonColorDay("HorizonColorDay", Color) = (0.9339623,0.703715,0,1)
		_HorizonColorTwi("HorizonColorTwi", Color) = (0.9339623,0.703715,0,1)
		_HorizonColorNight("HorizonColorNight", Color) = (0,0,0,1)
		_TopClouds("Top Clouds", 2D) = "white" {}
		_BottomClouds("Bottom Clouds", 2D) = "white" {}
		_Lin("Lin", Float) = 0
		_PanSpeedFactor("PanSpeedFactor", Float) = 1
		_CloudOpacity("Cloud Opacity", Float) = 0
		_HaloExp("Halo Exp", Range( 0 , 10)) = 10
		_BottomTwi("BottomTwi", Color) = (0.8773585,0.5255678,0.2110626,1)
		_CloudsDay("CloudsDay", Color) = (0.7195621,0.8689173,0.9245283,1)
		_CloudsTwi("CloudsTwi", Color) = (0.6603774,0.4799573,0.09656461,1)
		_CloudsNight("CloudsNight", Color) = (0.3064703,0.3758842,0.6698113,1)
		_TopDay("TopDay", Color) = (0.3806515,0.7481066,0.8867924,1)
		_TopTwi("TopTwi", Color) = (0.9528302,0.7971212,0.4629317,1)
		_TopNight("TopNight", Color) = (0.1365348,0.1089356,0.4528302,1)
		_BottomDay("BottomDay", Color) = (0.3086062,0.5836833,0.8962264,1)
		_BottomNight("BottomNight", Color) = (0.2102617,0.3502325,0.7075472,1)
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float3 uv_tex3coord;
		};

		uniform float _HaloExp;
		uniform float _SunRadius;
		uniform float4 _BottomNight;
		uniform float4 _BottomTwi;
		uniform float4 _BottomDay;
		uniform float4 _TopNight;
		uniform float4 _TopTwi;
		uniform float4 _TopDay;
		uniform float4 _CloudsNight;
		uniform float4 _CloudsTwi;
		uniform float4 _CloudsDay;
		uniform float _CloudOpacity;
		uniform sampler2D _BottomClouds;
		uniform float4 _BottomClouds_ST;
		uniform float _PanSpeedFactor;
		uniform sampler2D _TopClouds;
		uniform float4 _TopClouds_ST;
		uniform float4 _HorizonColorNight;
		uniform float4 _HorizonColorTwi;
		uniform float4 _HorizonColorDay;
		uniform float _Lin;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult137 = normalize( i.uv_tex3coord );
			float3 NormalizedSkyCoords144 = normalizeResult137;
			float3 normalizeResult158 = normalize( ase_worldPos );
			float temp_output_52_0 = (normalizeResult158).y;
			float HalfDome269 = ( 1.0 - step( temp_output_52_0 , 0.0 ) );
			float temp_output_263_0 = pow( ( 1.0 - abs( (NormalizedSkyCoords144).y ) ) , 12.0 );
			float temp_output_261_0 = pow( ( max( ( 1.0 - length( ( ase_worldlightDir - NormalizedSkyCoords144 ) ) ) , 0.0 ) * saturate( ( HalfDome269 + temp_output_263_0 ) ) ) , _HaloExp );
			float smoothstepResult157 = smoothstep( 0.0 , 4.0 , ( distance( i.uv_tex3coord , ase_worldlightDir ) / _SunRadius ));
			float DayTime01211 = saturate( (_WorldSpaceLightPos0.xyz).y );
			float temp_output_6_0_g5 = ( DayTime01211 * 2.0 );
			float4 lerpResult5_g5 = lerp( _BottomNight , _BottomTwi , saturate( temp_output_6_0_g5 ));
			float4 lerpResult4_g5 = lerp( lerpResult5_g5 , _BottomDay , saturate( ( temp_output_6_0_g5 - 1.0 ) ));
			float temp_output_6_0_g4 = ( DayTime01211 * 2.0 );
			float4 lerpResult5_g4 = lerp( _TopNight , _TopTwi , saturate( temp_output_6_0_g4 ));
			float4 lerpResult4_g4 = lerp( lerpResult5_g4 , _TopDay , saturate( ( temp_output_6_0_g4 - 1.0 ) ));
			float4 lerpResult323 = lerp( lerpResult4_g5 , lerpResult4_g4 , HalfDome269);
			float temp_output_6_0_g6 = ( DayTime01211 * 2.0 );
			float4 lerpResult5_g6 = lerp( _CloudsNight , _CloudsTwi , saturate( temp_output_6_0_g6 ));
			float4 lerpResult4_g6 = lerp( lerpResult5_g6 , _CloudsDay , saturate( ( temp_output_6_0_g6 - 1.0 ) ));
			float2 SkyUV58 = ( (normalizeResult158).xz / abs( temp_output_52_0 ) );
			float2 panner173 = ( 1.0 * _Time.y * ( _PanSpeedFactor * _BottomClouds_ST.zw ) + SkyUV58);
			float2 panner161 = ( 1.0 * _Time.y * ( _TopClouds_ST.zw * _PanSpeedFactor ) + SkyUV58);
			float lerpResult277 = lerp( tex2D( _BottomClouds, ( _BottomClouds_ST.xy * panner173 ) ).a , tex2D( _TopClouds, ( _TopClouds_ST.xy * panner161 ) ).a , HalfDome269);
			float smoothstepResult203 = smoothstep( 0.0 , _CloudOpacity , lerpResult277);
			float BothClouds183 = smoothstepResult203;
			float4 lerpResult189 = lerp( lerpResult323 , lerpResult4_g6 , BothClouds183);
			float temp_output_6_0_g7 = ( DayTime01211 * 2.0 );
			float4 lerpResult5_g7 = lerp( _HorizonColorNight , _HorizonColorTwi , saturate( temp_output_6_0_g7 ));
			float4 lerpResult4_g7 = lerp( lerpResult5_g7 , _HorizonColorDay , saturate( ( temp_output_6_0_g7 - 1.0 ) ));
			float smoothstepResult143 = smoothstep( _Lin , 1.0 , ( 1.0 - abs( (normalizeResult137).y ) ));
			float4 lerpResult199 = lerp( ( ( ( 1.0 - saturate( smoothstepResult157 ) ) * HalfDome269 ) + lerpResult189 ) , lerpResult4_g7 , saturate( ( smoothstepResult143 * 1.0 ) ));
			o.Emission = ( float4( 0,0,0,0 ) + ( temp_output_261_0 * ( temp_output_261_0 + temp_output_263_0 ) ) + lerpResult199 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
384;514;907;421;3012.418;-887.9735;2.061005;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-3046.321,-475.4854;Inherit;False;1137.279;300.0215;Comment;7;53;58;51;179;52;158;50;Sky UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3013.742,-372.1237;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;158;-2817.327,-349.6136;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1821.455,-917.9569;Inherit;False;1401.163;494.1125;Comment;11;144;44;41;143;39;140;141;37;138;137;132;Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-2652.859,-285.7555;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-1768.198,-716.2686;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;179;-2430.698,-264.9641;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-2650.583,-418.5424;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;137;-1575.192,-660.3583;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-2267.503,-368.3982;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;160;-2619.188,-2222.018;Inherit;True;Property;_TopClouds;Top Clouds;4;0;Create;True;0;0;False;0;None;7ca76aff75cdb4846a2ea5cba396b9a9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-2636.166,-1716.864;Inherit;True;Property;_BottomClouds;Bottom Clouds;5;0;Create;True;0;0;False;0;None;4508287bde7544c9996d6675d8a0e09e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureTransformNode;162;-2342.045,-2107.988;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;171;-2393.832,-1600.532;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2130.13,-421.4211;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1255.608,-545.2624;Inherit;False;NormalizedSkyCoords;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2543.091,-1897.319;Inherit;False;Property;_PanSpeedFactor;PanSpeedFactor;7;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;247;-2413.801,-141.9483;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-2214.521,-1912.923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-2349.5,-1466.465;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2405.447,-2003.178;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;212;-3036.757,66.69944;Inherit;False;908.8613;221.4837;0 to 1 sun position;4;213;211;42;43;Day Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-530.0935,-1414.646;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-2189.048,-1645.832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;251;-283.6556,-1367.22;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;173;-2032.636,-1507.263;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;42;-2986.757,126.142;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;249;-2275.088,-91.11693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1419.525,-259.2291;Inherit;False;1115.065;507.5304;;7;10;3;4;8;7;11;157;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.PannerNode;161;-2046.251,-1998.612;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-1369.001,-13.01333;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;43;-2732.07,116.6994;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-2110.145,-130.026;Inherit;False;HalfDome;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;-268.1047,-1620.77;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;232;-257.4952,-1768.824;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;265;-71.02326,-1401.835;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1843.908,-2103.504;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1369.525,-209.2291;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-1854.938,-1596.888;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;175;-1696.908,-1709.043;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;276;-1359.554,-1906.754;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1180.627,133.8013;Inherit;False;Property;_SunRadius;Sun Radius;0;0;Create;True;0;0;False;0;0;0.1058824;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1039.936,-107.3736;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;264;62.0008,-1356.572;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;257;37.45987,-1741.807;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;213;-2510.234,210.4596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;164;-1668.895,-2211.405;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;277;-1090.369,-1945.899;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;317;-2529.539,1274.837;Inherit;False;955.925;504.6014;bottom Half of the sky;5;322;321;320;319;318;Bottom;0.2844925,0.2337131,0.490566,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-2342.144,79.3653;Inherit;False;DayTime01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;263;215.8724,-1311.217;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;138;-1412.24,-754.0458;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;98.87298,-1483.902;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;258;195.426,-1690.217;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-1106.362,-1764.841;Inherit;False;Property;_CloudOpacity;Cloud Opacity;8;0;Create;True;0;0;False;0;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;316;-2515.584,656.9972;Inherit;False;955.925;504.6014;Top Half of the sky;5;312;311;313;314;315;Top;0.5424528,0.8005714,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-863.2579,15.07569;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-730.7903,56.65308;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-2046.801,957.0985;Inherit;False;Property;_TopNight;TopNight;16;0;Create;True;0;0;False;0;0.1365348,0.1089356,0.4528302,1;0.1365348,0.1089356,0.4528301,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;318;-2266.507,1498.417;Inherit;False;Property;_BottomTwi;BottomTwi;10;0;Create;True;0;0;False;0;0.8773585,0.5255678,0.2110626,1;0.9647059,0.7529413,0.3411765,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;312;-2252.552,881.5768;Inherit;False;Property;_TopTwi;TopTwi;15;0;Create;True;0;0;False;0;0.9528302,0.7971212,0.4629317,1;0.9528301,0.7971212,0.4629317,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;37;-1195.788,-701.2372;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;203;-886.804,-1852.206;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;311;-2466.584,798.8007;Inherit;False;Property;_TopDay;TopDay;14;0;Create;True;0;0;False;0;0.3806515,0.7481066,0.8867924,1;0.1839623,0.6871154,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;320;-2061.756,1574.939;Inherit;False;Property;_BottomNight;BottomNight;18;0;Create;True;0;0;False;0;0.2102617,0.3502325,0.7075472,1;0.3058823,0.427451,0.7019608,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;274;361.1745,-1401.777;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;259;348.0314,-1731.182;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;-2193.445,1345.203;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;328;-1450.308,462.6747;Inherit;False;955.925;504.6014;;5;333;332;331;330;329;Clouds Color;0.4834906,0.4928036,0.5,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-2179.49,727.3622;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;319;-2479.539,1416.641;Inherit;False;Property;_BottomDay;BottomDay;17;0;Create;True;0;0;False;0;0.3086062,0.5836833,0.8962264,1;0.6179245,0.9881709,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;330;-1114.214,533.0397;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;275;519.4206,-1538.729;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;321;-1758.614,1444.82;Inherit;False;Lerp Triple;-1;;5;9715dbb4962444c64901cea19c13f62b;0;4;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;10;COLOR;0,0,0,0;False;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1057.242,-649.7302;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-684.6601,-1896.938;Inherit;False;BothClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1087.939,-882.697;Inherit;False;Property;_Lin;Lin;6;0;Create;True;0;0;False;0;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-1541.772,1185.544;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-576.3475,-121.3578;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1088.356,-806.9772;Inherit;False;Constant;_Max;Max;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;314;-1744.659,826.9797;Inherit;False;Lerp Triple;-1;;4;9715dbb4962444c64901cea19c13f62b;0;4;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;10;COLOR;0,0,0,0;False;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;331;-981.5248,762.7759;Inherit;False;Property;_CloudsNight;CloudsNight;13;0;Create;True;0;0;False;0;0.3064703,0.3758842,0.6698113,1;0.1163847,0.1102705,0.3962264,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;332;-1400.308,604.4783;Inherit;False;Property;_CloudsDay;CloudsDay;11;0;Create;True;0;0;False;0;0.7195621,0.8689173,0.9245283,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;329;-1188.276,686.2542;Inherit;False;Property;_CloudsTwi;CloudsTwi;12;0;Create;True;0;0;False;0;0.6603774,0.4799573,0.09656461,1;0.4528301,0.2221971,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;260;512.6656,-1684.306;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-280.1111,57.51666;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;666.1666,-1625.92;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-449.6802,529.7454;Inherit;False;183;BothClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;143;-884.9928,-728.8713;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;525.6186,-1418.768;Inherit;False;Property;_HaloExp;Halo Exp;9;0;Create;True;0;0;False;0;10;1.823528;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-424.2188,-185.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;333;-679.3829,632.6572;Inherit;False;Lerp Triple;-1;;6;9715dbb4962444c64901cea19c13f62b;0;4;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;10;COLOR;0,0,0,0;False;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;323;-1209.229,1162.03;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;189;-177.574,710.7008;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;243;-327.7455,-732.376;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-171.4519,-1115.864;Inherit;False;Property;_HorizonColorDay;HorizonColorDay;1;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;0.6853863,0.9514062,0.9622641,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-705.8757,-651.2612;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-49.57543,-19.38187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;334;-384.2726,-982.4756;Inherit;False;Property;_HorizonColorTwi;HorizonColorTwi;2;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;1,0.749069,0.2311321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;261;817.3466,-1531.261;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;241;-168.779,-905.9516;Inherit;False;Property;_HorizonColorNight;HorizonColorNight;3;0;Create;True;0;0;False;0;0,0,0,1;0.2843983,0.4201606,0.7264151,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;335;136.6937,-996.7395;Inherit;False;Lerp Triple;-1;;7;9715dbb4962444c64901cea19c13f62b;0;4;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;10;COLOR;0,0,0,0;False;9;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;140.3772,-59.29679;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;919.1835,-1334.799;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;-571.9796,-641.9357;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;199;423.2381,-741.2184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;1064.668,-1418.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;1254.787,-1094.299;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1486.069,-1071.28;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox OOT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;50;0
WireConnection;52;0;158;0
WireConnection;179;0;52;0
WireConnection;51;0;158;0
WireConnection;137;0;132;0
WireConnection;53;0;51;0
WireConnection;53;1;179;0
WireConnection;162;0;160;0
WireConnection;171;0;174;0
WireConnection;58;0;53;0
WireConnection;144;0;137;0
WireConnection;247;0;52;0
WireConnection;185;0;162;1
WireConnection;185;1;184;0
WireConnection;186;0;184;0
WireConnection;186;1;171;1
WireConnection;251;0;250;0
WireConnection;173;0;172;0
WireConnection;173;2;186;0
WireConnection;249;0;247;0
WireConnection;161;0;166;0
WireConnection;161;2;185;0
WireConnection;43;0;42;1
WireConnection;269;0;249;0
WireConnection;265;0;251;0
WireConnection;165;0;162;0
WireConnection;165;1;161;0
WireConnection;170;0;171;0
WireConnection;170;1;173;0
WireConnection;175;0;174;0
WireConnection;175;1;170;0
WireConnection;4;0;3;0
WireConnection;4;1;10;0
WireConnection;264;0;265;0
WireConnection;257;0;232;0
WireConnection;257;1;256;0
WireConnection;213;0;43;0
WireConnection;164;0;160;0
WireConnection;164;1;165;0
WireConnection;277;0;175;4
WireConnection;277;1;164;4
WireConnection;277;2;276;0
WireConnection;211;0;213;0
WireConnection;263;0;264;0
WireConnection;138;0;137;0
WireConnection;258;0;257;0
WireConnection;7;0;4;0
WireConnection;7;1;8;0
WireConnection;157;0;7;0
WireConnection;37;0;138;0
WireConnection;203;0;277;0
WireConnection;203;2;202;0
WireConnection;274;0;270;0
WireConnection;274;1;263;0
WireConnection;259;0;258;0
WireConnection;275;0;274;0
WireConnection;321;7;320;0
WireConnection;321;8;318;0
WireConnection;321;10;319;0
WireConnection;321;9;322;0
WireConnection;39;0;37;0
WireConnection;183;0;203;0
WireConnection;11;0;157;0
WireConnection;314;7;313;0
WireConnection;314;8;312;0
WireConnection;314;10;311;0
WireConnection;314;9;315;0
WireConnection;260;0;259;0
WireConnection;271;0;260;0
WireConnection;271;1;275;0
WireConnection;143;0;39;0
WireConnection;143;1;140;0
WireConnection;143;2;141;0
WireConnection;12;0;11;0
WireConnection;333;7;331;0
WireConnection;333;8;329;0
WireConnection;333;10;332;0
WireConnection;333;9;330;0
WireConnection;323;0;321;0
WireConnection;323;1;314;0
WireConnection;323;2;324;0
WireConnection;189;0;323;0
WireConnection;189;1;333;0
WireConnection;189;2;188;0
WireConnection;41;0;143;0
WireConnection;248;0;12;0
WireConnection;248;1;279;0
WireConnection;261;0;271;0
WireConnection;261;1;236;0
WireConnection;335;7;241;0
WireConnection;335;8;334;0
WireConnection;335;10;46;0
WireConnection;335;9;243;0
WireConnection;196;0;248;0
WireConnection;196;1;189;0
WireConnection;273;0;261;0
WireConnection;273;1;263;0
WireConnection;44;0;41;0
WireConnection;199;0;196;0
WireConnection;199;1;335;0
WireConnection;199;2;44;0
WireConnection;267;0;261;0
WireConnection;267;1;273;0
WireConnection;268;1;267;0
WireConnection;268;2;199;0
WireConnection;0;2;268;0
ASEEND*/
//CHKSM=C62CB8F3B5497F9C77CAE68B2F5F76001D294EC4