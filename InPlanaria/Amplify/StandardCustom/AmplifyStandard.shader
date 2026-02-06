// Made with Amplify Shader Editor v1.9.3.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InPlanaria/AmplifyStandard"
{
	Properties
	{
		_Color("_Color", Color) = (1,1,1,1)
		_MainTex("_MainTex", 2D) = "white" {}
		[Header(MetallicGlossMap(RA))]_MetallicGlossMap("_MetallicGlossMap", 2D) = "white" {}
		_Metallic("_Metallic", Range( 0 , 1)) = 0.5
		_Glossiness("_Glossiness", Range( 0 , 1)) = 0.5
		_BumpMap("_BumpMap", 2D) = "bump" {}
		_BumpScale("_BumpScale", Float) = 1
		[Header(Occlusion(G))]_OcclusionMap("_OcclusionMap", 2D) = "white" {}
		_OcclusionStrength("_OcclusionStrength", Range( 0 , 1)) = 1
		[HDR]_EmissionColor("_EmissionColor", Color) = (0,0,0,0)
		_EmissionMap("_EmissionMap", 2D) = "white" {}
		[Header(DetailMask(B))]_DetailMask("_DetailMask", 2D) = "white" {}
		_DetialColor("_DetialColor", Color) = (1,1,1,1)
		_DetailAlbedoMap("_DetailAlbedoMap", 2D) = "gray" {}
		_DetailNormalMap("_DetailNormalMap", 2D) = "bump" {}
		_DetailNormalMapScale("_DetailNormalMapScale", Float) = 1
		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Int) = 0
		[Enum(OFF,0,ON,1)]_ZWrite("ZWrite", Int) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Int) = 4
		_MaskClipValue("MaskClipValue", Range( 0 , 1)) = 0.5
		[Enum(OFF,0,ON,1)]_AlphaToCoverage("Alpha To Coverage", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendRGBSrc("BlendRGBSrc", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendRGBDst("BlendRGBDst", Int) = 10
		[Enum(UnityEngine.Rendering.BlendOp)]_BlendOpRGB("BlendOpRGB", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendAlphaSrc("BlendAlphaSrc", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendAlphaDst("BlendAlphaDst", Int) = 10
		[Enum(UnityEngine.Rendering.BlendOp)]_BlendOpAlpha("BlendOpAlpha", Int) = 0
		_StencilRef("StencilRef", Int) = 0
		_StencilReadMask("StencilReadMask", Int) = 255
		_StencilWriteMask("StencilWriteMask", Int) = 255
		[Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("StencilComp", Int) = 8
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilPass("StencilPass", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilFail("StencilFail", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)]_StencilZFail("StencilZFail", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull [_Cull]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Stencil
		{
			Ref [_StencilRef]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilPass]
			FailFront [_StencilFail]
			ZFailFront [_StencilZFail]
			CompBack [_StencilComp]
			PassBack [_StencilPass]
			FailBack [_StencilFail]
			ZFailBack [_StencilZFail]
		}
		Blend [_BlendRGBSrc] [_BlendRGBDst] , [_BlendAlphaSrc] [_BlendAlphaDst]
		BlendOp [_BlendOpRGB] , [_BlendOpAlpha]
		AlphaToMask [_AlphaToCoverage]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform int _StencilWriteMask;
		uniform int _StencilReadMask;
		uniform int _StencilComp;
		uniform int _StencilPass;
		uniform int _StencilFail;
		uniform int _StencilZFail;
		uniform int _StencilRef;
		uniform int _Cull;
		uniform int _ZTest;
		uniform int _ZWrite;
		uniform float _MaskClipValue;
		uniform int _AlphaToCoverage;
		uniform int _BlendRGBSrc;
		uniform int _BlendRGBDst;
		uniform int _BlendAlphaDst;
		uniform int _BlendAlphaSrc;
		uniform int _BlendOpRGB;
		uniform int _BlendOpAlpha;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float4 _DetailNormalMap_ST;
		uniform float _DetailNormalMapScale;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform float4 _DetialColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _Glossiness;
		uniform sampler2D _OcclusionMap;
		uniform float4 _OcclusionMap_ST;
		uniform float _OcclusionStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float3 tex2DNode101 = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _BumpScale );
			float2 uv_DetailNormalMap = i.uv_texcoord * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
			float3 normalizeResult132 = normalize( ( tex2DNode101 + UnpackScaleNormal( tex2D( _DetailNormalMap, uv_DetailNormalMap ), _DetailNormalMapScale ) ) );
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float DetialMaskVar62 = tex2D( _DetailMask, uv_DetailMask ).b;
			float3 lerpResult64 = lerp( normalizeResult132 , tex2DNode101 , DetialMaskVar62);
			o.Normal = lerpResult64;
			float2 uv_DetailAlbedoMap = i.uv_texcoord * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = ( ( float4(1,1,1,1) + ( ( ( ( _DetialColor * tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) ) * float4(2,2,2,2) ) + float4(-1,-1,-1,-1) ) * DetialMaskVar62 ) ) * ( _Color * tex2D( _MainTex, uv_MainTex ) ) ).xyz;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			o.Emission = ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ).rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode100 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = ( _Metallic * tex2DNode100.r );
			o.Smoothness = ( tex2DNode100.a * _Glossiness );
			float2 uv_OcclusionMap = i.uv_texcoord * _OcclusionMap_ST.xy + _OcclusionMap_ST.zw;
			o.Occlusion = ( 1.0 - ( ( 1.0 - tex2D( _OcclusionMap, uv_OcclusionMap ).g ) * _OcclusionStrength ) );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19302
Node;AmplifyShaderEditor.TexturePropertyNode;26;-878.1637,1529.6;Float;True;Property;_DetailAlbedoMap;_DetailAlbedoMap;13;0;Create;True;0;0;0;False;0;False;None;4d4faa6fb270f4b43a9a1fe4ac39d46f;False;gray;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;92;-429.8023,1325.348;Inherit;False;Property;_DetialColor;_DetialColor;12;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;98;-520.5647,1513.428;Inherit;True;Property;_TextureSample3;Texture Sample 3;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;56;991.4856,1259.344;Float;True;Property;_DetailMask;_DetailMask;11;1;[Header];Create;False;1;DetailMask(B);0;0;False;0;False;None;955236b9aefd24d40ae1cade01623112;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-178.6167,1414.143;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;95;1241.709,1274.195;Inherit;True;Property;_TextureSample0;Texture Sample 0;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;106;117.3736,-973.7882;Inherit;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;0;False;0;False;2,2,2,2;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;29;-882.284,1848.789;Float;True;Property;_DetailNormalMap;_DetailNormalMap;14;0;Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;15;-727.2882,266.9826;Float;False;Property;_BumpScale;_BumpScale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-888.8054,2055.461;Float;False;Property;_DetailNormalMapScale;_DetailNormalMapScale;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;1769.292,1354.153;Float;False;DetialMaskVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;138;429.7503,-668.7278;Inherit;False;Constant;_Vector2;Vector 0;24;0;Create;True;0;0;0;False;0;False;-1,-1,-1,-1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;289.5142,-737.0974;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0.447,0.447,0.447,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-988.2088,141.0887;Float;True;Property;_BumpMap;_BumpMap;5;0;Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;97;-405.691,1845.602;Inherit;True;Property;_TextureSample2;Texture Sample 2;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;-311.8445,199.763;Inherit;True;Property;_TextureSample6;Texture Sample 6;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;139;721.0292,-775.4176;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;685.7663,-638.1235;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;94;-662.8214,-155.0268;Float;True;Property;_MainTex;_MainTex;1;0;Create;True;0;0;0;False;0;False;None;750b1bd7ba8bd28489650de6d0a95cc5;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;107;994.1796,892.1797;Inherit;True;Property;_OcclusionMap;_OcclusionMap;7;1;[Header];Create;True;1;Occlusion(G);0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;-373.0226,-124.0686;Inherit;True;Property;_TextureSample7;Texture Sample 7;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;21;-995.2314,960.3341;Float;True;Property;_EmissionMap;_EmissionMap;10;0;Create;True;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;108;1071.734,1114.737;Float;False;Property;_OcclusionStrength;_OcclusionStrength;8;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;131;711.7791,82.11351;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;110;1327.042,986.915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;134;318.1917,-1019.162;Inherit;False;Constant;_Vector1;Vector 0;24;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;925.9404,-766.9502;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.447;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-909.9591,533.5772;Float;True;Property;_MetallicGlossMap;_MetallicGlossMap;2;1;[Header];Create;True;1;MetallicGlossMap(RA);0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;12;-350.7862,-297.1028;Inherit;False;Property;_Color;_Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.72,0.72,0.72,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-498.0941,495.3683;Float;False;Property;_Metallic;_Metallic;3;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1445.897,1026.133;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-306.3033,833.3187;Float;False;Property;_Glossiness;_Glossiness;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;1004.479,244.524;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;132;865.7791,92.11351;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-99.60062,-210.5889;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;1109.786,-790.8202;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;100;-482.8663,576.0094;Inherit;True;Property;_TextureSample5;Texture Sample 5;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;99;-518.5587,965.6401;Inherit;True;Property;_TextureSample4;Texture Sample 4;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-311.6849,1143.85;Inherit;False;Property;_EmissionColor;_EmissionColor;9;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-145.0236,497.8101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-71.14829,673.477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-134.5055,999.6888;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;111;1624.042,1032.915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;1326.018,176.0513;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;1251.737,-762.2305;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.IntNode;148;2298.735,368.7824;Inherit;False;Property;_StencilFail;StencilFail;32;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;149;2296.735,439.7825;Inherit;False;Property;_StencilZFail;StencilZFail;33;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;150;2269.065,-65.09412;Inherit;False;Property;_StencilRef;StencilRef;27;0;Create;True;0;0;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;153;1981.505,181.302;Inherit;False;Property;_ZWrite;ZWrite;17;1;[Enum];Create;True;0;2;OFF;0;ON;1;0;True;0;False;1;1;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;152;1980.505,265.3018;Inherit;False;Property;_ZTest;ZTest;18;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;False;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;1987.826,371.3894;Inherit;False;Property;_MaskClipValue;MaskClipValue;19;0;Create;True;0;0;0;True;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;156;1990.491,459.3142;Inherit;False;Property;_AlphaToCoverage;Alpha To Coverage;20;1;[Enum];Create;True;0;2;OFF;0;ON;1;0;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;151;1977.101,100.6401;Inherit;False;Property;_Cull;Cull;16;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;157;1997.152,552.5682;Inherit;False;Property;_BlendRGBSrc;BlendRGBSrc;21;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;158;2001.147,629.8356;Inherit;False;Property;_BlendRGBDst;BlendRGBDst;22;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;145;2237.38,11.89295;Inherit;False;Property;_StencilReadMask;StencilReadMask;28;0;Create;True;0;0;0;True;0;False;255;255;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;144;2243.626,100.4605;Inherit;False;Property;_StencilWriteMask;StencilWriteMask;29;0;Create;True;0;0;0;True;0;False;255;255;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;146;2273.934,199.1831;Inherit;False;Property;_StencilComp;StencilComp;30;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;8;8;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;147;2278.735,295.7826;Inherit;False;Property;_StencilPass;StencilPass;31;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.StencilOp;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;161;2000.996,698.2516;Inherit;False;Property;_BlendOpRGB;BlendOpRGB;23;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendOp;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;160;2003.489,780.3653;Inherit;False;Property;_BlendAlphaSrc;BlendAlphaSrc;24;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;159;2007.484,857.6327;Inherit;False;Property;_BlendAlphaDst;BlendAlphaDst;25;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;False;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;162;2012.694,942.6514;Inherit;False;Property;_BlendOpAlpha;BlendOpAlpha;26;1;[Enum];Create;True;0;2;OFF;0;ON;1;1;UnityEngine.Rendering.BlendOp;True;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1666.792,91.95958;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InPlanaria/AmplifyStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;1;True;_ZWrite;0;True;_ZTest;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;True;0;True;_StencilRef;255;True;_StencilReadMask;255;True;_StencilWriteMask;0;True;_StencilComp;0;True;_StencilPass;0;True;_StencilFail;0;True;_StencilZFail;0;True;_StencilComp;0;True;_StencilPass;0;True;_StencilFail;0;True;_StencilZFail;False;2;15;10;25;False;0.5;True;1;5;True;_BlendRGBSrc;10;True;_BlendRGBDst;1;0;True;_BlendAlphaSrc;0;True;_BlendAlphaDst;0;True;_BlendOpRGB;0;True;_BlendOpAlpha;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;_Cull;-1;0;True;_MaskClipValue;0;0;0;False;0.1;False;;0;True;_AlphaToCoverage;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;98;0;26;0
WireConnection;93;0;92;0
WireConnection;93;1;98;0
WireConnection;95;0;56;0
WireConnection;62;0;95;3
WireConnection;105;0;93;0
WireConnection;105;1;106;0
WireConnection;97;0;29;0
WireConnection;97;5;30;0
WireConnection;101;0;2;0
WireConnection;101;5;15;0
WireConnection;139;0;105;0
WireConnection;139;1;138;0
WireConnection;102;0;94;0
WireConnection;131;0;101;0
WireConnection;131;1;97;0
WireConnection;110;0;107;2
WireConnection;140;0;139;0
WireConnection;140;1;63;0
WireConnection;109;0;110;0
WireConnection;109;1;108;0
WireConnection;132;0;131;0
WireConnection;13;0;12;0
WireConnection;13;1;102;0
WireConnection;135;0;134;0
WireConnection;135;1;140;0
WireConnection;100;0;16;0
WireConnection;99;0;21;0
WireConnection;19;0;18;0
WireConnection;19;1;100;1
WireConnection;20;0;100;4
WireConnection;20;1;8;0
WireConnection;24;0;99;0
WireConnection;24;1;23;0
WireConnection;111;0;109;0
WireConnection;64;0;132;0
WireConnection;64;1;101;0
WireConnection;64;2;65;0
WireConnection;141;0;135;0
WireConnection;141;1;13;0
WireConnection;0;0;141;0
WireConnection;0;1;64;0
WireConnection;0;2;24;0
WireConnection;0;3;19;0
WireConnection;0;4;20;0
WireConnection;0;5;111;0
ASEEND*/
//CHKSM=C7EF0F977B44F74496B20DAC0AFEB44EC6E9632E