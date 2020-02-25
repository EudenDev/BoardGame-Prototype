// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox"
{
	Properties
	{
		_SunRadius("Sun Radius", Range( 0 , 1)) = 0
		_DayTopColor("DayTopColor", Color) = (0.5,0.5,0.5,1)
		_DayBottomColor("DayBottomColor", Color) = (1,1,1,1)
		_TopColor2("TopColor2", Color) = (0.5,0.5,0.5,1)
		_BottomColor2("BottomColor2", Color) = (1,1,1,1)
		_HorizonColorDay("HorizonColorDay", Color) = (0.9339623,0.703715,0,1)
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
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 uv_tex3coord;
			float3 worldPos;
		};

		uniform float4 _HorizonColorDay;
		uniform float _Lin;
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

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 normalizeResult137 = normalize( i.uv_tex3coord );
			float smoothstepResult143 = smoothstep( _Lin , 1.0 , ( 1.0 - abs( (normalizeResult137).y ) ));
			float temp_output_44_0 = saturate( ( smoothstepResult143 * (_WorldSpaceLightPos0.xyz).y ) );
			float4 temp_output_47_0 = ( _HorizonColorDay * temp_output_44_0 );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float smoothstepResult157 = smoothstep( 0.8 , 1.0 , ( distance( i.uv_tex3coord , ase_worldlightDir ) / _SunRadius ));
			float temp_output_12_0 = ( 1.0 - saturate( smoothstepResult157 ) );
			float3 NormalizedSkyCoords144 = normalizeResult137;
			float temp_output_146_0 = (NormalizedSkyCoords144).y;
			float smoothstepResult151 = smoothstep( _Min , _Float0 , temp_output_146_0);
			float temp_output_16_0 = saturate( smoothstepResult151 );
			float4 lerpResult26 = lerp( _BottomColor2 , _TopColor2 , temp_output_16_0);
			float4 lerpResult17 = lerp( _DayBottomColor , _DayTopColor , temp_output_16_0);
			float temp_output_33_0 = saturate( (_WorldSpaceLightPos0.xyz).y );
			float4 lerpResult34 = lerp( pow( lerpResult26 , 2.0 ) , pow( lerpResult17 , 2.0 ) , temp_output_33_0);
			float4 lerpResult206 = lerp( _CloudsColor2 , _CloudsColor1 , temp_output_33_0);
			float3 normalizeResult158 = normalize( ase_worldPos );
			float2 SkyUV58 = ( (normalizeResult158).xz / abs( (normalizeResult158).y ) );
			float2 panner161 = ( 1.0 * _Time.y * ( _TopClouds_ST.zw * _PanSpeedFactor ) + SkyUV58);
			float temp_output_169_0 = saturate( ase_worldPos.y );
			float2 panner173 = ( 1.0 * _Time.y * ( _PanSpeedFactor * _BottomClouds_ST.zw ) + SkyUV58);
			float temp_output_182_0 = ( ( tex2D( _TopClouds, ( _TopClouds_ST.xy * panner161 ) ).a * temp_output_169_0 ) + ( ( 1.0 - temp_output_169_0 ) * tex2D( _BottomClouds, ( _BottomClouds_ST.xy * panner173 ) ).a ) );
			float smoothstepResult203 = smoothstep( 0.0 , _CloudOpacity , temp_output_182_0);
			float BothClouds183 = smoothstepResult203;
			float4 lerpResult189 = lerp( sqrt( lerpResult34 ) , lerpResult206 , BothClouds183);
			float4 lerpResult199 = lerp( ( temp_output_12_0 + lerpResult189 ) , _HorizonColorDay , temp_output_44_0);
			o.Emission = ( temp_output_47_0 + lerpResult199 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
383;546;907;389;1214.526;908.7653;3.524212;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-3386.759,-565.7493;Inherit;False;1117.54;302.8414;Comment;7;50;158;51;52;179;53;58;Sky UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3354.18,-462.3875;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;158;-3157.765,-439.8774;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-2993.297,-376.0193;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;51;-2991.021,-508.8062;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;179;-2771.136,-355.2279;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2296.296,-1440.997;Inherit;False;1202.921;590.8865;Comment;12;44;37;39;43;41;42;138;137;132;140;141;143;Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-2630.499,-447.3827;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-337.4059,-1230.795;Inherit;True;Property;_BottomClouds;Bottom Clouds;10;0;Create;True;0;0;False;0;None;4508287bde7544c9996d6675d8a0e09e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;160;-320.4286,-1665.855;Inherit;True;Property;_TopClouds;Top Clouds;9;0;Create;True;0;0;False;0;None;7ca76aff75cdb4846a2ea5cba396b9a9;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;132;-2267.697,-1277.117;Inherit;False;0;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2484.667,-511.6849;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;171;-95.0723,-1114.464;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.NormalizeNode;137;-2067.76,-1295.563;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureTransformNode;162;-43.28499,-1551.825;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;184;-244.3315,-1341.155;Inherit;False;Property;_PanSpeedFactor;PanSpeedFactor;21;0;Create;True;0;0;False;0;1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-106.687,-1447.014;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;109.712,-1159.764;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-50.74096,-980.3967;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;84.23831,-1356.759;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1871.671,-1543.869;Inherit;False;NormalizedSkyCoords;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;173;266.1242,-1021.195;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;161;252.5088,-1442.448;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-3744.978,685.6467;Inherit;False;144;NormalizedSkyCoords;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;168;564.0676,-1402.503;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;443.8221,-1110.82;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;169;769.5667,-1391.191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;454.8514,-1547.341;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-3440.044,658.845;Inherit;False;Property;_Float0;Float 0;20;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;146;-3483.895,769.6075;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-3438.356,588.0159;Inherit;False;Property;_Min;Min;19;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;164;629.8645,-1655.241;Inherit;True;Property;_TextureSample3;Texture Sample 3;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-2781.707,826.0168;Inherit;False;823.2188;509.2692;Comment;3;26;24;23;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;180;936.7365,-1304.324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;601.8524,-1222.974;Inherit;True;Property;_TextureSample4;Texture Sample 4;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;20;-2791.107,165.9355;Inherit;False;823.2188;509.2692;Comment;4;16;14;1;17;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2066.688,-602.9641;Inherit;False;1115.065;507.5304;;8;10;3;4;8;7;11;12;157;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;151;-3165.764,736.9287;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2016.688,-552.9641;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;1116.353,-1227.888;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;1120.386,-1468.063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;27;-2086.373,716.1807;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-2016.164,-356.7484;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;24;-2658.739,876.0168;Inherit;False;Property;_BottomColor2;BottomColor2;4;0;Create;True;0;0;False;0;1,1,1,1;0.1076005,0.3524326,0.735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-2440.399,1015.465;Inherit;False;Property;_TopColor2;TopColor2;3;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.03844785,0.1034186,0.3018866,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-2449.8,346.6889;Inherit;False;Property;_DayTopColor;DayTopColor;1;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.07075451,0.5578593,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-2498.923,557.0095;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-2668.139,207.2404;Inherit;False;Property;_DayBottomColor;DayBottomColor;2;0;Create;True;0;0;False;0;1,1,1,1;0.485849,0.951307,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;32;-1846.631,677.7899;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;1310.813,-1346.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;4;-1687.099,-451.1087;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;1155.751,-1079.446;Inherit;False;Property;_CloudOpacity;Cloud Opacity;22;0;Create;True;0;0;False;0;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;138;-1900.945,-1259.045;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1829.269,-209.9338;Inherit;False;Property;_SunRadius;Sun Radius;0;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-2154.388,319.5592;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;-2144.988,988.3355;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;37;-1854.383,-1127.277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-1511.9,-328.6594;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-1600.537,835.6164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;203;1506.471,-1118.589;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;208;-1804.109,792.1348;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;207;-1754.138,375.8981;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;205;-1766.704,950.3344;Inherit;False;Property;_CloudsColor2;Clouds Color 2;23;0;Create;True;0;0;False;0;0.6415094,0.6415094,0.6415094,1;0.1023941,0.2516221,0.5566037,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightPos;42;-2040.39,-988.0165;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;141;-1748.952,-1330.017;Inherit;False;Constant;_Max;Max;17;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-1376.082,-300.1821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.8;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;1681.611,-1342.703;Inherit;False;BothClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-1748.534,-1405.737;Inherit;False;Property;_Lin;Lin;18;0;Create;True;0;0;False;0;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1717.839,-1172.77;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;204;-1617.67,1144.082;Inherit;False;Property;_CloudsColor1;Clouds Color 1;24;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;34;-1386.674,595.631;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-1757.698,-1003.254;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-1241.29,-418.9528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;206;-1368.565,888.5914;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SqrtOpNode;209;-1050.823,644.8245;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-993.459,920.3022;Inherit;False;183;BothClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;143;-1545.588,-1251.911;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-1108.682,-491.604;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1366.471,-1174.301;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;189;-769.1822,589.1982;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;44;-1210.584,-1116.595;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;196;-432.7861,239.121;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-983.7549,-1255.52;Inherit;False;Property;_HorizonColorDay;HorizonColorDay;6;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;0.5845941,0.7482698,0.8207547,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;199;-242.0542,3.178413;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-575.8018,-1070.674;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;200;-26.95581,70.58688;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;103;-600.3314,-2102.753;Inherit;False;Property;_CloudColorDayMain;Cloud Color Day Main;16;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-380.4001,-3414.047;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;457.5459,-2721.083;Inherit;False;Clouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2351.951,-3194.162;Inherit;False;82;Noise1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-342.2926,-2750.082;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-616.6982,-2743.51;Inherit;False;Property;_Fuzziness;Fuzziness;17;0;Create;True;0;0;False;0;0;0.091;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-981.9251,-3342.075;Inherit;False;Noise2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1187.204,-308.8258;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;87;-2036.758,-3439.85;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-707.3654,-509.7778;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;107;-62.27646,-2776.765;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;77;-1391.253,-2724.603;Inherit;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2338.753,-2555.142;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-2342.381,-3329.15;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-17.50007,-3251.21;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-624.66,-3381.481;Inherit;False;93;Noise2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;408.0603,-1985.373;Inherit;False;ColoredClouds;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;814.54,-2530.831;Inherit;False;NegativeClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;574.6545,-2435.921;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-2348.323,-2420.154;Inherit;False;79;BaseNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-544.7187,-1859.318;Inherit;False;110;Clouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1587.566,-2593.487;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1030.616,-1390.809;Inherit;False;Horizon;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-1286.974,379.5654;Inherit;False;115;NegativeClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;114;391.4452,-2521.435;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;201;1531.522,-1243.846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-2391.943,-2215.385;Inherit;True;Property;_BaseNoise;Base Noise;8;0;Create;True;0;0;False;0;None;66294b357d77e4895b0620323b0bf50a;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-993.0109,-2770.621;Inherit;False;Noise1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-1010.261,-2153.376;Inherit;False;BaseNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;92;86.7887,10.64087;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;820.5745,-526.9363;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureTransformNode;72;-2033.13,-2665.842;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;97;-627.0121,-3503.867;Inherit;False;82;Noise1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;-590.1357,-2327.068;Inherit;False;Property;_CloudColorDay;Cloud Color Day;15;0;Create;True;0;0;False;0;1,1,1,1;0.6376379,0.7342289,0.8396226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;78;-2342.437,-2906.578;Inherit;True;Property;_Distort;Distort;11;0;Create;True;0;0;False;0;None;5f7b6436dbf0b4af6979b05addd942f8;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SaturateNode;96;-350.1434,-3196.449;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;75;-1800.128,-2508.191;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-460.1875,-2573.033;Inherit;False;101;FinalNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-71.92905,-657.956;Inherit;False;116;ColoredClouds;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-1444.071,-2145.775;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;104;-121.6136,-2195.574;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureTransformNode;71;-2085.947,-2087.014;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.ToggleSwitchNode;56;463.7934,-428.6205;Inherit;False;Property;_DEBUGMODE;DEBUG MODE;7;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;148;-3182.025,611.626;Inherit;False;Inverse Lerp;-1;;1;1d15e5a66786740d990418a561b6d544;0;3;2;FLOAT;0;False;1;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;110.3019,-2058.37;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;458.7923,-2137.805;Inherit;False;DEBUG;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;99;-198.9501,-3358.219;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;94;-613.6616,-3186.334;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;120;186.4835,-518.9892;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;88;-1803.756,-3282.199;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-113.7573,-515.3387;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;272.0411,-3284.909;Inherit;False;FinalNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-160.9063,-187.6142;Inherit;False;55;DEBUG;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-2076.835,-3200.415;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-525.6871,-298.9258;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1640.384,-2014.659;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1591.194,-3367.495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1049.151,473.9395;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;84;-2346.065,-3680.586;Inherit;True;Property;_Texture0;Texture 0;12;0;Create;True;0;0;False;0;None;19b30a2157e14480cb45a61f80f23845;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-623.1458,-2862.092;Inherit;False;Property;_CloudCutOff;Cloud CutOff;14;0;Create;True;0;0;False;0;0;0.398;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2170.645,-1861.681;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-945.1881,-604.1519;Inherit;False;115;NegativeClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;63;-1852.946,-1929.363;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2073.207,-2426.407;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;113;177.424,-2653.213;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;368.0672,-2379.544;Inherit;False;126;Horizon;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-1394.881,-3498.611;Inherit;True;Property;_TextureSample2;Texture Sample 2;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;91;200.0079,-194.7006;Inherit;False;Property;_FRACTDEBUG;FRACT DEBUG;13;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1133.12,-548.3322;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;158;0;50;0
WireConnection;52;0;158;0
WireConnection;51;0;158;0
WireConnection;179;0;52;0
WireConnection;53;0;51;0
WireConnection;53;1;179;0
WireConnection;58;0;53;0
WireConnection;171;0;174;0
WireConnection;137;0;132;0
WireConnection;162;0;160;0
WireConnection;186;0;184;0
WireConnection;186;1;171;1
WireConnection;185;0;162;1
WireConnection;185;1;184;0
WireConnection;144;0;137;0
WireConnection;173;0;172;0
WireConnection;173;2;186;0
WireConnection;161;0;166;0
WireConnection;161;2;185;0
WireConnection;170;0;171;0
WireConnection;170;1;173;0
WireConnection;169;0;168;2
WireConnection;165;0;162;0
WireConnection;165;1;161;0
WireConnection;146;0;145;0
WireConnection;164;0;160;0
WireConnection;164;1;165;0
WireConnection;180;0;169;0
WireConnection;175;0;174;0
WireConnection;175;1;170;0
WireConnection;151;0;146;0
WireConnection;151;1;149;0
WireConnection;151;2;150;0
WireConnection;181;0;180;0
WireConnection;181;1;175;4
WireConnection;176;0;164;4
WireConnection;176;1;169;0
WireConnection;16;0;151;0
WireConnection;32;0;27;1
WireConnection;182;0;176;0
WireConnection;182;1;181;0
WireConnection;4;0;3;0
WireConnection;4;1;10;0
WireConnection;138;0;137;0
WireConnection;17;0;1;0
WireConnection;17;1;14;0
WireConnection;17;2;16;0
WireConnection;26;0;24;0
WireConnection;26;1;23;0
WireConnection;26;2;16;0
WireConnection;37;0;138;0
WireConnection;7;0;4;0
WireConnection;7;1;8;0
WireConnection;33;0;32;0
WireConnection;203;0;182;0
WireConnection;203;2;202;0
WireConnection;208;0;26;0
WireConnection;207;0;17;0
WireConnection;157;0;7;0
WireConnection;183;0;203;0
WireConnection;39;0;37;0
WireConnection;34;0;208;0
WireConnection;34;1;207;0
WireConnection;34;2;33;0
WireConnection;43;0;42;1
WireConnection;11;0;157;0
WireConnection;206;0;205;0
WireConnection;206;1;204;0
WireConnection;206;2;33;0
WireConnection;209;0;34;0
WireConnection;143;0;39;0
WireConnection;143;1;140;0
WireConnection;143;2;141;0
WireConnection;12;0;11;0
WireConnection;41;0;143;0
WireConnection;41;1;43;0
WireConnection;189;0;209;0
WireConnection;189;1;206;0
WireConnection;189;2;188;0
WireConnection;44;0;41;0
WireConnection;196;0;12;0
WireConnection;196;1;189;0
WireConnection;199;0;196;0
WireConnection;199;1;46;0
WireConnection;199;2;44;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;200;0;199;0
WireConnection;95;0;97;0
WireConnection;95;1;98;0
WireConnection;110;0;113;0
WireConnection;108;0;105;0
WireConnection;108;1;106;0
WireConnection;93;0;90;1
WireConnection;87;0;84;0
WireConnection;127;0;12;0
WireConnection;127;1;128;0
WireConnection;107;0;105;0
WireConnection;107;1;108;0
WireConnection;107;2;109;0
WireConnection;77;0;78;0
WireConnection;77;1;76;0
WireConnection;100;0;99;0
WireConnection;100;1;96;0
WireConnection;116;0;112;0
WireConnection;115;0;124;0
WireConnection;124;0;114;0
WireConnection;124;1;125;0
WireConnection;76;0;72;0
WireConnection;76;1;75;0
WireConnection;126;0;44;0
WireConnection;114;0;113;0
WireConnection;201;0;182;0
WireConnection;201;1;202;0
WireConnection;82;0;77;1
WireConnection;79;0;60;1
WireConnection;92;0;57;0
WireConnection;198;0;47;0
WireConnection;198;1;200;0
WireConnection;72;0;78;0
WireConnection;96;0;94;2
WireConnection;75;0;80;0
WireConnection;75;2;72;1
WireConnection;60;0;65;0
WireConnection;60;1;70;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;104;2;111;0
WireConnection;71;0;65;0
WireConnection;56;0;120;0
WireConnection;56;1;91;0
WireConnection;148;2;146;0
WireConnection;148;1;149;0
WireConnection;148;3;150;0
WireConnection;112;0;104;0
WireConnection;112;1;111;0
WireConnection;99;0;95;0
WireConnection;120;0;121;0
WireConnection;120;1;49;0
WireConnection;88;0;86;0
WireConnection;88;2;87;1
WireConnection;49;0;47;0
WireConnection;49;1;123;0
WireConnection;101;0;100;0
WireConnection;86;0;85;0
WireConnection;86;1;83;0
WireConnection;123;0;129;0
WireConnection;123;1;127;0
WireConnection;70;0;71;0
WireConnection;70;1;63;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;129;0;34;0
WireConnection;129;1;130;0
WireConnection;63;0;62;0
WireConnection;63;2;71;1
WireConnection;80;0;73;0
WireConnection;80;1;81;0
WireConnection;113;0;107;0
WireConnection;90;0;84;0
WireConnection;90;1;89;0
WireConnection;91;0;57;0
WireConnection;91;1;92;0
WireConnection;0;2;198;0
ASEEND*/
//CHKSM=73EB2AD42FEBE1F28AB5B1664415B0F79B07D87D