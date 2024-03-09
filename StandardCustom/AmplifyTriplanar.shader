// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InPlanaria/AmplifyTriplanar"
{
	Properties
	{
		_DetailMask("_DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("_DetailAlbedoMap", 2D) = "white" {}
		_BumpMap("_BumpMap", 2D) = "bump" {}
		_DetailNormalMap("_DetailNormalMap", 2D) = "bump" {}
		_MetallicGlossMap("_MetallicGlossMap", 2D) = "white" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_DetialMetallicGlossMap("_DetialMetallicGlossMap", 2D) = "white" {}
		_EmissionMap("_EmissionMap", 2D) = "white" {}
		_Glossiness("_Glossiness", Range( 0 , 1)) = 0.5
		_DetialGlossiness("_DetialGlossiness", Range( 0 , 1)) = 0.5
		_Metallic("_Metallic", Range( 0 , 1)) = 0.5
		_DetialMetallic("_DetialMetallic", Range( 0 , 1)) = 0.5
		_CoverageFalloff("Coverage Falloff", Range( 0.01 , 10)) = 1
		_DetialCoverageFalloff("DetialCoverageFalloff", Range( 0.01 , 10)) = 2.794423
		_DetialMaskCoverageFalloff("DetialMaskCoverageFalloff", Range( 0.01 , 10)) = 2.794423
		_TexWorldScale("_TexWorldScale", Range( 0.0001 , 10)) = 1
		_DetialTexWorldScale("_DetialTexWorldScale", Range( 0.0001 , 10)) = 1
		_DetialMaskTexWorldScale("_DetialMaskTexWorldScale", Range( 0.0001 , 10)) = 1
		_BumpScale("_BumpScale", Range( 0 , 2)) = 1
		_DetailNormalMapScale("_DetailNormalMapScale", Range( 0 , 2)) = 1
		_Color("_Color", Color) = (0,0,0,0)
		_DetialColor("_DetialColor", Color) = (1,1,1,1)
		[HDR]_EmissionColor("_EmissionColor", Color) = (0,0,0,0)
		_DetailMaskInvert("_DetailMaskInvert", Int) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _BumpMap;
		uniform float _TexWorldScale;
		uniform float _CoverageFalloff;
		uniform float _BumpScale;
		uniform sampler2D _DetailNormalMap;
		uniform float _DetialTexWorldScale;
		uniform float _DetialCoverageFalloff;
		uniform float _DetailNormalMapScale;
		uniform int _DetailMaskInvert;
		uniform sampler2D _DetailMask;
		uniform float _DetialMaskTexWorldScale;
		uniform float _DetialMaskCoverageFalloff;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _DetialColor;
		uniform sampler2D _DetailAlbedoMap;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform float _Metallic;
		uniform sampler2D _MetallicGlossMap;
		uniform float _DetialMetallic;
		uniform sampler2D _DetialMetallicGlossMap;
		uniform float _Glossiness;
		uniform float _DetialGlossiness;


		inline float3 TriplanarSampling11( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			xNorm.xyz  = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			yNormN.xyz = half3( UnpackScaleNormal( yNormN, normalScale.z ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + yNormN.xyz * negProjNormalY + zNorm.xyz * projNormal.z );
		}


		inline float3 TriplanarSampling28( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			xNorm.xyz  = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			yNormN.xyz = half3( UnpackScaleNormal( yNormN, normalScale.z ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + yNormN.xyz * negProjNormalY + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSampling58( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling10( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling27( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling25( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling17( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling81( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			float negProjNormalY = max( 0, projNormal.y * -nsign.y );
			projNormal.y = max( 0, projNormal.y * nsign.y );
			half4 xNorm; half4 yNorm; half4 yNormN; half4 zNorm;
			xNorm  = tex2D( midTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm  = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			yNormN = tex2D( botTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm  = tex2D( midTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + yNormN * negProjNormalY + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float TexWorldScaleVar34 = _TexWorldScale;
			float2 temp_cast_0 = (TexWorldScaleVar34).xx;
			float CoverageFalloffVar40 = _CoverageFalloff;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 temp_cast_1 = (_BumpScale).xxx;
			float3 triplanar11 = TriplanarSampling11( _BumpMap, _BumpMap, _BumpMap, ase_worldPos, ase_worldNormal, CoverageFalloffVar40, temp_cast_0, temp_cast_1, float3(0,0,0) );
			float3 tanTriplanarNormal11 = mul( ase_worldToTangent, triplanar11 );
			float DetialTexWorldScaleVar52 = _DetialTexWorldScale;
			float2 temp_cast_2 = (DetialTexWorldScaleVar52).xx;
			float DetialCoverageFalloffVar53 = _DetialCoverageFalloff;
			float3 temp_cast_3 = (_DetailNormalMapScale).xxx;
			float3 triplanar28 = TriplanarSampling28( _DetailNormalMap, _DetailNormalMap, _DetailNormalMap, ase_worldPos, ase_worldNormal, DetialCoverageFalloffVar53, temp_cast_2, temp_cast_3, float3(0,0,0) );
			float3 tanTriplanarNormal28 = mul( ase_worldToTangent, triplanar28 );
			float2 temp_cast_4 = (_DetialMaskTexWorldScale).xx;
			float4 triplanar58 = TriplanarSampling58( _DetailMask, _DetailMask, _DetailMask, ase_worldPos, ase_worldNormal, _DetialMaskCoverageFalloff, temp_cast_4, float3( 1,1,1 ), float3(0,0,0) );
			float ifLocalVar74 = 0;
			if( _DetailMaskInvert <= 0.0 )
				ifLocalVar74 = triplanar58.b;
			else
				ifLocalVar74 = ( 1.0 - triplanar58.z );
			float DetialMaskVar62 = ifLocalVar74;
			float3 lerpResult64 = lerp( tanTriplanarNormal11 , tanTriplanarNormal28 , DetialMaskVar62);
			o.Normal = lerpResult64;
			float2 temp_cast_5 = (TexWorldScaleVar34).xx;
			float4 triplanar10 = TriplanarSampling10( _MainTex, _MainTex, _MainTex, ase_worldPos, ase_worldNormal, CoverageFalloffVar40, temp_cast_5, float3( 1,1,1 ), float3(0,0,0) );
			float2 temp_cast_7 = (DetialTexWorldScaleVar52).xx;
			float4 triplanar27 = TriplanarSampling27( _DetailAlbedoMap, _DetailAlbedoMap, _DetailAlbedoMap, ase_worldPos, ase_worldNormal, DetialCoverageFalloffVar53, temp_cast_7, float3( 1,1,1 ), float3(0,0,0) );
			float4 lerpResult57 = lerp( ( _Color * triplanar10 ) , ( _DetialColor * triplanar27 ) , DetialMaskVar62);
			o.Albedo = lerpResult57.rgb;
			float2 temp_cast_10 = (TexWorldScaleVar34).xx;
			float4 triplanar25 = TriplanarSampling25( _EmissionMap, _EmissionMap, _EmissionMap, ase_worldPos, ase_worldNormal, CoverageFalloffVar40, temp_cast_10, float3( 1,1,1 ), float3(0,0,0) );
			o.Emission = ( triplanar25 * _EmissionColor ).xyz;
			float2 temp_cast_13 = (TexWorldScaleVar34).xx;
			float4 triplanar17 = TriplanarSampling17( _MetallicGlossMap, _MetallicGlossMap, _MetallicGlossMap, ase_worldPos, ase_worldNormal, CoverageFalloffVar40, temp_cast_13, float3( 1,1,1 ), float3(0,0,0) );
			float2 temp_cast_14 = (DetialTexWorldScaleVar52).xx;
			float4 triplanar81 = TriplanarSampling81( _DetialMetallicGlossMap, _DetialMetallicGlossMap, _DetialMetallicGlossMap, ase_worldPos, ase_worldNormal, DetialCoverageFalloffVar53, temp_cast_14, float3( 1,1,1 ), float3(0,0,0) );
			float lerpResult89 = lerp( ( _Metallic * triplanar17.x ) , ( _DetialMetallic * triplanar81.x ) , DetialMaskVar62);
			o.Metallic = lerpResult89;
			float lerpResult90 = lerp( ( triplanar17.a * _Glossiness ) , ( triplanar81.a * _DetialGlossiness ) , DetialMaskVar62);
			o.Smoothness = lerpResult90;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
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
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=18935
-7;498;1920;513;1843.069;548.6154;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;61;332.5174,2271.562;Float;False;Property;_DetialMaskCoverageFalloff;DetialMaskCoverageFalloff;14;0;Create;True;0;0;0;False;0;False;2.794423;2.794423;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;332.7093,2189.995;Float;False;Property;_DetialMaskTexWorldScale;_DetialMaskTexWorldScale;17;0;Create;True;0;0;0;False;0;False;1;1;0.0001;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;59;316.6721,2015.301;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;56;287.1591,1834.221;Float;True;Property;_DetailMask;_DetailMask;0;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;51;-1580.209,1439.685;Float;False;Property;_DetialTexWorldScale;_DetialTexWorldScale;16;0;Create;True;0;0;0;False;0;False;1;1;0.0001;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1570.216,1553.021;Float;False;Property;_DetialCoverageFalloff;DetialCoverageFalloff;13;0;Create;True;0;0;0;False;0;False;2.794423;2.794423;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1699.096,-4.48207;Float;False;Property;_TexWorldScale;_TexWorldScale;15;0;Create;True;0;0;0;False;0;False;1;1;0.0001;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1717.729,121.6341;Float;False;Property;_CoverageFalloff;Coverage Falloff;12;0;Create;True;0;0;0;False;0;False;1;1;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;58;594.2249,1866.858;Inherit;True;Cylindrical;World;False;Top Texture 6;_TopTexture6;white;-1;None;Mid Texture 6;_MidTexture6;white;-1;None;Bot Texture 6;_BotTexture6;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1267.964,1554.089;Float;False;DetialCoverageFalloffVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1399.707,-2.112014;Float;False;TexWorldScaleVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-1415.477,122.7024;Float;False;CoverageFalloffVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;70;1014.68,2070.262;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;71;1129.588,1962.055;Inherit;False;Property;_DetailMaskInvert;_DetailMaskInvert;23;0;Create;True;0;0;0;False;0;False;0;0;False;0;1;INT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1238.361,1450.546;Float;False;DetialTexWorldScaleVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-697.5894,745.4831;Inherit;False;40;CoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;46;-915.9479,742.5758;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;33;-642.769,19.0149;Inherit;False;34;TexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-661.3104,88.65347;Inherit;False;40;CoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-669.6135,684.0576;Inherit;False;34;TexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;79;-1008.491,2630.797;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;82;-826.9983,2794.993;Inherit;False;53;DetialCoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-946.0334,-52.76205;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;94;-711.1421,-226.5307;Float;True;Property;_MainTex;_MainTex;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;26;-878.1637,1529.6;Float;True;Property;_DetailAlbedoMap;_DetailAlbedoMap;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;77;-1027.523,2451.181;Float;True;Property;_DetialMetallicGlossMap;_DetialMetallicGlossMap;6;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldPosInputsNode;31;-1197.778,1703.713;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;49;-654.4224,1764.39;Inherit;False;53;DetialCoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;74;1299.529,2030.213;Inherit;False;False;5;0;INT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-650.4243,1664.656;Inherit;False;52;DetialTexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-831.2183,2710.306;Inherit;False;52;DetialTexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-909.9591,533.5772;Float;True;Property;_MetallicGlossMap;_MetallicGlossMap;4;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;2;-986.2088,140.0887;Float;True;Property;_BumpMap;_BumpMap;2;0;Create;True;0;0;0;False;0;False;None;bdc097505899a6d4c956a2d9a4ec2308;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldPosInputsNode;45;-949.04,322.2325;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;1496.415,2028.152;Float;False;DetialMaskVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-888.8054,2055.461;Float;False;Property;_DetailNormalMapScale;_DetailNormalMapScale;19;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-639.6165,392.8819;Inherit;False;40;CoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;92;-429.8023,1325.348;Inherit;False;Property;_DetialColor;_DetialColor;21;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-710.9298,229.8041;Float;False;Property;_BumpScale;_BumpScale;18;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;10;-391.8545,-81.12207;Inherit;True;Cylindrical;World;False;Top Texture 0;_TopTexture0;white;1;None;Mid Texture 0;_MidTexture0;white;2;None;Bot Texture 0;_BotTexture0;white;0;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;29;-882.284,1848.789;Float;True;Property;_DetailNormalMap;_DetailNormalMap;3;0;Create;True;0;0;0;False;0;False;None;None;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;35;-622.9846,304.5678;Inherit;False;34;TexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-976.2,1139.95;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;48;-1174.507,1934.446;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;84;-329.3368,2677.88;Float;False;Property;_DetialGlossiness;_DetialGlossiness;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-868.6987,2133.465;Inherit;False;52;DetialTexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-350.7862,-297.1028;Inherit;False;Property;_Color;_Color;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4339623,0.4339623,0.4339623,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;44;-776.9266,1138.002;Inherit;False;40;CoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-498.0941,495.3683;Float;False;Property;_Metallic;_Metallic;10;0;Create;True;0;0;0;False;0;False;0.5;0.81;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-306.3033,833.3187;Float;False;Property;_Glossiness;_Glossiness;8;0;Create;True;0;0;0;False;0;False;0.5;0.98;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;17;-459.4712,593.0953;Inherit;True;Cylindrical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;21;-995.2314,960.3341;Float;True;Property;_EmissionMap;_EmissionMap;7;0;Create;True;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;27;-415.856,1548.13;Inherit;True;Cylindrical;World;False;Top Texture 4;_TopTexture4;white;-1;None;Mid Texture 4;_MidTexture4;white;-1;None;Bot Texture 4;_BotTexture4;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-521.1276,2339.93;Float;False;Property;_DetialMetallic;_DetialMetallic;11;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;81;-558.5379,2445.746;Inherit;True;Cylindrical;World;False;Top Texture 7;_TopTexture7;white;-1;None;Mid Texture 7;_MidTexture7;white;-1;None;Bot Texture 7;_BotTexture7;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;37;-739.5815,1042.991;Inherit;False;34;TexWorldScaleVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-864.4787,2218.152;Inherit;False;53;DetialCoverageFalloffVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-94.18177,2518.038;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;28;-412.8728,1928.509;Inherit;True;Cylindrical;World;True;Top Texture 5;_TopTexture5;white;-1;None;Mid Texture 5;_MidTexture5;white;-1;None;Bot Texture 5;_BotTexture5;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;63;605.73,129.3041;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-178.6167,1414.143;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-145.0236,497.8101;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;25;-526.2474,954.8985;Inherit;True;Cylindrical;World;False;Top Texture 3;_TopTexture3;white;-1;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-311.6849,1143.85;Inherit;False;Property;_EmissionColor;_EmissionColor;22;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-168.0571,2342.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;610.2847,254.5036;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-71.14829,673.477;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;604.6702,391.3401;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;91;622.2772,547.7156;Inherit;False;62;DetialMaskVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-99.60062,-208.3079;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;11;-364.4259,154.911;Inherit;True;Cylindrical;World;True;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT3;1,1,1;False;3;FLOAT2;1,1;False;4;FLOAT;2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;90;861.1121,492.9123;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-134.5055,999.6888;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;57;844.5647,74.5009;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;64;849.1194,199.7003;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;89;843.505,336.5368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1176.128,176.7863;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;InPlanaria/AmplifyTriplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;56;0
WireConnection;58;1;56;0
WireConnection;58;2;56;0
WireConnection;58;9;59;0
WireConnection;58;3;60;0
WireConnection;58;4;61;0
WireConnection;53;0;54;0
WireConnection;34;0;14;0
WireConnection;40;0;5;0
WireConnection;70;0;58;3
WireConnection;52;0;51;0
WireConnection;74;0;71;0
WireConnection;74;2;70;0
WireConnection;74;3;58;3
WireConnection;74;4;58;3
WireConnection;62;0;74;0
WireConnection;10;0;94;0
WireConnection;10;1;94;0
WireConnection;10;2;94;0
WireConnection;10;9;6;0
WireConnection;10;3;33;0
WireConnection;10;4;41;0
WireConnection;17;0;16;0
WireConnection;17;1;16;0
WireConnection;17;2;16;0
WireConnection;17;9;46;0
WireConnection;17;3;36;0
WireConnection;17;4;43;0
WireConnection;27;0;26;0
WireConnection;27;1;26;0
WireConnection;27;2;26;0
WireConnection;27;9;31;0
WireConnection;27;3;38;0
WireConnection;27;4;49;0
WireConnection;81;0;77;0
WireConnection;81;1;77;0
WireConnection;81;2;77;0
WireConnection;81;9;79;0
WireConnection;81;3;83;0
WireConnection;81;4;82;0
WireConnection;85;0;81;4
WireConnection;85;1;84;0
WireConnection;28;0;29;0
WireConnection;28;1;29;0
WireConnection;28;2;29;0
WireConnection;28;9;48;0
WireConnection;28;8;30;0
WireConnection;28;3;39;0
WireConnection;28;4;50;0
WireConnection;93;0;92;0
WireConnection;93;1;27;0
WireConnection;19;0;18;0
WireConnection;19;1;17;1
WireConnection;25;0;21;0
WireConnection;25;1;21;0
WireConnection;25;2;21;0
WireConnection;25;9;47;0
WireConnection;25;3;37;0
WireConnection;25;4;44;0
WireConnection;86;0;87;0
WireConnection;86;1;81;1
WireConnection;20;0;17;4
WireConnection;20;1;8;0
WireConnection;13;0;12;0
WireConnection;13;1;10;0
WireConnection;11;0;2;0
WireConnection;11;1;2;0
WireConnection;11;2;2;0
WireConnection;11;9;45;0
WireConnection;11;8;15;0
WireConnection;11;3;35;0
WireConnection;11;4;42;0
WireConnection;90;0;20;0
WireConnection;90;1;85;0
WireConnection;90;2;91;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;57;0;13;0
WireConnection;57;1;93;0
WireConnection;57;2;63;0
WireConnection;64;0;11;0
WireConnection;64;1;28;0
WireConnection;64;2;65;0
WireConnection;89;0;19;0
WireConnection;89;1;86;0
WireConnection;89;2;88;0
WireConnection;0;0;57;0
WireConnection;0;1;64;0
WireConnection;0;2;24;0
WireConnection;0;3;89;0
WireConnection;0;4;90;0
ASEEND*/
//CHKSM=017297795A5AED0720886E05D04C07323FC172DF