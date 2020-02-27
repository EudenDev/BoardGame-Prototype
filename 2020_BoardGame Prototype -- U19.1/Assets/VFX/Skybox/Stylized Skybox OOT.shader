// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox OOT"
{
	Properties
	{
		_HorizonColorDay("HorizonColorDay", Color) = (0.9339623,0.703715,0,1)
		_HorizonColorNight("HorizonColorNight", Color) = (0,0,0,1)
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float3 uv_tex3coord;
		};

		uniform float4 _HorizonColorNight;
		uniform float4 _HorizonColorDay;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color281 = IsGammaSpace() ? float4(0.9622642,0.6185491,0,1) : float4(0.9162945,0.340628,0,1);
			float DayTime01211 = saturate( (_WorldSpaceLightPos0.xyz).y );
			float4 lerpResult242 = lerp( _HorizonColorNight , _HorizonColorDay , DayTime01211);
			float4 DualHorizonColor284 = lerpResult242;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult137 = normalize( i.uv_tex3coord );
			float3 NormalizedSkyCoords144 = normalizeResult137;
			float dotResult280 = dot( ase_worldlightDir , NormalizedSkyCoords144 );
			float4 lerpResult283 = lerp( color281 , DualHorizonColor284 , dotResult280);
			o.Emission = lerpResult283.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
384;514;907;421;238.4534;2224.054;3.892269;False;False
Node;AmplifyShaderEditor.CommentaryNode;212;-3036.757,66.69944;Inherit;False;908.8613;221.4837;0 to 1 sun position;4;213;211;42;43;Day Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;42;-2986.757,126.142;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;43;-2732.07,116.6994;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;213;-2510.234,210.4596;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1855.094,-1092.21;Inherit;False;1388.676;590.8865;Comment;10;138;41;143;37;141;39;140;137;132;144;Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-2339.144,124.3653;Inherit;False;DayTime01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-1801.837,-890.5216;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;241;-427.8843,-1268.711;Inherit;False;Property;_HorizonColorNight;HorizonColorNight;6;0;Create;True;0;0;False;0;0,0,0,1;0.1090244,0.2786713,0.6603774,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;243;-232.7817,-1073.773;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-419.5397,-999.8699;Inherit;False;Property;_HorizonColorDay;HorizonColorDay;5;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;0.7821288,0.9732597,0.9811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;137;-1608.831,-834.6113;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1286.125,-641.4718;Inherit;False;NormalizedSkyCoords;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;242;14.27684,-1081.409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;286.3266,-1011.66;Inherit;False;DualHorizonColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;232;253.5891,-1629.888;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;256;242.9796,-1481.834;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;281;444.1344,-2165.978;Inherit;False;Constant;_Color0;Color 0;17;0;Create;True;0;0;False;0;0.9622642,0.6185491,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;280;569.4029,-1766.472;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;484.7246,-1941.651;Inherit;False;284;DualHorizonColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2154.047,392.1381;Inherit;False;1009.632;498.7175;Comment;4;14;17;1;207;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2144.647,1083.874;Inherit;False;1023.701;475.3911;Comment;4;24;23;26;208;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-3046.321,-475.4854;Inherit;False;1137.279;300.0215;Comment;7;53;58;51;179;52;158;50;Sky UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-1419.525,-259.2291;Inherit;False;1115.065;507.5304;;7;10;3;4;8;7;11;157;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3013.742,-372.1237;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;276;-1359.554,-1906.754;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;270;609.9573,-1344.966;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;205;-959.8688,1149.237;Inherit;False;Property;_CloudsColor2;Clouds Color 2;14;0;Create;True;0;0;False;0;0.6415094,0.6415094,0.6415094,1;0.1023939,0.251622,0.5566037,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;274;872.2589,-1262.841;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;-1229.427,-875.4903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;260;1023.75,-1545.37;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-673.3723,844.3395;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;207;-1324.594,602.1007;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-1165.839,966.8463;Inherit;False;211;DayTime01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;-956.4224,1348.648;Inherit;False;Property;_CloudsColor1;Clouds Color 1;15;0;Create;True;0;0;False;0;1,1,1,1;0.8915094,0.9916881,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;141;-1121.995,-981.2302;Inherit;False;Constant;_Max;Max;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;208;-1300.982,1187.164;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;-1507.928,1246.193;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-2543.091,-1897.319;Inherit;False;Property;_PanSpeedFactor;PanSpeedFactor;12;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-2921.946,973.5347;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-1106.362,-1764.841;Inherit;False;Property;_CloudOpacity;Cloud Opacity;13;0;Create;True;0;0;False;0;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-1517.328,545.7618;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;199;404.9277,-530.6483;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1090.882,-823.9833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;140.3772,-59.29679;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;236;1036.703,-1279.832;Inherit;False;Property;_HaloExp;Halo Exp;16;0;Create;True;0;0;False;0;10;1.823528;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;263;726.9567,-1172.281;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;12;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-424.2188,-185.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;273;1430.268,-1195.863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-739.5144,-825.5143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-2652.859,-285.7555;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-49.57543,-19.38187;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;-177.574,710.7008;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;261;1328.431,-1392.325;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;1575.752,-1279.309;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;209;-489.5159,785.2653;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;1177.251,-1486.984;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;-583.6274,-767.8083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;206;-601.3696,1079.088;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-280.1111,57.51666;Inherit;False;269;HalfDome;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-420.789,610.015;Inherit;False;183;BothClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1180.627,133.8013;Inherit;False;Property;_SunRadius;Sun Radius;0;0;Create;True;0;0;False;0;0;0.1058824;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-1870.017,615.8494;Inherit;False;Property;_DayTopColor;DayTopColor;1;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.07075439,0.5578593,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-863.2579,15.07569;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-576.3475,-121.3578;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;143;-918.6315,-903.1243;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;203;-886.804,-1852.206;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;275;1030.505,-1399.793;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1121.578,-1056.95;Inherit;False;Property;_Lin;Lin;9;0;Create;True;0;0;False;0;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;257;548.5441,-1602.871;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;258;706.5103,-1551.281;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;283;903.926,-1985.205;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1;-2031.079,433.443;Inherit;False;Property;_DayBottomColor;DayBottomColor;2;0;Create;True;0;0;False;0;1,1,1,1;0.485849,0.951307,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;4;-1039.936,-107.3736;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-1978.721,1131.829;Inherit;False;Property;_BottomColor2;BottomColor2;4;0;Create;True;0;0;False;0;1,1,1,1;0.1076004,0.3524325,0.735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;51;-2650.583,-418.5424;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-2405.447,-2003.178;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-19.00924,-1275.71;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;265;440.061,-1262.899;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;247;-2413.801,-141.9483;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;162;-2342.045,-2107.988;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;149;-2624.145,853.2548;Inherit;False;Property;_Min;Min;10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;259;859.1158,-1592.246;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;160;-2619.188,-2222.018;Inherit;True;Property;_TopClouds;Top Clouds;7;0;Create;True;0;0;False;0;None;7ca76aff75cdb4846a2ea5cba396b9a9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-2636.166,-1716.864;Inherit;True;Property;_BottomClouds;Bottom Clouds;8;0;Create;True;0;0;False;0;None;4508287bde7544c9996d6675d8a0e09e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-2267.503,-368.3982;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;171;-2393.832,-1600.532;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.AbsOpNode;179;-2430.698,-264.9641;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;158;-2817.327,-349.6136;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2130.13,-421.4211;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;264;573.0851,-1217.636;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1850.388,1334.691;Inherit;False;Property;_TopColor2;TopColor2;3;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.03844785,0.1034184,0.3018864,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;173;-2032.636,-1507.263;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-684.6601,-1896.938;Inherit;False;BothClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-730.7903,56.65308;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;146;-2637.709,1056.162;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;277;-1090.369,-1945.899;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-2349.5,-1466.465;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-1369.001,-13.01333;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;16;-1762.855,949.3945;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-2214.521,-1912.923;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;175;-1696.908,-1709.043;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;161;-2046.251,-1998.612;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;138;-1445.879,-928.2988;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;251;227.4287,-1228.284;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-2625.833,924.0839;Inherit;False;Property;_Float0;Float 0;11;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-1843.908,-2103.504;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;151;-2362.712,935.5239;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;-2110.145,-130.026;Inherit;False;HalfDome;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;1755.947,-1024.831;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-2189.048,-1645.832;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-1854.938,-1596.888;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;249;-2275.088,-91.11693;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1369.525,-209.2291;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;164;-1668.895,-2211.405;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1987.229,-1001.812;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox OOT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;42;1
WireConnection;213;0;43;0
WireConnection;211;0;213;0
WireConnection;137;0;132;0
WireConnection;144;0;137;0
WireConnection;242;0;241;0
WireConnection;242;1;46;0
WireConnection;242;2;243;0
WireConnection;284;0;242;0
WireConnection;280;0;232;0
WireConnection;280;1;256;0
WireConnection;274;0;270;0
WireConnection;274;1;263;0
WireConnection;37;0;138;0
WireConnection;260;0;259;0
WireConnection;34;0;208;0
WireConnection;34;1;207;0
WireConnection;34;2;214;0
WireConnection;207;0;17;0
WireConnection;208;0;26;0
WireConnection;26;0;24;0
WireConnection;26;1;23;0
WireConnection;26;2;16;0
WireConnection;17;0;1;0
WireConnection;17;1;14;0
WireConnection;17;2;16;0
WireConnection;199;0;196;0
WireConnection;199;1;242;0
WireConnection;199;2;44;0
WireConnection;39;0;37;0
WireConnection;196;0;248;0
WireConnection;196;1;189;0
WireConnection;263;0;264;0
WireConnection;12;0;11;0
WireConnection;273;0;261;0
WireConnection;273;1;263;0
WireConnection;41;0;143;0
WireConnection;52;0;158;0
WireConnection;248;0;12;0
WireConnection;248;1;279;0
WireConnection;189;0;209;0
WireConnection;189;1;206;0
WireConnection;189;2;188;0
WireConnection;261;0;271;0
WireConnection;261;1;236;0
WireConnection;267;0;261;0
WireConnection;267;1;273;0
WireConnection;209;0;34;0
WireConnection;271;0;260;0
WireConnection;271;1;275;0
WireConnection;44;0;41;0
WireConnection;206;0;205;0
WireConnection;206;1;204;0
WireConnection;206;2;214;0
WireConnection;7;0;4;0
WireConnection;7;1;8;0
WireConnection;11;0;157;0
WireConnection;143;0;39;0
WireConnection;143;1;140;0
WireConnection;143;2;141;0
WireConnection;203;0;277;0
WireConnection;203;2;202;0
WireConnection;275;0;274;0
WireConnection;257;0;232;0
WireConnection;257;1;256;0
WireConnection;258;0;257;0
WireConnection;283;0;281;0
WireConnection;283;1;285;0
WireConnection;283;2;280;0
WireConnection;4;0;3;0
WireConnection;4;1;10;0
WireConnection;51;0;158;0
WireConnection;265;0;251;0
WireConnection;247;0;52;0
WireConnection;162;0;160;0
WireConnection;259;0;258;0
WireConnection;53;0;51;0
WireConnection;53;1;179;0
WireConnection;171;0;174;0
WireConnection;179;0;52;0
WireConnection;158;0;50;0
WireConnection;58;0;53;0
WireConnection;264;0;265;0
WireConnection;173;0;172;0
WireConnection;173;2;186;0
WireConnection;183;0;203;0
WireConnection;157;0;7;0
WireConnection;146;0;145;0
WireConnection;277;0;175;4
WireConnection;277;1;164;4
WireConnection;277;2;276;0
WireConnection;16;0;151;0
WireConnection;185;0;162;1
WireConnection;185;1;184;0
WireConnection;175;0;174;0
WireConnection;175;1;170;0
WireConnection;161;0;166;0
WireConnection;161;2;185;0
WireConnection;138;0;137;0
WireConnection;251;0;250;0
WireConnection;165;0;162;0
WireConnection;165;1;161;0
WireConnection;151;0;146;0
WireConnection;151;1;149;0
WireConnection;151;2;150;0
WireConnection;269;0;249;0
WireConnection;268;1;267;0
WireConnection;268;2;199;0
WireConnection;186;0;184;0
WireConnection;186;1;171;1
WireConnection;170;0;171;0
WireConnection;170;1;173;0
WireConnection;249;0;247;0
WireConnection;164;0;160;0
WireConnection;164;1;165;0
WireConnection;0;2;283;0
ASEEND*/
//CHKSM=ABAAB98AED2AB9796305F206BA543CF944CDA90A