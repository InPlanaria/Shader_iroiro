// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InPlanaria/AmplifyStandard_Rotate90"
{
	Properties
	{
		_DetailMask("_DetailMask", 2D) = "white" {}
		_DetailAlbedoMap("_DetailAlbedoMap", 2D) = "gray" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_BumpMap("_BumpMap", 2D) = "bump" {}
		_DetailNormalMap("_DetailNormalMap", 2D) = "bump" {}
		_MetallicGlossMap("_MetallicGlossMap", 2D) = "white" {}
		_EmissionMap("_EmissionMap", 2D) = "white" {}
		_Glossiness("_Glossiness", Range( 0 , 1)) = 0.5
		_Metallic("_Metallic", Range( 0 , 1)) = 0.5
		_OcclusionStrength("_OcclusionStrength", Range( 0 , 1)) = 1
		_BumpScale("_BumpScale", Float) = 1
		_DetailNormalMapScale("_DetailNormalMapScale", Float) = 1
		_Color("_Color", Color) = (1,1,1,1)
		_DetialColor("_DetialColor", Color) = (1,1,1,1)
		[HDR]_EmissionColor("_EmissionColor", Color) = (0,0,0,0)
		_MainTexTilingU("_MainTexTilingU", Float) = 1
		_DetialTilingU("_DetialTilingU", Float) = 1
		_OcclusionMap("_OcclusionMap", 2D) = "white" {}
		_DetialTexOffsetU("_DetialTexOffsetU", Float) = 1
		_MainTexOffsetU("_MainTexOffsetU", Float) = 1
		_MainTexOffsetV("_MainTexOffsetV", Float) = 1
		_DetialTexOffsetV("_DetialTexOffsetV", Float) = 1
		_MainTexTilingV("_MainTexTilingV", Float) = 1
		_DetialTilingV("_DetialTilingV", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BumpMap;
		uniform float _MainTexTilingU;
		uniform float _MainTexOffsetU;
		uniform float _MainTexTilingV;
		uniform float _MainTexOffsetV;
		uniform float _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float _DetialTilingU;
		uniform float _DetialTexOffsetU;
		uniform float _DetialTilingV;
		uniform float _DetialTexOffsetV;
		uniform float _DetailNormalMapScale;
		uniform sampler2D _DetailMask;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _DetialColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Glossiness;
		uniform sampler2D _OcclusionMap;
		uniform float _OcclusionStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult107 = (float2(( ( -i.uv_texcoord.y * _MainTexTilingU ) + _MainTexOffsetU ) , ( ( i.uv_texcoord.x * _MainTexTilingV ) + _MainTexOffsetV )));
			float2 UVLocalVar108 = appendResult107;
			float3 tex2DNode214 = UnpackScaleNormal( tex2D( _BumpMap, UVLocalVar108 ), _BumpScale );
			float2 appendResult136 = (float2(( ( -i.uv_texcoord.y * _DetialTilingU ) + _DetialTexOffsetU ) , ( ( i.uv_texcoord.x * _DetialTilingV ) + _DetialTexOffsetV )));
			float2 UVLocalVar_Detial126 = appendResult136;
			float3 normalizeResult238 = normalize( ( tex2DNode214 + UnpackScaleNormal( tex2D( _DetailNormalMap, UVLocalVar_Detial126 ), _DetailNormalMapScale ) ) );
			float DetialMaskVar227 = ( 1.0 - tex2D( _DetailMask, UVLocalVar108 ).b );
			float3 lerpResult244 = lerp( normalizeResult238 , tex2DNode214 , DetialMaskVar227);
			o.Normal = lerpResult244;
			float4 temp_output_223_0 = ( _Color * tex2D( _MainTex, UVLocalVar108 ) );
			float4 blendOpSrc237 = temp_output_223_0;
			float4 blendOpDest237 = ( ( _DetialColor * tex2D( _DetailAlbedoMap, UVLocalVar_Detial126 ) ) * float4(2,2,2,2) );
			float4 lerpResult243 = lerp( ( saturate( (( blendOpDest237 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest237 ) * ( 1.0 - blendOpSrc237 ) ) : ( 2.0 * blendOpDest237 * blendOpSrc237 ) ) )) , temp_output_223_0 , DetialMaskVar227);
			o.Albedo = lerpResult243.rgb;
			o.Emission = ( tex2D( _EmissionMap, UVLocalVar108 ) * _EmissionColor ).rgb;
			float4 tex2DNode229 = tex2D( _MetallicGlossMap, UVLocalVar108 );
			o.Metallic = ( _Metallic * tex2DNode229.r );
			o.Smoothness = ( tex2DNode229.a * _Glossiness );
			o.Occlusion = ( 1.0 - ( ( 1.0 - tex2D( _OcclusionMap, UVLocalVar108 ).g ) * _OcclusionStrength ) );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-2222.935,-148.6259;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;127;-2285.458,388.5081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-1983.915,-141.2962;Float;False;Property;_MainTexTilingU;_MainTexTilingU;15;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2008.094,-12.09575;Float;False;Property;_MainTexTilingV;_MainTexTilingV;22;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;106;-1974.245,-281.4645;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2046.438,395.8378;Float;False;Property;_DetialTilingU;_DetialTilingU;16;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-2070.616,525.0383;Float;False;Property;_DetialTilingV;_DetialTilingV;23;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;128;-2014.883,284.1167;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1767.024,-144.6431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1770.141,-37.63273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1754.093,85.47176;Float;False;Property;_MainTexOffsetV;_MainTexOffsetV;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1764.892,-219.1283;Float;False;Property;_MainTexOffsetU;_MainTexOffsetU;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1816.614,622.6058;Float;False;Property;_DetialTexOffsetV;_DetialTexOffsetV;21;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1827.413,318.0057;Float;False;Property;_DetialTexOffsetU;_DetialTexOffsetU;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1814.286,401.6163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1810.417,501.2544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1545.119,30.66457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-1552.718,-152.2355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-1607.64,567.7986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-1615.239,384.8985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-1399.096,-122.7509;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-1461.617,414.3831;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1322.827,348.189;Inherit;False;UVLocalVar_Detial;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1208.393,-126.6547;Inherit;False;UVLocalVar;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;203;-1274.457,2348.436;Float;True;Property;_DetailAlbedoMap;_DetailAlbedoMap;1;0;Create;True;0;0;0;False;0;False;None;77de4320524a5c8449f1bb037f74b6d2;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;204;595.192,2078.18;Float;True;Property;_DetailMask;_DetailMask;0;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;249;-953.8757,2540.216;Inherit;False;126;UVLocalVar_Detial;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;591.2123,2331.17;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;205;-1278.578,2667.625;Float;True;Property;_DetailNormalMap;_DetailNormalMap;4;0;Create;True;0;0;0;False;0;False;None;dbdeda8feb14d4549b92854c9f22e2c6;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;206;-1384.502,959.9248;Float;True;Property;_BumpMap;_BumpMap;3;0;Create;True;0;0;0;False;0;False;None;bed3ff734dc842e41b002717a29a39d2;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;207;-1123.582,1085.819;Float;False;Property;_BumpScale;_BumpScale;10;0;Create;True;0;0;0;False;0;False;1;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;208;-1059.115,663.8093;Float;True;Property;_MainTex;_MainTex;2;0;Create;True;0;0;0;False;0;False;None;43cadd90ae469a441afb26cd9b2ef3b7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;209;-916.8583,2332.264;Inherit;True;Property;_TextureSample3;Texture Sample 3;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;210;-826.0959,2144.184;Inherit;False;Property;_DetialColor;_DetialColor;13;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;211;-1285.099,2874.297;Float;False;Property;_DetailNormalMapScale;_DetailNormalMapScale;11;0;Create;True;0;0;0;False;0;False;1;6.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;212;845.4154,2093.031;Inherit;True;Property;_TextureSample0;Texture Sample 0;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;245;-977.5559,868.43;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;-943.6349,1179.455;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;250;-942.8757,2872.216;Inherit;False;126;UVLocalVar_Detial;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;363.2123,1820.17;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;213;-801.9846,2664.438;Inherit;True;Property;_TextureSample2;Texture Sample 2;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;214;-708.1381,1018.599;Inherit;True;Property;_TextureSample6;Texture Sample 6;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;215;-747.0798,521.7334;Inherit;False;Property;_Color;_Color;12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;216;-769.3162,694.7676;Inherit;True;Property;_TextureSample7;Texture Sample 7;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;-574.9103,2232.979;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;218;597.886,1711.016;Inherit;True;Property;_OcclusionMap;_OcclusionMap;17;0;Create;True;0;0;0;False;0;False;-1;None;446c1e0c2cd6e614c88cff17ebdbe4fe;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;219;226.1177,443.8196;Inherit;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;0;False;0;False;2,2,2,2;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;220;1181.874,2170.031;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;221;-1306.253,1352.413;Float;True;Property;_MetallicGlossMap;_MetallicGlossMap;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;222;-1391.525,1779.17;Float;True;Property;_EmissionMap;_EmissionMap;6;0;Create;True;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-495.8942,610.5283;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;224;675.4404,1933.573;Float;False;Property;_OcclusionStrength;_OcclusionStrength;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;398.2583,680.5116;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0.447,0.447,0.447,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;315.4856,900.9497;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;227;1372.998,2172.989;Float;False;DetialMaskVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;228;930.7484,1805.751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;248;-1143.571,1933.739;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;247;-1073.571,1567.739;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;229;-879.1599,1394.846;Inherit;True;Property;_TextureSample5;Texture Sample 5;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;230;-894.3877,1314.204;Float;False;Property;_Metallic;_Metallic;8;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;231;-707.9785,1962.686;Inherit;False;Property;_EmissionColor;_EmissionColor;14;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;232;-914.8523,1784.476;Inherit;True;Property;_TextureSample4;Texture Sample 4;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;1049.603,1844.969;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-702.5969,1652.155;Float;False;Property;_Glossiness;_Glossiness;7;0;Create;True;0;0;0;False;0;False;0.5;0.342;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;689.5134,909.8831;Inherit;False;227;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;237;568.8889,640.4531;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0.5,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;238;469.4855,910.9497;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;608.1854,1063.36;Inherit;False;227;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;-541.3172,1316.646;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;240;-467.4419,1492.313;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-530.7991,1818.525;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;242;1227.748,1851.751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;243;1012.504,875.3269;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;244;929.7244,994.8875;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1534.471,851.2167;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InPlanaria/AmplifyStandard_Rotate90;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;106;0;104;2
WireConnection;128;0;127;2
WireConnection;141;0;106;0
WireConnection;141;1;116;0
WireConnection;142;0;104;1
WireConnection;142;1;118;0
WireConnection;139;0;128;0
WireConnection;139;1;130;0
WireConnection;140;0;127;1
WireConnection;140;1;129;0
WireConnection;125;0;142;0
WireConnection;125;1;123;0
WireConnection;124;0;141;0
WireConnection;124;1;122;0
WireConnection;134;0;140;0
WireConnection;134;1;137;0
WireConnection;135;0;139;0
WireConnection;135;1;131;0
WireConnection;107;0;124;0
WireConnection;107;1;125;0
WireConnection;136;0;135;0
WireConnection;136;1;134;0
WireConnection;126;0;136;0
WireConnection;108;0;107;0
WireConnection;209;0;203;0
WireConnection;209;1;249;0
WireConnection;212;0;204;0
WireConnection;212;1;252;0
WireConnection;213;0;205;0
WireConnection;213;1;250;0
WireConnection;213;5;211;0
WireConnection;214;0;206;0
WireConnection;214;1;246;0
WireConnection;214;5;207;0
WireConnection;216;0;208;0
WireConnection;216;1;245;0
WireConnection;217;0;210;0
WireConnection;217;1;209;0
WireConnection;218;1;251;0
WireConnection;220;0;212;3
WireConnection;223;0;215;0
WireConnection;223;1;216;0
WireConnection;225;0;217;0
WireConnection;225;1;219;0
WireConnection;226;0;214;0
WireConnection;226;1;213;0
WireConnection;227;0;220;0
WireConnection;228;0;218;2
WireConnection;229;0;221;0
WireConnection;229;1;247;0
WireConnection;232;0;222;0
WireConnection;232;1;248;0
WireConnection;233;0;228;0
WireConnection;233;1;224;0
WireConnection;237;0;223;0
WireConnection;237;1;225;0
WireConnection;238;0;226;0
WireConnection;239;0;230;0
WireConnection;239;1;229;1
WireConnection;240;0;229;4
WireConnection;240;1;234;0
WireConnection;241;0;232;0
WireConnection;241;1;231;0
WireConnection;242;0;233;0
WireConnection;243;0;237;0
WireConnection;243;1;223;0
WireConnection;243;2;236;0
WireConnection;244;0;238;0
WireConnection;244;1;214;0
WireConnection;244;2;235;0
WireConnection;0;0;243;0
WireConnection;0;1;244;0
WireConnection;0;2;241;0
WireConnection;0;3;239;0
WireConnection;0;4;240;0
WireConnection;0;5;242;0
ASEEND*/
//CHKSM=BF01288EFB85F5FA97F56EDF3B085E453B6FD238