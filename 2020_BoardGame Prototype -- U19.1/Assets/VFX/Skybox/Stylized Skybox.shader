// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EudenVFX/Skybox"
{
	Properties
	{
		_DayBottomColor("DayBottomColor", Color) = (1,1,1,1)
		_Color1("Color 1", Color) = (1,1,1,1)
		_SunRadius("Sun Radius", Range( 0 , 1)) = 0
		_DayTopColor("DayTopColor", Color) = (0.5,0.5,0.5,1)
		_Color2("Color 2", Color) = (0.5,0.5,0.5,1)
		_HorizonColorDay("HorizonColorDay", Color) = (0.9339623,0.703715,0,1)
		[Toggle]_DEBUGMODE("DEBUG MODE", Float) = 0
		_BaseNoise("Base Noise", 2D) = "white" {}
		_Distort("Distort", 2D) = "white" {}
		_Distort1("Distort", 2D) = "white" {}
		[Toggle]_FRACTDEBUG("FRACT DEBUG", Float) = 0
		_CloudCutOff("Cloud CutOff", Float) = 0
		_CloudColorDay("Cloud Color Day", Color) = (1,1,1,1)
		_CloudColorDayMain("Cloud Color Day Main", Color) = (1,1,1,1)
		_Fuzziness("Fuzziness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
			float3 uv_tex3coord;
		};

		uniform float _DEBUGMODE;
		uniform float4 _CloudColorDay;
		uniform float4 _CloudColorDayMain;
		uniform float _CloudCutOff;
		uniform float _Fuzziness;
		uniform sampler2D _Distort;
		uniform float4 _Distort_ST;
		uniform sampler2D _BaseNoise;
		uniform float4 _BaseNoise_ST;
		uniform sampler2D _Distort1;
		uniform float4 _Distort1_ST;
		uniform float4 _HorizonColorDay;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float4 _DayBottomColor;
		uniform float4 _DayTopColor;
		uniform float _SunRadius;
		uniform float _FRACTDEBUG;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 SkyUV58 = ( (ase_worldPos).xz / (ase_worldPos).y );
			float2 panner63 = ( 1.0 * _Time.y * _BaseNoise_ST.zw + SkyUV58);
			float BaseNoise79 = tex2D( _BaseNoise, ( _BaseNoise_ST.xy * panner63 ) ).r;
			float2 panner75 = ( 1.0 * _Time.y * _Distort_ST.zw + ( SkyUV58 + BaseNoise79 ));
			float Noise182 = tex2D( _Distort, ( _Distort_ST.xy * panner75 ) ).r;
			float2 panner88 = ( 1.0 * _Time.y * _Distort1_ST.zw + ( SkyUV58 + Noise182 ));
			float Noise293 = tex2D( _Distort1, ( _Distort1_ST.xy * panner88 ) ).r;
			float FinalNoise101 = ( saturate( ( Noise182 * Noise293 ) ) * saturate( ase_worldPos.y ) );
			float smoothstepResult107 = smoothstep( ( _CloudCutOff + _Fuzziness ) , FinalNoise101 , _CloudCutOff);
			float temp_output_113_0 = saturate( smoothstepResult107 );
			float Clouds110 = temp_output_113_0;
			float4 lerpResult104 = lerp( _CloudColorDay , _CloudColorDayMain , Clouds110);
			float4 ColoredClouds116 = ( lerpResult104 * Clouds110 );
			float temp_output_44_0 = saturate( ( ( 1.0 - abs( i.uv_texcoord.y ) ) * (_WorldSpaceLightPos0.xyz).y ) );
			float4 lerpResult26 = lerp( _Color1 , _Color2 , saturate( i.uv_texcoord.y ));
			float4 lerpResult17 = lerp( _DayBottomColor , _DayTopColor , saturate( i.uv_texcoord.y ));
			float4 lerpResult34 = lerp( lerpResult26 , lerpResult17 , saturate( (_WorldSpaceLightPos0.xyz).y ));
			float Horizon126 = temp_output_44_0;
			float NegativeClouds115 = ( ( 1.0 - temp_output_113_0 ) * Horizon126 );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float4 DEBUG55 = float4( 0,0,0,0 );
			o.Emission = (( _DEBUGMODE )?( (( _FRACTDEBUG )?( frac( DEBUG55 ) ):( DEBUG55 )) ):( ( ColoredClouds116 + ( ( _HorizonColorDay * temp_output_44_0 ) + ( ( lerpResult34 * NegativeClouds115 ) + ( ( 1.0 - saturate( ( distance( i.uv_tex3coord , ase_worldlightDir ) / _SunRadius ) ) ) * NegativeClouds115 ) ) ) ) )).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17700
384;514;907;421;1043.073;997.8707;2.103546;True;False
Node;AmplifyShaderEditor.CommentaryNode;59;-3355.527,-845.6082;Inherit;False;920.937;305.6187;Comment;5;50;51;52;58;53;Sky UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;-3305.527,-723.5572;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ComponentMaskNode;51;-3092.514,-795.6082;Inherit;False;True;False;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;52;-3080.624,-654.4896;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;53;-2855.581,-742.5164;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-2391.943,-2215.385;Inherit;True;Property;_BaseNoise;Base Noise;8;0;Create;True;0;0;False;0;None;66294b357d77e4895b0620323b0bf50a;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2668.09,-791.5439;Inherit;False;SkyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;71;-2085.947,-2087.014;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2170.645,-1861.681;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;63;-1852.946,-1929.363;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1640.384,-2014.659;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;60;-1444.071,-2145.775;Inherit;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-1010.261,-2153.376;Inherit;False;BaseNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-2348.323,-2420.154;Inherit;False;79;BaseNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;78;-2342.437,-2906.578;Inherit;True;Property;_Distort;Distort;9;0;Create;True;0;0;False;0;None;5f7b6436dbf0b4af6979b05addd942f8;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2338.753,-2555.142;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2073.207,-2426.407;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;72;-2033.13,-2665.842;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.PannerNode;75;-1800.128,-2508.191;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1587.566,-2593.487;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;77;-1391.253,-2724.603;Inherit;True;Property;_TextureSample1;Texture Sample 0;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-993.0109,-2770.621;Inherit;False;Noise1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2351.951,-3194.162;Inherit;False;82;Noise1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;84;-2346.065,-3680.586;Inherit;True;Property;_Distort1;Distort;10;0;Create;True;0;0;False;0;None;19b30a2157e14480cb45a61f80f23845;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-2342.381,-3329.15;Inherit;False;58;SkyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-2076.835,-3200.415;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;87;-2036.758,-3439.85;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.PannerNode;88;-1803.756,-3282.199;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-1591.194,-3367.495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;90;-1394.881,-3498.611;Inherit;True;Property;_TextureSample2;Texture Sample 0;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-981.9251,-3342.075;Inherit;False;Noise2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-351.1061,-3157.38;Inherit;False;82;Noise1;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;-348.754,-3034.994;Inherit;False;93;Noise2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;94;-337.7556,-2839.847;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-104.4943,-3067.56;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;48;-2154.542,-1440.997;Inherit;False;1061.167;588.9177;Comment;7;36;37;42;43;39;41;44;Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2104.542,-1224.601;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;99;76.95573,-3011.732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;96;-60.94841,-2835.196;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;42;-2022.671,-984.0789;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;258.4057,-2904.723;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;37;-1852.414,-1269.031;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-347.2398,-2515.605;Inherit;False;Property;_CloudCutOff;Cloud CutOff;12;0;Create;True;0;0;False;0;0;0.398;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-340.7922,-2397.023;Inherit;False;Property;_Fuzziness;Fuzziness;15;0;Create;True;0;0;False;0;0;0.091;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-1653.105,-1179.321;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;43;-1757.698,-1003.254;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;547.9469,-2938.422;Inherit;False;FinalNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-66.38681,-2403.595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1456.119,-1113.078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-184.2818,-2226.546;Inherit;False;101;FinalNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;13;-2066.688,-602.9641;Inherit;False;1115.065;507.5304;;7;10;3;4;8;7;11;12;Sky Circle;0.4716981,0.4472232,0.4472232,1;0;0
Node;AmplifyShaderEditor.SaturateNode;44;-1260.875,-1107.849;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;107;213.6293,-2430.278;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2781.707,826.0168;Inherit;False;823.2188;509.2692;Comment;5;26;25;24;23;22;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2791.107,165.9355;Inherit;False;823.2188;509.2692;Comment;5;16;14;1;15;17;Day gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2016.688,-552.9641;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;113;453.3297,-2306.726;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;10;-2016.164,-356.7484;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1076.616,-1371.809;Inherit;False;Horizon;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;114;667.3511,-2174.948;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1829.269,-209.9338;Inherit;False;Property;_SunRadius;Sun Radius;2;0;Create;True;0;0;False;0;0;0.105;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;643.9731,-2033.057;Inherit;False;126;Horizon;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-2731.707,1110.987;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-2741.107,442.2103;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightPos;27;-2086.373,716.1807;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;4;-1687.099,-451.1087;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-2441.657,1225.786;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-2449.8,346.6889;Inherit;False;Property;_DayTopColor;DayTopColor;3;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.4951938,0.7485893,0.9811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-2451.058,557.0095;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-2658.739,876.0168;Inherit;False;Property;_Color1;Color 1;1;0;Create;True;0;0;False;0;1,1,1,1;0.5188676,0.5188676,0.5188676,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;850.5606,-2089.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;7;-1459.02,-330.1283;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-2668.139,207.2404;Inherit;False;Property;_DayBottomColor;DayBottomColor;0;0;Create;True;0;0;False;0;1,1,1,1;0.5188676,0.5188676,0.5188676,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;32;-1781.099,671.9642;Inherit;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-2440.399,1015.465;Inherit;False;Property;_Color2;Color 2;4;0;Create;True;0;0;False;0;0.5,0.5,0.5,1;0.4163645,0.1861422,0.8396226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;733.4518,-2374.596;Inherit;False;Clouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;1090.446,-2184.344;Inherit;False;NegativeClouds;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-2154.388,319.5592;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;33;-1562.541,869.033;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-2144.988,988.3355;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-268.8128,-1512.832;Inherit;False;110;Clouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;-314.2297,-1980.581;Inherit;False;Property;_CloudColorDay;Cloud Color Day;13;0;Create;True;0;0;False;0;1,1,1,1;0.6376379,0.7342289,0.8396226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;103;-324.4254,-1756.267;Inherit;False;Property;_CloudColorDayMain;Cloud Color Day Main;14;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-1321.081,-418.1323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;12;-1135.123,-481.3217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-945.1881,-604.1519;Inherit;False;115;NegativeClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-1234.082,638.4277;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-1286.974,379.5654;Inherit;False;115;NegativeClouds;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;154.2922,-1849.087;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-883.5503,-1226.572;Inherit;False;Property;_HorizonColorDay;HorizonColorDay;6;0;Create;True;0;0;False;0;0.9339623,0.703715,0,1;0.9339623,0.703715,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-707.3654,-509.7778;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;386.2076,-1711.884;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;734.6982,-1791.318;Inherit;False;DEBUG;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1049.151,473.9395;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;683.9661,-1638.887;Inherit;False;ColoredClouds;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-525.6871,-298.9258;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-483.1018,-1006.313;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-160.9063,-187.6142;Inherit;False;55;DEBUG;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FractNode;92;86.7887,10.64087;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;20.6411,-808.9915;Inherit;False;116;ColoredClouds;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-113.7573,-515.3387;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;91;200.0079,-194.7006;Inherit;False;Property;_FRACTDEBUG;FRACT DEBUG;11;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;120;308.2863,-616.4316;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;56;644.0615,-438.3647;Inherit;False;Property;_DEBUGMODE;DEBUG MODE;7;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-1187.204,-308.8258;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;930.4473,-558.9047;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;EudenVFX/Skybox;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;50;0
WireConnection;52;0;50;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;58;0;53;0
WireConnection;71;0;65;0
WireConnection;63;0;62;0
WireConnection;63;2;71;1
WireConnection;70;0;71;0
WireConnection;70;1;63;0
WireConnection;60;0;65;0
WireConnection;60;1;70;0
WireConnection;79;0;60;1
WireConnection;80;0;73;0
WireConnection;80;1;81;0
WireConnection;72;0;78;0
WireConnection;75;0;80;0
WireConnection;75;2;72;1
WireConnection;76;0;72;0
WireConnection;76;1;75;0
WireConnection;77;0;78;0
WireConnection;77;1;76;0
WireConnection;82;0;77;1
WireConnection;86;0;85;0
WireConnection;86;1;83;0
WireConnection;87;0;84;0
WireConnection;88;0;86;0
WireConnection;88;2;87;1
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;90;0;84;0
WireConnection;90;1;89;0
WireConnection;93;0;90;1
WireConnection;95;0;97;0
WireConnection;95;1;98;0
WireConnection;99;0;95;0
WireConnection;96;0;94;2
WireConnection;100;0;99;0
WireConnection;100;1;96;0
WireConnection;37;0;36;2
WireConnection;39;0;37;0
WireConnection;43;0;42;1
WireConnection;101;0;100;0
WireConnection;108;0;105;0
WireConnection;108;1;106;0
WireConnection;41;0;39;0
WireConnection;41;1;43;0
WireConnection;44;0;41;0
WireConnection;107;0;105;0
WireConnection;107;1;108;0
WireConnection;107;2;109;0
WireConnection;113;0;107;0
WireConnection;126;0;44;0
WireConnection;114;0;113;0
WireConnection;4;0;3;0
WireConnection;4;1;10;0
WireConnection;22;0;25;2
WireConnection;16;0;15;2
WireConnection;124;0;114;0
WireConnection;124;1;125;0
WireConnection;7;0;4;0
WireConnection;7;1;8;0
WireConnection;32;0;27;1
WireConnection;110;0;113;0
WireConnection;115;0;124;0
WireConnection;17;0;1;0
WireConnection;17;1;14;0
WireConnection;17;2;16;0
WireConnection;33;0;32;0
WireConnection;26;0;24;0
WireConnection;26;1;23;0
WireConnection;26;2;22;0
WireConnection;11;0;7;0
WireConnection;12;0;11;0
WireConnection;34;0;26;0
WireConnection;34;1;17;0
WireConnection;34;2;33;0
WireConnection;104;0;102;0
WireConnection;104;1;103;0
WireConnection;104;2;111;0
WireConnection;127;0;12;0
WireConnection;127;1;128;0
WireConnection;112;0;104;0
WireConnection;112;1;111;0
WireConnection;129;0;34;0
WireConnection;129;1;130;0
WireConnection;116;0;112;0
WireConnection;123;0;129;0
WireConnection;123;1;127;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;92;0;57;0
WireConnection;49;0;47;0
WireConnection;49;1;123;0
WireConnection;91;0;57;0
WireConnection;91;1;92;0
WireConnection;120;0;121;0
WireConnection;120;1;49;0
WireConnection;56;0;120;0
WireConnection;56;1;91;0
WireConnection;0;2;56;0
ASEEND*/
//CHKSM=5EF3FC6CD3D418F8ADAC140D8550D73680D966F5