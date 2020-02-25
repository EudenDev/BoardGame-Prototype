// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox OOT"
{
	Properties
	{
		_SunRadius("Sun Radius", Range( 0 , 1)) = 0
		_DayTopColor("DayTopColor", Color) = (0.5,0.5,0.5,1)
		_DayBottomColor("DayBottomColor", Color) = (1,1,1,1)
		_TopColor2("TopColor2", Color) = (0.5,0.5,0.5,1)
		_BottomColor2("BottomColor2", Color) = (1,1,1,1)
		_HorizonColorDay("HorizonColorDay", Color) = (0.9339623,0.703715,0,1)
		_HorizonColorNight("HorizonColorNight", Color) = (0,0,0,1)
		_TopClouds("Top Clouds", 2D) = "white" {}
		_BottomClouds("Bottom Clouds", 2D) = "white" {}
		_Lin("Lin", Float) = 0
		_Min("Min", Float) = 0
		_Float0("Float 0", Float) = 0
		_PanSpeedFactor("PanSpeedFactor", Float) = 1
		_CloudOpacity("Cloud Opacity", Float) = 0
		_CloudsColor2("Clouds Color 2", Color) = (0.6415094,0.6415094,0.6415094,1)
		_CloudsColor1("Clouds Color 1", Color) = (1,1,1,1)
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
			float3 uv_tex3coord;
			float3 worldPos;
		};

		uniform float _SunRadius;
		uniform float4 _BottomColor2;
		uniform float4 _TopColor2;
		uniform float _Min;
		uniform float _Float0;
		uniform float4 _DayBottomColor;
		uniform float4 _DayTopColor;
		uniform float4 _CloudsColor2;
		uniform float4 _CloudsColor1;
		uniform float _CloudOpacity;
		uniform sampler2D _TopClouds;
		uniform float4 _TopClouds_ST;
		uniform float _PanSpeedFactor;
		uniform sampler2D _BottomClouds;
		uniform float4 _BottomClouds_ST;
		uniform float4 _HorizonColorNight;
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
			float smoothstepResult157 = smoothstep( 0.0 , 8.0 , ( distance( i.uv_tex3coord , ase_worldlightDir ) / _SunRadius ));
			float3 normalizeResult245 = normalize( ase_worldPos );
			float3 normalizeResult137 = normalize( i.uv_tex3coord );
			float3 NormalizedSkyCoords144 = normalizeResult137;
			float smoothstepResult151 = smoothstep( _Min , _Float0 , (NormalizedSkyCoords144).y);
			float temp_output_16_0 = saturate( smoothstepResult151 );
			float4 lerpResult26 = lerp( _BottomColor2 , _TopColor2 , temp_output_16_0);
			float4 lerpResult17 = lerp( _DayBottomColor , _DayTopColor , temp_output_16_0);
			float DayTime01211 = saturate( (_WorldSpaceLightPos0.xyz).y );
			float4 lerpResult34 = lerp( pow( lerpResult26 , 2.0 ) , pow( lerpResult17 , 2.0 ) , DayTime01211);
			float4 lerpResult206 = lerp( _CloudsColor2 , _CloudsColor1 , DayTime01211);
			float3 normalizeResult158 = normalize( ase_worldPos );
			float2 SkyUV58 = ( (normalizeResult158).xz / abs( (normalizeResult158).y ) );
			float2 panner161 = ( 1.0 * _Time.y * ( _TopClouds_ST.zw * _PanSpeedFactor ) + SkyUV58);
			float temp_output_169_0 = saturate( ase_worldPos.y );
			float2 panner173 = ( 1.0 * _Time.y * ( _PanSpeedFactor * _BottomClouds_ST.zw ) + SkyUV58);
			float smoothstepResult203 = smoothstep( 0.0 , _CloudOpacity , ( ( tex2D( _TopClouds, ( _TopClouds_ST.xy * panner161 ) ).a * temp_output_169_0 ) + ( ( 1.0 - temp_output_169_0 ) * tex2D( _BottomClouds, ( _BottomClouds_ST.xy * panner173 ) ).a ) ));
			float BothClouds183 = smoothstepResult203;
			float4 lerpResult189 = lerp( sqrt( lerpResult34 ) , lerpResult206 , BothClouds183);
			float4 temp_output_196_0 = ( ( ( 1.0 - saturate( smoothstepResult157 ) ) * ( 1.0 - step( (normalizeResult245).y , 0.0 ) ) ) + lerpResult189 );
			float4 lerpResult242 = lerp( _HorizonColorNight , _HorizonColorDay , DayTime01211);
			float smoothstepResult143 = smoothstep( _Lin , 1.0 , ( 1.0 - abs( (normalizeResult137).y ) ));
			float temp_output_44_0 = saturate( ( smoothstepResult143 * 1.0 ) );
			float4 lerpResult199 = lerp( temp_output_196_0 , lerpResult242 , temp_output_44_0);
			o.Emission = lerpResult199.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
383;546;907;389;551.4851;976.8146;3.134547;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-3046.321,-475.4854;Inherit;False;1117.54;302.8414;Comment;7;50;158;51;52;179;53;58;Sky UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3013.742,-372.1237;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;158;-2817.327,-349.6136;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-2652.859,-285.7555;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-2650.583,-418.5424;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1669.339,-1092.21;Inherit;False;1202.921;590.8865;Comment;10;44;37;39;41;138;137;132;140;141;143;Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;179;-2430.698,-264.9641;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-1640.74,-928.3303;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;160;-2619.188,-2222.018;Inherit;True;Property;_TopClouds;Top Clouds;7;0;Create;True;0;0;False;0;None;7ca76aff75cdb4846a2ea5cba396b9a9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-2290.062,-357.1188;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-2636.166,-1786.959;Inherit;True;Property;_BottomClouds;Bottom Clouds;8;0;Create;True;0;0;False;0;None;4508287bde7544c9996d6675d8a0e09e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2543.091,-1897.319;Inherit;False;Property;_PanSpeedFactor;PanSpeedFactor;12;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;137;-1440.803,-946.7762;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureTransformNode;171;-2393.832,-1670.627;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureTransformNode;162;-2342.045,-2107.988;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2144.229,-421.4211;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-2349.5,-1536.56;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2405.447,-2003.178;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-2214.521,-1912.923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-2189.048,-1715.927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1128.527,-1235.495;Inherit;False;NormalizedSkyCoords;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;173;-2032.636,-1577.358;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;168;-1734.692,-1958.667;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;145;-3121.241,966.1533;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;212;-3036.757,-31.99558;Inherit;False;908.8613;221.4837;0 to 1 sun position;4;213;211;42;43;Day Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;161;-2046.251,-1998.612;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-1854.938,-1666.983;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2802.984,916.7025;Inherit;False;Property;_Float0;Float 0;11;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;146;-2814.86,1048.781;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1419.525,-259.2291;Inherit;False;1115.065;507.5304;;7;10;3;4;8;7;11;157;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1843.908,-2103.504;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-2801.296,845.8735;Inherit;False;Property;_Min;Min;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;169;-1529.193,-1947.355;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;42;-2986.757,27.44702;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1369.525,-209.2291;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;43;-2732.07,18.00441;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;164;-1668.895,-2211.405;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;180;-1362.025,-1860.488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2154.047,392.1381;Inherit;False;1009.632;498.7175;Comment;5;14;16;17;1;207;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;151;-2441.446,989.6534;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-1369.001,-13.01333;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;21;-2144.647,1083.874;Inherit;False;1023.701;475.3911;Comment;4;24;23;26;208;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;175;-1696.908,-1779.138;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-1978.721,1131.829;Inherit;False;Property;_BottomColor2;BottomColor2;4;0;Create;True;0;0;False;0;1,1,1,1;0.1076005,0.3524326,0.735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;213;-2510.234,111.7646;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-1858.813,818.9916;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1180.627,133.8013;Inherit;False;Property;_SunRadius;Sun Radius;0;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-1182.408,-1784.051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-2031.079,433.443;Inherit;False;Property;_DayBottomColor;DayBottomColor;2;0;Create;True;0;0;False;0;1,1,1,1;0.485849,0.951307,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;244;-955.0486,347.5384;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;14;-1870.017,615.8494;Inherit;False;Property;_DayTopColor;DayTopColor;1;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.07075451,0.5578593,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;-1178.375,-2024.227;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1039.936,-107.3736;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1850.388,1334.691;Inherit;False;Property;_TopColor2;TopColor2;3;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.03844785,0.1034186,0.3018866,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;245;-758.6335,370.0485;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-1143.01,-1635.609;Inherit;False;Property;_CloudOpacity;Cloud Opacity;13;0;Create;True;0;0;False;0;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;-987.9485,-1902.842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-863.2579,15.07569;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;138;-1273.988,-910.2584;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-1517.328,545.7618;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-2339.144,25.67027;Inherit;False;DayTime01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-1507.928,1246.193;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;37;-1227.427,-778.4903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;207;-1324.594,602.1007;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;203;-792.2905,-1674.752;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-728.9189,43.55298;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-1165.839,966.8463;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;208;-1300.982,1187.164;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;246;-598.9166,324.631;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1121.995,-981.2302;Inherit;False;Constant;_Max;Max;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1121.578,-1056.95;Inherit;False;Property;_Lin;Lin;9;0;Create;True;0;0;False;0;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;-987.6447,1553.18;Inherit;False;Property;_CloudsColor1;Clouds Color 1;15;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-617.1506,-1898.867;Inherit;False;BothClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-622.3475,-144.3578;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;205;-1024.128,1355.915;Inherit;False;Property;_CloudsColor2;Clouds Color 2;14;0;Create;True;0;0;False;0;0.6415094,0.6415094,0.6415094,1;0.1023941,0.2516221,0.5566037,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;247;-382.782,289.0509;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-673.3723,844.3395;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1090.882,-823.9833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;143;-918.6315,-903.1243;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-424.2188,-185.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-356.3992,1178.16;Inherit;False;183;BothClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;249;-224.2564,322.621;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;209;-413.7632,902.6821;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;206;-650.609,1283.62;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-419.5397,-999.8699;Inherit;False;Property;_HorizonColorDay;HorizonColorDay;5;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;0.5845941,0.7482698,0.8207547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-75.0563,7.435129;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;-132.1224,847.0557;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;241;-427.8843,-1268.711;Inherit;False;Property;_HorizonColorNight;HorizonColorNight;6;0;Create;True;0;0;False;0;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;243;-232.7817,-1073.773;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-739.5144,-825.5143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;140.3772,-59.29679;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;44;-583.6274,-767.8083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;242;14.27684,-1081.409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;233;564.1641,-956.6539;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;234;893.7532,-854.7985;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;538.4586,-584.5798;Inherit;False;Property;_Float1;Float 1;16;0;Create;True;0;0;False;0;10;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;999.233,-691.1084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;857.4471,-307.7505;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;222.3991,-808.4016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;232;564.6882,-760.4382;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosterizeNode;238;1277.353,-596.3638;Inherit;False;10;2;1;COLOR;0,0,0,0;False;0;INT;10;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;239;1155.902,-827.7381;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;231;407.053,-450.1471;Inherit;False;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;199;404.9277,-152.3853;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;251;1174.498,-262.9904;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1513.628,-753.5563;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox OOT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;50;0
WireConnection;52;0;158;0
WireConnection;51;0;158;0
WireConnection;179;0;52;0
WireConnection;53;0;51;0
WireConnection;53;1;179;0
WireConnection;137;0;132;0
WireConnection;171;0;174;0
WireConnection;162;0;160;0
WireConnection;58;0;53;0
WireConnection;185;0;162;1
WireConnection;185;1;184;0
WireConnection;186;0;184;0
WireConnection;186;1;171;1
WireConnection;144;0;137;0
WireConnection;173;0;172;0
WireConnection;173;2;186;0
WireConnection;161;0;166;0
WireConnection;161;2;185;0
WireConnection;170;0;171;0
WireConnection;170;1;173;0
WireConnection;146;0;145;0
WireConnection;165;0;162;0
WireConnection;165;1;161;0
WireConnection;169;0;168;2
WireConnection;43;0;42;1
WireConnection;164;0;160;0
WireConnection;164;1;165;0
WireConnection;180;0;169;0
WireConnection;151;0;146;0
WireConnection;151;1;149;0
WireConnection;151;2;150;0
WireConnection;175;0;174;0
WireConnection;175;1;170;0
WireConnection;213;0;43;0
WireConnection;16;0;151;0
WireConnection;181;0;180;0
WireConnection;181;1;175;4
WireConnection;176;0;164;4
WireConnection;176;1;169;0
WireConnection;4;0;3;0
WireConnection;4;1;10;0
WireConnection;245;0;244;0
WireConnection;182;0;176;0
WireConnection;182;1;181;0
WireConnection;7;0;4;0
WireConnection;7;1;8;0
WireConnection;138;0;137;0
WireConnection;17;0;1;0
WireConnection;17;1;14;0
WireConnection;17;2;16;0
WireConnection;211;0;213;0
WireConnection;26;0;24;0
WireConnection;26;1;23;0
WireConnection;26;2;16;0
WireConnection;37;0;138;0
WireConnection;207;0;17;0
WireConnection;203;0;182;0
WireConnection;203;2;202;0
WireConnection;157;0;7;0
WireConnection;208;0;26;0
WireConnection;246;0;245;0
WireConnection;183;0;203;0
WireConnection;11;0;157;0
WireConnection;247;0;246;0
WireConnection;34;0;208;0
WireConnection;34;1;207;0
WireConnection;34;2;214;0
WireConnection;39;0;37;0
WireConnection;143;0;39;0
WireConnection;143;1;140;0
WireConnection;143;2;141;0
WireConnection;12;0;11;0
WireConnection;249;0;247;0
WireConnection;209;0;34;0
WireConnection;206;0;205;0
WireConnection;206;1;204;0
WireConnection;206;2;214;0
WireConnection;248;0;12;0
WireConnection;248;1;249;0
WireConnection;189;0;209;0
WireConnection;189;1;206;0
WireConnection;189;2;188;0
WireConnection;41;0;143;0
WireConnection;196;0;248;0
WireConnection;196;1;189;0
WireConnection;44;0;41;0
WireConnection;242;0;241;0
WireConnection;242;1;46;0
WireConnection;242;2;243;0
WireConnection;234;0;233;0
WireConnection;234;1;232;0
WireConnection;240;0;234;0
WireConnection;240;1;236;0
WireConnection;47;0;242;0
WireConnection;47;1;44;0
WireConnection;238;1;239;0
WireConnection;239;0;240;0
WireConnection;231;0;47;0
WireConnection;231;1;196;0
WireConnection;199;0;196;0
WireConnection;199;1;242;0
WireConnection;199;2;44;0
WireConnection;251;0;250;0
WireConnection;0;2;199;0
ASEEND*/
//CHKSM=0306F4B34A12FFCA7DD22B44458615524CCD0AAD