// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InPlanaria/AmplifyStandard_Rotate90"
{
	Properties
	{
		_DetailMask("_DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("_DetailAlbedoMap", 2D) = "gray" {}
		_MainTex("_MainTex", 2D) = "black" {}
		_BumpMap("_BumpMap", 2D) = "bump" {}
		_DetailNormalMap("_DetailNormalMap", 2D) = "bump" {}
		_MetallicGlossMap("_MetallicGlossMap", 2D) = "white" {}
		_DetialMetallicGlossMap("_DetialMetallicGlossMap", 2D) = "white" {}
		_EmissionMap("_EmissionMap", 2D) = "white" {}
		_Glossiness("_Glossiness", Range( 0 , 1)) = 0.5
		_DetialGlossiness("_DetialGlossiness", Range( 0 , 1)) = 0.5
		_Metallic("_Metallic", Range( 0 , 1)) = 0.5
		_DetialMetallic("_DetialMetallic", Range( 0 , 1)) = 0.5
		_BumpScale("_BumpScale", Float) = 1
		_MainTexTilingU("_MainTexTilingU", Float) = 1
		_DetialTilingU("_DetialTilingU", Float) = 1
		_DetialTexOffsetU("_DetialTexOffsetU", Float) = 1
		_MainTexOffsetU("_MainTexOffsetU", Float) = 1
		_MainTexOffsetV("_MainTexOffsetV", Float) = 1
		_DetialTexOffsetV("_DetialTexOffsetV", Float) = 1
		_MainTexTilingV("_MainTexTilingV", Float) = 1
		_DetialTilingV("_DetialTilingV", Float) = 1
		_DetailNormalMapScale("_DetailNormalMapScale", Float) = 1
		_Color("_Color", Color) = (1,1,1,1)
		_DetialColor("_DetialColor", Color) = (1,1,1,1)
		[HDR]_EmissionColor("_EmissionColor", Color) = (0,0,0,0)
		_DetailMaskInvert("_DetailMaskInvert", Int) = 0
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
		uniform int _DetailMaskInvert;
		uniform sampler2D _DetailMask;
		uniform float4 _DetialColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _DetialMetallic;
		uniform sampler2D _DetialMetallicGlossMap;
		uniform float _Glossiness;
		uniform float _DetialGlossiness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult107 = (float2(( ( -i.uv_texcoord.y * _MainTexTilingU ) + _MainTexOffsetU ) , ( ( i.uv_texcoord.x * _MainTexTilingV ) + _MainTexOffsetV )));
			float2 UVLocalVar108 = appendResult107;
			float2 appendResult136 = (float2(( ( -i.uv_texcoord.y * _DetialTilingU ) + _DetialTexOffsetU ) , ( ( i.uv_texcoord.x * _DetialTilingV ) + _DetialTexOffsetV )));
			float2 UVLocalVar_Detial126 = appendResult136;
			float4 tex2DNode95 = tex2D( _DetailMask, UVLocalVar108 );
			float ifLocalVar74 = 0;
			if( _DetailMaskInvert <= 0.0 )
				ifLocalVar74 = tex2DNode95.b;
			else
				ifLocalVar74 = ( 1.0 - tex2DNode95.b );
			float DetialMaskVar62 = ifLocalVar74;
			float3 lerpResult64 = lerp( UnpackScaleNormal( tex2D( _BumpMap, UVLocalVar108 ), _BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormalMap, UVLocalVar_Detial126 ), _DetailNormalMapScale ) , DetialMaskVar62);
			o.Normal = lerpResult64;
			float4 temp_output_93_0 = ( _DetialColor * tex2D( _DetailAlbedoMap, UVLocalVar_Detial126 ) );
			float4 temp_output_13_0 = ( _Color * tex2D( _MainTex, UVLocalVar108 ) );
			float4 blendOpSrc143 = ( temp_output_93_0 * float4(2,2,2,2) );
			float4 blendOpDest143 = temp_output_13_0;
			float4 lerpBlendMode143 = lerp(blendOpDest143,(( blendOpDest143 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest143 ) * ( 1.0 - blendOpSrc143 ) ) : ( 2.0 * blendOpDest143 * blendOpSrc143 ) ),DetialMaskVar62);
			o.Albedo = ( saturate( lerpBlendMode143 )).rgb;
			o.Emission = ( tex2D( _EmissionMap, UVLocalVar108 ) * _EmissionColor ).rgb;
			float4 tex2DNode100 = tex2D( _MetallicGlossMap, UVLocalVar108 );
			float4 tex2DNode96 = tex2D( _DetialMetallicGlossMap, UVLocalVar_Detial126 );
			float lerpResult89 = lerp( ( _Metallic * tex2DNode100.r ) , ( _DetialMetallic * tex2DNode96.r ) , DetialMaskVar62);
			o.Metallic = lerpResult89;
			float lerpResult90 = lerp( ( tex2DNode100.a * _Glossiness ) , ( tex2DNode96.a * _DetialGlossiness ) , DetialMaskVar62);
			o.Smoothness = lerpResult90;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-8;44;1920;934;682.2091;506.6625;1.519059;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-2222.935,-148.6259;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;116;-1983.915,-141.2962;Float;False;Property;_MainTexTilingU;_MainTexTilingU;13;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2008.094,-12.09575;Float;False;Property;_MainTexTilingV;_MainTexTilingV;19;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;106;-1974.245,-281.4645;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1767.024,-144.6431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-1770.141,-37.63273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-1754.093,85.47176;Float;False;Property;_MainTexOffsetV;_MainTexOffsetV;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1764.892,-219.1283;Float;False;Property;_MainTexOffsetU;_MainTexOffsetU;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;127;-2285.458,388.5081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1545.119,30.66457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-1552.718,-152.2355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2046.438,395.8378;Float;False;Property;_DetialTilingU;_DetialTilingU;14;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-2070.616,525.0383;Float;False;Property;_DetialTilingV;_DetialTilingV;20;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;128;-2014.883,284.1167;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-1816.614,622.6058;Float;False;Property;_DetialTexOffsetV;_DetialTexOffsetV;18;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-1827.413,318.0057;Float;False;Property;_DetialTexOffsetU;_DetialTexOffsetU;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1814.286,401.6163;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-1810.417,501.2544;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;107;-1399.096,-122.7509;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-1607.64,567.7986;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-1615.239,384.8985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1208.393,-126.6547;Inherit;False;UVLocalVar;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-1461.617,414.3831;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;56;423.8138,2032.924;Float;True;Property;_DetailMask;_DetailMask;0;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;115;437.9053,2224.771;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;95;676.0922,2083.364;Inherit;True;Property;_TextureSample0;Texture Sample 0;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-1322.827,348.189;Inherit;False;UVLocalVar_Detial;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;71;1047.588,1974.055;Inherit;False;Property;_DetailMaskInvert;_DetailMaskInvert;25;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.OneMinusNode;70;1014.68,2070.262;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-755.6319,1651.842;Inherit;False;126;UVLocalVar_Detial;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;26;-893.1637,1468.6;Float;True;Property;_DetailAlbedoMap;_DetailAlbedoMap;1;0;Create;True;0;0;0;False;0;False;None;None;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;109;-590.0619,-66.65046;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ConditionalIfNode;74;1299.529,2030.213;Inherit;False;False;5;0;INT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-673.2117,621.7078;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;77;-976.5482,2361.225;Float;True;Property;_DetialMetallicGlossMap;_DetialMetallicGlossMap;6;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;94;-721.4914,-298.445;Float;True;Property;_MainTex;_MainTex;2;0;Create;True;0;0;0;False;0;False;None;a58f667560fe2734186cae996b34b3cf;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;16;-909.9591,533.5772;Float;True;Property;_MetallicGlossMap;_MetallicGlossMap;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;98;-520.5647,1513.428;Inherit;True;Property;_TextureSample3;Texture Sample 3;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;92;-429.8023,1325.348;Inherit;False;Property;_DetialColor;_DetialColor;23;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;114;-780.2063,2493.411;Inherit;False;126;UVLocalVar_Detial;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-986.2088,140.0887;Float;True;Property;_BumpMap;_BumpMap;3;0;Create;True;0;0;0;False;0;False;None;974942db24bb6d2418ebe4f90ae82734;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;12;-350.7862,-297.1028;Inherit;False;Property;_Color;_Color;22;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,0.8436281,0.8066038,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;21;-995.2314,960.3341;Float;True;Property;_EmissionMap;_EmissionMap;7;0;Create;True;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;96;-575.0135,2431.344;Inherit;True;Property;_TextureSample1;Texture Sample 1;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-888.8054,2055.461;Float;False;Property;_DetailNormalMapScale;_DetailNormalMapScale;21;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;1496.415,2028.152;Float;False;DetialMaskVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-498.0941,495.3683;Float;False;Property;_Metallic;_Metallic;10;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;102;-373.0226,-124.0686;Inherit;True;Property;_TextureSample7;Texture Sample 7;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;29;-882.284,1848.789;Float;True;Property;_DetailNormalMap;_DetailNormalMap;4;0;Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-178.6167,1414.143;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-727.2882,266.9826;Float;False;Property;_BumpScale;_BumpScale;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;146;646.9058,-259.8878;Inherit;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;0;False;0;False;2,2,2,2;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;113;-617.8966,1881.315;Inherit;False;126;UVLocalVar_Detial;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-306.3033,833.3187;Float;False;Property;_Glossiness;_Glossiness;8;0;Create;True;0;0;0;False;0;False;0.5;0.441;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-540.2676,196.9845;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-716.5255,1039.407;Inherit;False;108;UVLocalVar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-329.3368,2677.88;Float;False;Property;_DetialGlossiness;_DetialGlossiness;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-521.1276,2339.93;Float;False;Property;_DetialMetallic;_DetialMetallic;11;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-482.8663,576.0094;Inherit;True;Property;_TextureSample5;Texture Sample 5;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-94.18177,2518.038;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-71.14829,673.477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;870.6078,-146.2778;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0.447,0.447,0.447,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-145.0236,497.8101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;610.2847,254.5036;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-311.6849,1143.85;Inherit;False;Property;_EmissionColor;_EmissionColor;24;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-518.5587,965.6401;Inherit;True;Property;_TextureSample4;Texture Sample 4;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-405.691,1845.602;Inherit;True;Property;_TextureSample2;Texture Sample 2;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-311.8445,199.763;Inherit;True;Property;_TextureSample6;Texture Sample 6;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;622.2772,547.7156;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-99.60062,-208.3079;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-168.0571,2342.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;604.6702,391.3401;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;924.9553,-19.04456;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;605.73,129.3041;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;849.1194,199.7003;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;57;844.5647,74.5009;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;90;861.1121,492.9123;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;843.505,336.5368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-134.5055,999.6888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;143;1133.319,-110.0429;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1176.128,176.7863;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InPlanaria/AmplifyStandard_Rotate90;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;106;0;104;2
WireConnection;141;0;106;0
WireConnection;141;1;116;0
WireConnection;142;0;104;1
WireConnection;142;1;118;0
WireConnection;125;0;142;0
WireConnection;125;1;123;0
WireConnection;124;0;141;0
WireConnection;124;1;122;0
WireConnection;128;0;127;2
WireConnection;139;0;128;0
WireConnection;139;1;130;0
WireConnection;140;0;127;1
WireConnection;140;1;129;0
WireConnection;107;0;124;0
WireConnection;107;1;125;0
WireConnection;134;0;140;0
WireConnection;134;1;137;0
WireConnection;135;0;139;0
WireConnection;135;1;131;0
WireConnection;108;0;107;0
WireConnection;136;0;135;0
WireConnection;136;1;134;0
WireConnection;95;0;56;0
WireConnection;95;1;115;0
WireConnection;126;0;136;0
WireConnection;70;0;95;3
WireConnection;74;0;71;0
WireConnection;74;2;70;0
WireConnection;74;3;95;3
WireConnection;74;4;95;3
WireConnection;98;0;26;0
WireConnection;98;1;138;0
WireConnection;96;0;77;0
WireConnection;96;1;114;0
WireConnection;62;0;74;0
WireConnection;102;0;94;0
WireConnection;102;1;109;0
WireConnection;93;0;92;0
WireConnection;93;1;98;0
WireConnection;100;0;16;0
WireConnection;100;1;111;0
WireConnection;85;0;96;4
WireConnection;85;1;84;0
WireConnection;20;0;100;4
WireConnection;20;1;8;0
WireConnection;145;0;93;0
WireConnection;145;1;146;0
WireConnection;19;0;18;0
WireConnection;19;1;100;1
WireConnection;99;0;21;0
WireConnection;99;1;112;0
WireConnection;97;0;29;0
WireConnection;97;1;113;0
WireConnection;97;5;30;0
WireConnection;101;0;2;0
WireConnection;101;1;110;0
WireConnection;101;5;15;0
WireConnection;13;0;12;0
WireConnection;13;1;102;0
WireConnection;86;0;87;0
WireConnection;86;1;96;1
WireConnection;64;0;101;0
WireConnection;64;1;97;0
WireConnection;64;2;65;0
WireConnection;57;0;13;0
WireConnection;57;1;93;0
WireConnection;57;2;63;0
WireConnection;90;0;20;0
WireConnection;90;1;85;0
WireConnection;90;2;91;0
WireConnection;89;0;19;0
WireConnection;89;1;86;0
WireConnection;89;2;88;0
WireConnection;24;0;99;0
WireConnection;24;1;23;0
WireConnection;143;0;145;0
WireConnection;143;1;13;0
WireConnection;143;2;147;0
WireConnection;0;0;143;0
WireConnection;0;1;64;0
WireConnection;0;2;24;0
WireConnection;0;3;89;0
WireConnection;0;4;90;0
ASEEND*/
//CHKSM=5312332E0632FEF5607564A6739AB9A14F766B16