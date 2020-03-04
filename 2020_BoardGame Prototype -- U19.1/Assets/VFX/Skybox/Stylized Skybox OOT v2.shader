// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox OOT v2"
{
	Properties
	{
		_SunRadius("Sun Radius", Range( 0 , 1)) = 0
		_TopClouds("Top Clouds", 2D) = "white" {}
		_BottomClouds("Bottom Clouds", 2D) = "white" {}
		_PanSpeedFactor("PanSpeedFactor", Float) = 1
		_CloudOpacity("Cloud Opacity", Float) = 0
		_HaloExp("Halo Exp", Range( 0 , 10)) = 10
		_CloudsDay("CloudsDay", Color) = (0.7195621,0.8689173,0.9245283,1)
		_CloudsNight("CloudsNight", Color) = (0.3064703,0.3758842,0.6698113,1)
		_TopDay("TopDay", Color) = (0.3806515,0.7481066,0.8867924,1)
		_SunsetColor("SunsetColor", Color) = (0.9528302,0.7971212,0.4629317,1)
		_TopNight("TopNight", Color) = (0.1365348,0.1089356,0.4528302,1)
		_BottomDay("BottomDay", Color) = (0.3086062,0.5836833,0.8962264,1)
		_BottomNight("BottomNight", Color) = (0.2102617,0.3502325,0.7075472,1)
		_HorizonPower("Horizon Power", Float) = 0
		_HorizonOpacity("Horizon Opacity", Float) = 0
		[Toggle(_CLOUDS_ON)] _Clouds("Clouds", Float) = 0
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
		#pragma shader_feature_local _CLOUDS_ON
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float3 uv_tex3coord;
		};

		uniform float4 _SunsetColor;
		uniform float _HorizonPower;
		uniform float _HorizonOpacity;
		uniform float _HaloExp;
		uniform float _SunRadius;
		uniform float4 _BottomNight;
		uniform float4 _BottomDay;
		uniform float4 _TopNight;
		uniform float4 _TopDay;
		uniform float4 _CloudsNight;
		uniform float4 _CloudsDay;
		uniform float _CloudOpacity;
		uniform sampler2D _BottomClouds;
		uniform float4 _BottomClouds_ST;
		uniform float _PanSpeedFactor;
		uniform sampler2D _TopClouds;
		uniform float4 _TopClouds_ST;

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
			float DayTime01211 = ( ( ase_worldlightDir.y + 1.0 ) * 0.5 );
			float temp_output_6_0_g17 = ( DayTime01211 * 2.0 );
			float lerpResult5_g17 = lerp( 0.0 , 1.0 , saturate( temp_output_6_0_g17 ));
			float lerpResult4_g17 = lerp( lerpResult5_g17 , 0.0 , saturate( ( temp_output_6_0_g17 - 1.0 ) ));
			float3 normalizeResult137 = normalize( i.uv_tex3coord );
			float3 NormalizedSkyCoords144 = normalizeResult137;
			float SunDistance01363 = ( ( ( 1.0 - distance( ase_worldlightDir , NormalizedSkyCoords144 ) ) + 1.0 ) * 0.5 );
			float smoothstepResult387 = smoothstep( 0.0 , 1.0 , SunDistance01363);
			float temp_output_263_0 = pow( ( 1.0 - abs( (NormalizedSkyCoords144).y ) ) , _HorizonPower );
			float Horizon353 = saturate( ( temp_output_263_0 * _HorizonOpacity ) );
			float smoothstepResult372 = smoothstep( 0.5 , 1.0 , SunDistance01363);
			float3 normalizeResult158 = normalize( ase_worldPos );
			float temp_output_52_0 = (normalizeResult158).y;
			float HalfDome269 = ( 1.0 - step( temp_output_52_0 , 0.0 ) );
			float temp_output_261_0 = pow( ( smoothstepResult372 * saturate( ( HalfDome269 + temp_output_263_0 ) ) ) , _HaloExp );
			float smoothstepResult157 = smoothstep( _SunRadius , 2.0 , SunDistance01363);
			float4 lerpResult378 = lerp( _BottomNight , _BottomDay , DayTime01211);
			float4 lerpResult377 = lerp( _TopNight , _TopDay , DayTime01211);
			float4 lerpResult323 = lerp( lerpResult378 , lerpResult377 , HalfDome269);
			float4 lerpResult384 = lerp( _CloudsNight , _CloudsDay , DayTime01211);
			float2 SkyUV58 = ( (normalizeResult158).xz / abs( temp_output_52_0 ) );
			float2 panner173 = ( 1.0 * _Time.y * ( _PanSpeedFactor * _BottomClouds_ST.zw ) + SkyUV58);
			float2 panner161 = ( 1.0 * _Time.y * ( _TopClouds_ST.zw * _PanSpeedFactor ) + SkyUV58);
			float lerpResult277 = lerp( tex2D( _BottomClouds, ( _BottomClouds_ST.xy * panner173 ) ).a , tex2D( _TopClouds, ( _TopClouds_ST.xy * panner161 ) ).a , HalfDome269);
			float smoothstepResult203 = smoothstep( 0.0 , _CloudOpacity , lerpResult277);
			float BothClouds183 = smoothstepResult203;
			float4 lerpResult189 = lerp( lerpResult323 , lerpResult384 , BothClouds183);
			#ifdef _CLOUDS_ON
				float4 staticSwitch399 = lerpResult189;
			#else
				float4 staticSwitch399 = lerpResult323;
			#endif
			float4 BottomColor350 = lerpResult378;
			float4 lerpResult199 = lerp( ( ( saturate( smoothstepResult157 ) * HalfDome269 ) + staticSwitch399 ) , BottomColor350 , Horizon353);
			o.Emission = ( ( _SunsetColor * ( lerpResult4_g17 * saturate( ( smoothstepResult387 + ( smoothstepResult387 * Horizon353 ) ) ) ) ) + ( temp_output_261_0 * ( temp_output_261_0 + temp_output_263_0 ) ) + lerpResult199 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
384;514;907;421;1448.537;772.5333;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-2712.596,-386.7289;Inherit;False;1151.124;481.3895;Comment;10;269;249;247;58;53;179;51;52;158;50;Sky UV and Half Dome;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2698.371,-788.2559;Inherit;False;698.3276;265.2245;;3;144;137;132;Sky Coords;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-2680.017,-283.3671;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-2664.217,-727.1347;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;158;-2483.602,-260.857;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;137;-2445.888,-661.2727;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-2319.134,-196.9989;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;179;-2096.973,-176.2076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-2316.858,-329.7858;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-2257.01,-712.0731;Inherit;False;NormalizedSkyCoords;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-692.0127,-1224.152;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;160;-2645.027,-1769.835;Inherit;True;Property;_TopClouds;Top Clouds;1;0;Create;True;0;0;False;0;None;7ca76aff75cdb4846a2ea5cba396b9a9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-1933.778,-279.6416;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-2662.005,-1264.681;Inherit;True;Property;_BottomClouds;Bottom Clouds;2;0;Create;True;0;0;False;0;None;4508287bde7544c9996d6675d8a0e09e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;364;-984.6461,-2036.176;Inherit;False;1227.582;316.4818;;6;363;362;259;361;256;232;Sun Dist 01;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;251;-445.5748,-1176.726;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1796.405,-332.6646;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2568.93,-1445.136;Inherit;False;Property;_PanSpeedFactor;PanSpeedFactor;3;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;162;-2367.884,-1655.805;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;171;-2419.671,-1148.349;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-2240.36,-1460.74;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;232;-932.7,-1974.861;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;265;-232.9425,-1211.341;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-2214.887,-1193.649;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;-934.6464,-1826.807;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;212;-2703.032,155.456;Inherit;False;908.8613;221.4837;0 to 1 sun position;3;211;342;345;Day Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-2375.339,-1014.282;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;247;-2095.306,-53.19172;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2431.286,-1550.995;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DistanceOpNode;361;-625.5272,-1902.62;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;342;-2652.297,215.2405;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;249;-1939.979,-103.428;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;161;-2072.09,-1546.429;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;173;-2058.475,-1055.08;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;264;-99.91855,-1166.078;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;-200.935,-1052.616;Inherit;False;Property;_HorizonPower;Horizon Power;13;0;Create;True;0;0;False;0;0;4.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;259;-457.4039,-1890.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1869.747,-1651.321;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-1880.777,-1144.705;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;345;-2369.284,222.684;Inherit;False;Minus One One To Zero One;-1;;13;19562fcffd7bc41fcb0c40a6194596ae;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;340;3.562041,-916.843;Inherit;False;Property;_HorizonOpacity;Horizon Opacity;14;0;Create;True;0;0;False;0;0;1.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;263;53.95306,-1120.723;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-1776.42,-31.57795;Inherit;False;HalfDome;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;-1722.747,-1256.86;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;164;-1694.734,-1759.222;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-2033.893,231.8042;Inherit;False;DayTime01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;276;-1587.204,-1429.733;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;317;-1780.129,1209.732;Inherit;False;1257.98;505.9374;bottom Half of the sky;5;350;322;319;320;379;Bottom;0.2844925,0.2337131,0.490566,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;352;241.1101,-1011.085;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;362;-283.7299,-1924.72;Inherit;False;Minus One One To Zero One;-1;;12;19562fcffd7bc41fcb0c40a6194596ae;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;322;-1444.034,1280.098;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;363;25.26556,-1972.457;Inherit;False;SunDistance01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1282.208,-794.0538;Inherit;False;916.1328;336.7536;;5;11;356;157;7;8;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.SaturateNode;354;396.6321,-962.3068;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;277;-1318.019,-1468.878;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;316;-1478.675,542.4119;Inherit;False;955.925;504.6014;Top Half of the sky;4;311;313;315;377;Top;0.5424528,0.8005714,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;320;-1373.047,1513.628;Inherit;False;Property;_BottomNight;BottomNight;12;0;Create;True;0;0;False;0;0.2102617,0.3502325,0.7075472,1;0.3324689,0.3503344,0.901,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;319;-1730.128,1351.536;Inherit;False;Property;_BottomDay;BottomDay;11;0;Create;True;0;0;False;0;0.3086062,0.5836833,0.8962264,1;0.6431373,0.9607844,0.972549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;202;-1334.012,-1287.82;Inherit;False;Property;_CloudOpacity;Cloud Opacity;4;0;Create;True;0;0;False;0;0;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;353;556.173,-905.0408;Inherit;False;Horizon;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1235.997,-583.2416;Inherit;False;Property;_SunRadius;Sun Radius;0;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;-63.04636,-1293.408;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-1009.893,842.5132;Inherit;False;Property;_TopNight;TopNight;10;0;Create;True;0;0;False;0;0.1365348,0.1089356,0.4528302,1;0.1503198,0.1438678,0.5,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;378;-1046.624,1308.884;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;7.58996,-1580.586;Inherit;False;363;SunDistance01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;203;-1114.454,-1375.185;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;328;-1448.074,-80.40852;Inherit;False;955.925;504.6014;;4;332;331;330;384;Clouds Color;0.4834906,0.4928036,0.5,1;0;0
Node;AmplifyShaderEditor.ColorNode;311;-1429.675,684.2154;Inherit;False;Property;_TopDay;TopDay;8;0;Create;True;0;0;False;0;0.3806515,0.7481066,0.8867924,1;0,0.5507969,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;356;-1186.294,-746.2279;Inherit;False;363;SunDistance01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-1142.581,612.7769;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;387;259.6883,-1678.303;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;377;-731.2217,748.1678;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-1111.98,-10.04351;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-752.9149,-660.3898;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;391;307.291,-1789.18;Inherit;False;353;Horizon;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;379;-748.899,1319.517;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-912.3103,-1419.917;Inherit;False;BothClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;274;199.2553,-1211.283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-749.5198,1090.713;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;331;-979.2904,219.6927;Inherit;False;Property;_CloudsNight;CloudsNight;7;0;Create;True;0;0;False;0;0.3064703,0.3758842,0.6698113,1;0.3096691,0.2747698,0.4259999,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;332;-1398.074,61.39506;Inherit;False;Property;_CloudsDay;CloudsDay;6;0;Create;True;0;0;False;0;0.7195621,0.8689173,0.9245283,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-551.9174,-586.3778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-477.6004,506.9245;Inherit;False;183;BothClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;275;357.5014,-1348.235;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;494.1225,-1574.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;384;-674.259,56.56995;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;372;246.1156,-1526.737;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;323;-381.5902,1037.367;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;394;638.6296,-1664.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;504.2474,-1435.426;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;373;482.2231,-1862.063;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-284.1111,117.5167;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;363.6994,-1228.274;Inherit;False;Property;_HaloExp;Halo Exp;5;0;Create;True;0;0;False;0;10;6;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;400;-261.1041,-448.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;-143.5183,401.953;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;350;-772.5515,1487.608;Inherit;False;BottomColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;261;655.4274,-1340.767;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;399;95.14067,473.8368;Inherit;False;Property;_Clouds;Clouds;15;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-49.57543,-19.38187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;375;703.1703,-1875.436;Inherit;False;Lerp Triple;-1;;17;9715dbb4962444c64901cea19c13f62b;0;4;7;FLOAT;0;False;8;FLOAT;1;False;10;FLOAT;0;False;9;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;396;754.4385,-1542.017;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;351;312.9907,-777.9165;Inherit;False;350;BottomColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;291.1885,-73.37252;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;757.2643,-1144.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;388;918.4409,-1629.082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;659.4355,-2052.268;Inherit;False;Property;_SunsetColor;SunsetColor;9;0;Create;True;0;0;False;0;0.9528302,0.7971212,0.4629317,1;0.8490566,0.5198563,0.1241543,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;355;356.9092,-653.3134;Inherit;False;353;Horizon;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;397;1188.906,-1695.799;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;199;827.1198,-734.4493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;902.7487,-1227.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-911.6144,-713.0223;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;1490.616,-1346.491;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1715.645,-1108.711;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox OOT v2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;50;0
WireConnection;137;0;132;0
WireConnection;52;0;158;0
WireConnection;179;0;52;0
WireConnection;51;0;158;0
WireConnection;144;0;137;0
WireConnection;53;0;51;0
WireConnection;53;1;179;0
WireConnection;251;0;250;0
WireConnection;58;0;53;0
WireConnection;162;0;160;0
WireConnection;171;0;174;0
WireConnection;185;0;162;1
WireConnection;185;1;184;0
WireConnection;265;0;251;0
WireConnection;186;0;184;0
WireConnection;186;1;171;1
WireConnection;247;0;52;0
WireConnection;361;0;232;0
WireConnection;361;1;256;0
WireConnection;249;0;247;0
WireConnection;161;0;166;0
WireConnection;161;2;185;0
WireConnection;173;0;172;0
WireConnection;173;2;186;0
WireConnection;264;0;265;0
WireConnection;259;0;361;0
WireConnection;165;0;162;0
WireConnection;165;1;161;0
WireConnection;170;0;171;0
WireConnection;170;1;173;0
WireConnection;345;1;342;2
WireConnection;263;0;264;0
WireConnection;263;1;338;0
WireConnection;269;0;249;0
WireConnection;175;0;174;0
WireConnection;175;1;170;0
WireConnection;164;0;160;0
WireConnection;164;1;165;0
WireConnection;211;0;345;0
WireConnection;352;0;263;0
WireConnection;352;1;340;0
WireConnection;362;1;259;0
WireConnection;363;0;362;0
WireConnection;354;0;352;0
WireConnection;277;0;175;4
WireConnection;277;1;164;4
WireConnection;277;2;276;0
WireConnection;353;0;354;0
WireConnection;378;0;320;0
WireConnection;378;1;319;0
WireConnection;378;2;322;0
WireConnection;203;0;277;0
WireConnection;203;2;202;0
WireConnection;387;0;366;0
WireConnection;377;0;313;0
WireConnection;377;1;311;0
WireConnection;377;2;315;0
WireConnection;157;0;356;0
WireConnection;157;1;8;0
WireConnection;379;0;378;0
WireConnection;183;0;203;0
WireConnection;274;0;270;0
WireConnection;274;1;263;0
WireConnection;11;0;157;0
WireConnection;275;0;274;0
WireConnection;393;0;387;0
WireConnection;393;1;391;0
WireConnection;384;0;331;0
WireConnection;384;1;332;0
WireConnection;384;2;330;0
WireConnection;372;0;366;0
WireConnection;323;0;379;0
WireConnection;323;1;377;0
WireConnection;323;2;324;0
WireConnection;394;0;387;0
WireConnection;394;1;393;0
WireConnection;271;0;372;0
WireConnection;271;1;275;0
WireConnection;400;0;11;0
WireConnection;189;0;323;0
WireConnection;189;1;384;0
WireConnection;189;2;188;0
WireConnection;350;0;378;0
WireConnection;261;0;271;0
WireConnection;261;1;236;0
WireConnection;399;1;323;0
WireConnection;399;0;189;0
WireConnection;248;0;400;0
WireConnection;248;1;279;0
WireConnection;375;9;373;0
WireConnection;396;0;394;0
WireConnection;196;0;248;0
WireConnection;196;1;399;0
WireConnection;273;0;261;0
WireConnection;273;1;263;0
WireConnection;388;0;375;0
WireConnection;388;1;396;0
WireConnection;397;0;312;0
WireConnection;397;1;388;0
WireConnection;199;0;196;0
WireConnection;199;1;351;0
WireConnection;199;2;355;0
WireConnection;267;0;261;0
WireConnection;267;1;273;0
WireConnection;7;0;356;0
WireConnection;7;1;8;0
WireConnection;390;0;397;0
WireConnection;390;1;267;0
WireConnection;390;2;199;0
WireConnection;0;2;390;0
ASEEND*/
//CHKSM=B9D3034E0028335A0BAFF5B1010DD08309895421