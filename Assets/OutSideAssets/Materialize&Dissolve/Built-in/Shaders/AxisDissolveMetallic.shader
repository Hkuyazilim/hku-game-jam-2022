// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AxisDissolveMetallic"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(PBR Settings)][NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,1)
		[NoScaleOffset][Normal]_NormalTexture("Normal Texture", 2D) = "bump" {}
		[NoScaleOffset]_MetallicTexture("Metallic Texture", 2D) = "white" {}
		_MetallicValue("Metallic Value", Range( 0 , 1)) = 0
		_SmoothnessValue("Smoothness Value", Range( 0 , 1)) = 0
		[NoScaleOffset]_EmissionTexture("Emission Texture", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[NoScaleOffset]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		[Header(Main Dissolve Settings)][Space]_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 1
		_MinValueWhenAmount0("Min Value (When Amount = 0)", Float) = 0
		_MaxValueWhenAmount1("Max Value (When Amount = 1)", Float) = 3
		[KeywordEnum(Albedo,Emission)] _EdgesAffect("EdgesAffect", Float) = 1
		[KeywordEnum(X,Y,Z)] _Axis("Axis", Float) = 1
		[Toggle(_USETRIPLANARUVS_ON)] _UseTriplanarUvs("Use Triplanar Uvs", Float) = 0
		[Toggle(_INVERTDIRECTIONMINMAX_ON)] _InvertDirectionMinMax("Invert Direction (Min & Max)", Float) = 0
		[Header(Dissolve Guide)][NoScaleOffset][Space]_GuideTexture("Guide Texture", 2D) = "white" {}
		_GuideTilling("Guide Tilling", Float) = 1
		_GuideTillingSpeed("Guide Tilling Speed", Range( -0.4 , 0.4)) = 0.005
		_GuideStrength("Guide Strength", Range( 0 , 10)) = 0
		[Toggle(_GUIDEAFFECTSEDGESBLENDING_ON)] _GuideAffectsEdgesBlending("Guide Affects Edges Blending", Float) = 0
		[Header(Vertex Displacement)]_VertexDisplacementMainEdge("Vertex Displacement Main Edge ", Range( 0 , 2)) = 0
		_VertexDisplacementSecondEdge("Vertex Displacement Second Edge", Range( 0 , 2)) = 0
		[NoScaleOffset]_DisplacementGuide(" Displacement Guide", 2D) = "white" {}
		_DisplacementGuideTillingSpeed("Displacement Guide Tilling Speed", Range( 0 , 0.2)) = 0.005
		_DisplacementGuideTilling("Displacement Guide Tilling", Float) = 1
		[Header(Main Edge)]_MainEdgeWidth("Main Edge Width", Range( 0 , 0.5)) = 0.01308131
		[NoScaleOffset]_MainEdgePattern("Main Edge Pattern", 2D) = "black" {}
		_MainEdgePatternTilling("Main Edge Pattern Tilling", Float) = 1
		[HDR]_MainEdgeColor1("Main Edge Color 1", Color) = (0,0.171536,1,1)
		[HDR]_MainEdgeColor2("Main Edge Color 2", Color) = (1,0,0.5446758,1)
		[Header(Second Edge)]_SecondEdgeWidth("Second Edge Width", Range( 0 , 0.5)) = 0.02225761
		[NoScaleOffset]_SecondEdgePattern("Second Edge Pattern", 2D) = "black" {}
		_SecondEdgePatternTilling("Second Edge Pattern Tilling", Float) = 1
		[HDR]_SecondEdgeColor1("Second Edge Color 1", Color) = (0,0.171536,1,1)
		[HDR]_SecondEdgeColor2("Second Edge Color 2", Color) = (1,0,0.5446758,1)
		[Toggle(_2SIDESSECONDEDGE_ON)] _2SidesSecondEdge("2 Sides Second Edge", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_local __ _2SIDESSECONDEDGE_ON
		#pragma multi_compile_local __ _GUIDEAFFECTSEDGESBLENDING_ON
		#pragma multi_compile_local _AXIS_X _AXIS_Y _AXIS_Z
		#pragma multi_compile_local __ _USETRIPLANARUVS_ON
		#pragma shader_feature_local _INVERTDIRECTIONMINMAX_ON
		#pragma shader_feature_local _EDGESAFFECT_ALBEDO _EDGESAFFECT_EMISSION
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _VertexDisplacementSecondEdge;
		uniform sampler2D _DisplacementGuide;
		uniform float _DisplacementGuideTilling;
		uniform float _DisplacementGuideTillingSpeed;
		uniform float _VertexDisplacementMainEdge;
		uniform float _DissolveAmount;
		uniform float _SecondEdgeWidth;
		uniform sampler2D _GuideTexture;
		uniform float _GuideTilling;
		uniform float _GuideTillingSpeed;
		uniform float _GuideStrength;
		uniform float _MinValueWhenAmount0;
		uniform float _MaxValueWhenAmount1;
		uniform float _MainEdgeWidth;
		uniform sampler2D _NormalTexture;
		uniform sampler2D _Albedo;
		uniform float4 _Color;
		uniform float4 _SecondEdgeColor1;
		uniform float4 _SecondEdgeColor2;
		uniform sampler2D _SecondEdgePattern;
		uniform float _SecondEdgePatternTilling;
		uniform float4 _MainEdgeColor1;
		uniform float4 _MainEdgeColor2;
		uniform sampler2D _MainEdgePattern;
		uniform float _MainEdgePatternTilling;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionColor;
		uniform sampler2D _MetallicTexture;
		uniform float _MetallicValue;
		uniform float _SmoothnessValue;
		uniform sampler2D _OcclusionMap;
		uniform float _Cutoff = 0.5;


		inline float4 TriplanarSampling68( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.zy * float2(  nsign.x, 1.0 ), 0, 0) );
			yNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xz * float2(  nsign.y, 1.0 ), 0, 0) );
			zNorm = tex2Dlod( topTexMap, float4(tiling * worldPos.xy * float2( -nsign.z, 1.0 ), 0, 0) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling144( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline float4 TriplanarSampling140( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_DisplacementGuideTilling).xx;
			float2 temp_cast_1 = (( _Time.y * _DisplacementGuideTillingSpeed )).xx;
			float2 uv_TexCoord183 = v.texcoord.xy * temp_cast_0 + temp_cast_1;
			float4 tex2DNode186 = tex2Dlod( _DisplacementGuide, float4( uv_TexCoord183, 0, 0.0) );
			float DissolveAmount7 = _DissolveAmount;
			#ifdef _2SIDESSECONDEDGE_ON
				float staticSwitch155 = ( _SecondEdgeWidth / 2.0 );
			#else
				float staticSwitch155 = 0.0;
			#endif
			float3 ase_vertex3Pos = v.vertex.xyz;
			#if defined(_AXIS_X)
				float staticSwitch57 = ase_vertex3Pos.x;
			#elif defined(_AXIS_Y)
				float staticSwitch57 = ase_vertex3Pos.y;
			#elif defined(_AXIS_Z)
				float staticSwitch57 = ase_vertex3Pos.z;
			#else
				float staticSwitch57 = ase_vertex3Pos.y;
			#endif
			float2 temp_cast_2 = (_GuideTilling).xx;
			float temp_output_177_0 = ( _Time.y * _GuideTillingSpeed );
			float2 temp_cast_3 = (temp_output_177_0).xx;
			float2 uv_TexCoord65 = v.texcoord.xy * temp_cast_2 + temp_cast_3;
			float2 temp_cast_4 = (_GuideTilling).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_vertexNormal = v.normal.xyz;
			float4 triplanar68 = TriplanarSampling68( _GuideTexture, ( ase_vertex3Pos + temp_output_177_0 ), ase_vertexNormal, 1.0, temp_cast_4, 1.0, 0 );
			#ifdef _USETRIPLANARUVS_ON
				float staticSwitch71 = triplanar68.x;
			#else
				float staticSwitch71 = tex2Dlod( _GuideTexture, float4( uv_TexCoord65, 0, 0.0) ).r;
			#endif
			float temp_output_16_0 = ( ( staticSwitch71 * _GuideStrength ) + staticSwitch57 );
			#ifdef _GUIDEAFFECTSEDGESBLENDING_ON
				float staticSwitch96 = temp_output_16_0;
			#else
				float staticSwitch96 = staticSwitch57;
			#endif
			float2 appendResult170 = (float2(_MinValueWhenAmount0 , _MaxValueWhenAmount1));
			float2 appendResult171 = (float2(_MaxValueWhenAmount1 , _MinValueWhenAmount0));
			#ifdef _INVERTDIRECTIONMINMAX_ON
				float2 staticSwitch58 = appendResult171;
			#else
				float2 staticSwitch58 = appendResult170;
			#endif
			float2 break172 = staticSwitch58;
			float DissolvelerpA102 = break172.x;
			float temp_output_1_0_g8 = DissolvelerpA102;
			float DissolvelerpB103 = break172.y;
			float temp_output_108_0 = ( ( staticSwitch96 - temp_output_1_0_g8 ) / ( DissolvelerpB103 - temp_output_1_0_g8 ) );
			float DissolveWithEdges104 = ( DissolveAmount7 + _MainEdgeWidth );
			float EdgesAlpha101 = ( step( ( DissolveAmount7 + staticSwitch155 ) , temp_output_108_0 ) - step( ( DissolveWithEdges104 + staticSwitch155 ) , temp_output_108_0 ) );
			float lerpResult53 = lerp( ( _VertexDisplacementSecondEdge * tex2DNode186.r ) , ( tex2DNode186.r * _VertexDisplacementMainEdge ) , EdgesAlpha101);
			float temp_output_1_0_g7 = DissolvelerpA102;
			float temp_output_19_0 = ( ( temp_output_16_0 - temp_output_1_0_g7 ) / ( DissolvelerpB103 - temp_output_1_0_g7 ) );
			float temp_output_22_0 = step( DissolveAmount7 , temp_output_19_0 );
			float smoothstepResult98 = smoothstep( 0.0 , 0.06 , ( temp_output_22_0 - step( ( DissolveAmount7 + ( _MainEdgeWidth + _SecondEdgeWidth ) ) , temp_output_19_0 ) ));
			float EdgeTexBlendAlpha41 = smoothstepResult98;
			float lerpResult56 = lerp( 0.0 , lerpResult53 , EdgeTexBlendAlpha41);
			float3 FinalVertexDisplaement51 = ( lerpResult56 * ase_vertexNormal );
			v.vertex.xyz += FinalVertexDisplaement51;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture157 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _NormalTexture, uv_NormalTexture157 ) );
			float2 uv_Albedo9 = i.uv_texcoord;
			float4 temp_output_10_0 = ( tex2D( _Albedo, uv_Albedo9 ) * _Color );
			float4 color77 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
			float DissolveAmount7 = _DissolveAmount;
			float2 temp_cast_0 = (_GuideTilling).xx;
			float temp_output_177_0 = ( _Time.y * _GuideTillingSpeed );
			float2 temp_cast_1 = (temp_output_177_0).xx;
			float2 uv_TexCoord65 = i.uv_texcoord * temp_cast_0 + temp_cast_1;
			float2 temp_cast_2 = (_GuideTilling).xx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 triplanar68 = TriplanarSampling68( _GuideTexture, ( ase_vertex3Pos + temp_output_177_0 ), ase_vertexNormal, 1.0, temp_cast_2, 1.0, 0 );
			#ifdef _USETRIPLANARUVS_ON
				float staticSwitch71 = triplanar68.x;
			#else
				float staticSwitch71 = tex2D( _GuideTexture, uv_TexCoord65 ).r;
			#endif
			#if defined(_AXIS_X)
				float staticSwitch57 = ase_vertex3Pos.x;
			#elif defined(_AXIS_Y)
				float staticSwitch57 = ase_vertex3Pos.y;
			#elif defined(_AXIS_Z)
				float staticSwitch57 = ase_vertex3Pos.z;
			#else
				float staticSwitch57 = ase_vertex3Pos.y;
			#endif
			float temp_output_16_0 = ( ( staticSwitch71 * _GuideStrength ) + staticSwitch57 );
			float2 appendResult170 = (float2(_MinValueWhenAmount0 , _MaxValueWhenAmount1));
			float2 appendResult171 = (float2(_MaxValueWhenAmount1 , _MinValueWhenAmount0));
			#ifdef _INVERTDIRECTIONMINMAX_ON
				float2 staticSwitch58 = appendResult171;
			#else
				float2 staticSwitch58 = appendResult170;
			#endif
			float2 break172 = staticSwitch58;
			float DissolvelerpA102 = break172.x;
			float temp_output_1_0_g7 = DissolvelerpA102;
			float DissolvelerpB103 = break172.y;
			float temp_output_19_0 = ( ( temp_output_16_0 - temp_output_1_0_g7 ) / ( DissolvelerpB103 - temp_output_1_0_g7 ) );
			float temp_output_22_0 = step( DissolveAmount7 , temp_output_19_0 );
			float smoothstepResult98 = smoothstep( 0.0 , 0.06 , ( temp_output_22_0 - step( ( DissolveAmount7 + ( _MainEdgeWidth + _SecondEdgeWidth ) ) , temp_output_19_0 ) ));
			float EdgeTexBlendAlpha41 = smoothstepResult98;
			float4 lerpResult30 = lerp( temp_output_10_0 , color77 , EdgeTexBlendAlpha41);
			float2 temp_cast_3 = (_SecondEdgePatternTilling).xx;
			float2 uv_TexCoord146 = i.uv_texcoord * temp_cast_3;
			float2 temp_cast_4 = (_SecondEdgePatternTilling).xx;
			float4 triplanar144 = TriplanarSampling144( _SecondEdgePattern, ase_vertex3Pos, ase_vertexNormal, 1.0, temp_cast_4, 1.0, 0 );
			#ifdef _USETRIPLANARUVS_ON
				float staticSwitch145 = triplanar144.x;
			#else
				float staticSwitch145 = tex2D( _SecondEdgePattern, uv_TexCoord146 ).r;
			#endif
			float4 lerpResult128 = lerp( _SecondEdgeColor1 , _SecondEdgeColor2 , staticSwitch145);
			float2 temp_cast_5 = (_MainEdgePatternTilling).xx;
			float2 uv_TexCoord75 = i.uv_texcoord * temp_cast_5;
			float2 temp_cast_6 = (_MainEdgePatternTilling).xx;
			float4 triplanar140 = TriplanarSampling140( _MainEdgePattern, ase_vertex3Pos, ase_vertexNormal, 1.0, temp_cast_6, 1.0, 0 );
			#ifdef _USETRIPLANARUVS_ON
				float staticSwitch141 = triplanar140.x;
			#else
				float staticSwitch141 = tex2D( _MainEdgePattern, uv_TexCoord75 ).r;
			#endif
			float4 lerpResult72 = lerp( _MainEdgeColor1 , _MainEdgeColor2 , staticSwitch141);
			#ifdef _2SIDESSECONDEDGE_ON
				float staticSwitch155 = ( _SecondEdgeWidth / 2.0 );
			#else
				float staticSwitch155 = 0.0;
			#endif
			#ifdef _GUIDEAFFECTSEDGESBLENDING_ON
				float staticSwitch96 = temp_output_16_0;
			#else
				float staticSwitch96 = staticSwitch57;
			#endif
			float temp_output_1_0_g8 = DissolvelerpA102;
			float temp_output_108_0 = ( ( staticSwitch96 - temp_output_1_0_g8 ) / ( DissolvelerpB103 - temp_output_1_0_g8 ) );
			float DissolveWithEdges104 = ( DissolveAmount7 + _MainEdgeWidth );
			float EdgesAlpha101 = ( step( ( DissolveAmount7 + staticSwitch155 ) , temp_output_108_0 ) - step( ( DissolveWithEdges104 + staticSwitch155 ) , temp_output_108_0 ) );
			float4 lerpResult36 = lerp( lerpResult128 , lerpResult72 , EdgesAlpha101);
			float4 lerpResult79 = lerp( float4( 0,0,0,0 ) , lerpResult36 , EdgeTexBlendAlpha41);
			float4 EmissionColor85 = lerpResult79;
			float4 lerpResult203 = lerp( temp_output_10_0 , EmissionColor85 , EdgeTexBlendAlpha41);
			#if defined(_EDGESAFFECT_ALBEDO)
				float4 staticSwitch200 = lerpResult203;
			#elif defined(_EDGESAFFECT_EMISSION)
				float4 staticSwitch200 = lerpResult30;
			#else
				float4 staticSwitch200 = lerpResult30;
			#endif
			o.Albedo = staticSwitch200.rgb;
			float2 uv_EmissionTexture159 = i.uv_texcoord;
			float4 temp_output_160_0 = ( tex2D( _EmissionTexture, uv_EmissionTexture159 ).r * _EmissionColor );
			#if defined(_EDGESAFFECT_ALBEDO)
				float4 staticSwitch201 = temp_output_160_0;
			#elif defined(_EDGESAFFECT_EMISSION)
				float4 staticSwitch201 = ( EmissionColor85 + temp_output_160_0 );
			#else
				float4 staticSwitch201 = ( EmissionColor85 + temp_output_160_0 );
			#endif
			o.Emission = staticSwitch201.rgb;
			float2 uv_MetallicTexture163 = i.uv_texcoord;
			o.Metallic = ( tex2D( _MetallicTexture, uv_MetallicTexture163 ).r * _MetallicValue );
			o.Smoothness = _SmoothnessValue;
			float2 uv_OcclusionMap167 = i.uv_texcoord;
			o.Occlusion = tex2D( _OcclusionMap, uv_OcclusionMap167 ).r;
			o.Alpha = 1;
			float FinalAlpha43 = temp_output_22_0;
			clip( FinalAlpha43 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v, customInputData );
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
}
/*ASEBEGIN
Version=18935
1048;73;1511;652;-186.57;-865.4492;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;178;-5895.397,2304.062;Inherit;False;Property;_GuideTillingSpeed;Guide Tilling Speed;19;0;Create;True;0;0;0;False;0;False;0.005;0;-0.4;0.4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;176;-5777.066,2163.882;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-5593.397,2205.062;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;180;-5578.291,1858.146;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;-5792.507,1918.815;Inherit;False;Property;_GuideTilling;Guide Tilling;18;0;Create;True;0;0;0;False;0;False;1;2.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-5476.412,2049.977;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;69;-5588.503,1649.266;Inherit;True;Property;_GuideTexture;Guide Texture;17;2;[Header];[NoScaleOffset];Create;True;1;Dissolve Guide;0;0;False;1;Space;False;None;b39489d9b019b7244b5d3363a36f50c4;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;21;-4081.694,1495.139;Inherit;False;Property;_MaxValueWhenAmount1;Max Value (When Amount = 1);12;0;Create;True;0;0;0;False;0;False;3;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-5374.291,1897.146;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-4073.315,1382.84;Inherit;False;Property;_MinValueWhenAmount0;Min Value (When Amount = 0);11;0;Create;True;0;0;0;False;0;False;0;-12.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4723.35,1366.183;Inherit;False;Property;_DissolveAmount;Dissolve Amount;10;1;[Header];Create;True;1;Main Dissolve Settings;0;0;False;1;Space;False;1;0.369;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;171;-3758.585,1559.314;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-3788.585,1412.314;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;68;-5235.764,1731.106;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-4429.246,1366.865;Inherit;False;DissolveAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;-5145.047,1941.204;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;71;-4688.156,1800.375;Inherit;False;Property;_UseTriplanarUvs;Use Triplanar Uvs;15;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;15;-4311.597,2273.074;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;58;-3525.311,1449.256;Inherit;False;Property;_InvertDirectionMinMax;Invert Direction (Min & Max);16;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-3002.778,1863.25;Inherit;False;7;DissolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3170.113,2015.005;Inherit;False;Property;_MainEdgeWidth;Main Edge Width;27;1;[Header];Create;True;1;Main Edge;0;0;False;0;False;0.01308131;0.068;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-4415.108,1939.412;Inherit;False;Property;_GuideStrength;Guide Strength;20;0;Create;True;0;0;0;False;0;False;0;0.98;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;57;-4055.09,2192.001;Inherit;True;Property;_Axis;Axis;13;0;Create;True;0;0;0;False;0;False;1;1;1;True;;KeywordEnum;3;X;Y;Z;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;172;-3244.081,1530.362;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2730.302,1851.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-4031.11,1783.646;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-3292.142,2140.939;Inherit;False;Property;_SecondEdgeWidth;Second Edge Width;32;1;[Header];Create;True;1;Second Edge;0;0;False;0;False;0.02225761;0.005;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-3126.4,1579.968;Inherit;False;DissolvelerpB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-3751.864,1884.496;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-2568.533,1843.216;Inherit;False;DissolveWithEdges;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;154;-3101.393,3140.02;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-3134.183,2940.329;Inherit;False;Constant;_Float3;Float 3;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;102;-3118.011,1481.214;Inherit;False;DissolvelerpA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;155;-2961.853,2983.751;Inherit;False;Property;_2SidesSecondEdge;2 Sides Second Edge;37;0;Create;True;0;0;0;False;0;False;1;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-2859.61,2119.153;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-2643.34,2989.775;Inherit;False;104;DissolveWithEdges;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;96;-3629.583,2298.69;Inherit;False;Property;_GuideAffectsEdgesBlending;Guide Affects Edges Blending;21;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-2752.049,2810.447;Inherit;False;103;DissolvelerpB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-2775.67,2711.133;Inherit;False;102;DissolvelerpA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-2612.986,2491.483;Inherit;False;7;DissolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4349.984,582.1639;Inherit;False;Property;_MainEdgePatternTilling;Main Edge Pattern Tilling;29;0;Create;True;0;0;0;False;0;False;1;11.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;19;-2934.608,1604.059;Inherit;False;Inverse Lerp;-1;;7;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-2380.531,3021.329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-2373.864,2568.041;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;108;-2517.508,2772.353;Inherit;False;Inverse Lerp;-1;;8;09cbe79402f023141a4dc1fddd4c9511;0;3;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-4663.433,-364.9583;Inherit;False;Property;_SecondEdgePatternTilling;Second Edge Pattern Tilling;34;0;Create;True;0;0;0;False;0;False;1;11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-2638.214,2178.497;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-2802.645,1464.292;Inherit;False;7;DissolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-4351.57,-426.1532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;22;-2487.915,1439.74;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1951.41,4070.069;Inherit;False;Property;_DisplacementGuideTillingSpeed;Displacement Guide Tilling Speed;25;0;Create;True;0;0;0;False;0;False;0.005;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;190;-1774.981,3932.327;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;-2380.241,2126.751;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;109;-2196.445,2878.577;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;142;-4249.206,251.2721;Inherit;True;Property;_MainEdgePattern;Main Edge Pattern;28;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a1d44fff5896b8b4db9e356abefaced0;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-4020.94,619.6528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;147;-4480.706,-698.3071;Inherit;True;Property;_SecondEdgePattern;Second Edge Pattern;33;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;fc5895d0478aceb4d8032744f6a6b5c4;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StepOpNode;112;-2184.15,2618.555;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;139;-3728.419,504.7194;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;143;-4059.051,-541.0866;Inherit;True;Property;_TextureSample2;Texture Sample 2;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;113;-1775.684,2693.622;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-1763.878,3781.344;Inherit;False;Property;_DisplacementGuideTilling;Displacement Guide Tilling;26;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;140;-3819.137,294.6213;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-1591.312,3973.507;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-2043.069,2044.558;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;144;-4133.371,-762.1162;Inherit;True;Spherical;Object;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;-3629.253,-144.2517;Inherit;False;Property;_MainEdgeColor1;Main Edge Color 1;30;1;[HDR];Create;True;0;0;0;False;0;False;0,0.171536,1,1;0.1415094,0.03451449,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;98;-1751.459,2030.762;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;183;-1360.834,3774.833;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-1464.93,2703.59;Inherit;True;EdgesAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;73;-3623.116,50.73708;Inherit;False;Property;_MainEdgeColor2;Main Edge Color 2;31;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0.5446758,1;4.237095,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;145;-3602.16,-681.9156;Inherit;False;Property;_UseTriplanarUvs;Use Triplanar Uvs;6;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;141;-3271.528,363.8904;Inherit;False;Property;_UseTriplanarUvs;Use Triplanar Uvs;6;0;Create;True;0;0;0;False;0;False;1;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;130;-3535.96,-1214.022;Inherit;False;Property;_SecondEdgeColor1;Second Edge Color 1;35;1;[HDR];Create;True;0;0;0;False;0;False;0,0.171536,1,1;0,7.647191,41.73181,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;185;-1459.425,3478.868;Inherit;True;Property;_DisplacementGuide; Displacement Guide;24;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;a1d44fff5896b8b4db9e356abefaced0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;129;-3529.823,-1019.033;Inherit;False;Property;_SecondEdgeColor2;Second Edge Color 2;36;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0.5446758,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1499.246,2036.651;Inherit;True;EdgeTexBlendAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;128;-3102.957,-617.9714;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;-3180.676,87.38479;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;186;-1068.313,3659.9;Inherit;True;Property;_TextureSample3;Texture Sample 3;17;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-383.1441,3711.096;Inherit;False;Property;_VertexDisplacementMainEdge;Vertex Displacement Main Edge ;22;1;[Header];Create;True;1;Vertex Displacement;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-422.6831,3956.343;Inherit;False;Property;_VertexDisplacementSecondEdge;Vertex Displacement Second Edge;23;0;Create;True;1;;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2890.088,209.703;Inherit;True;101;EdgesAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2381.322,302.6793;Inherit;False;41;EdgeTexBlendAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-2703.718,18.67686;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-122.9497,3578.502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;161.5449,3633.82;Inherit;False;101;EdgesAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-34.85767,4063.197;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;79;-2231.323,72.73815;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;252.8458,3726.76;Inherit;False;41;EdgeTexBlendAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;361.4249,3498.289;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;595.2147,3475.698;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;-1871.134,70.58897;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-551.9696,-169.3529;Inherit;True;Property;_Albedo;Albedo;1;2;[Header];[NoScaleOffset];Create;True;1;PBR Settings;0;0;False;0;False;-1;None;735005267e4d37c4ea0aa10b2cb94ed3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;48;597.0948,3811.602;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-521.3586,23.07026;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;161;-219.5324,1040.567;Inherit;False;Property;_EmissionColor;Emission Color;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;159;-343.222,761.1112;Inherit;True;Property;_EmissionTexture;Emission Texture;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;204;-9.232084,12.27082;Inherit;False;41;EdgeTexBlendAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;77;-254.6662,184.8212;Inherit;False;Constant;_Color0;Color 0;20;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-177.0595,413.1865;Inherit;False;41;EdgeTexBlendAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-236.9604,4.551291;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;795.012,3662.44;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-19.19021,-242.2177;Inherit;False;85;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;121.9856,922.1973;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-38.27685,612.5555;Inherit;False;85;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;357.2116,693.8118;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;165;508.7725,1728.268;Inherit;False;Property;_MetallicValue;Metallic Value;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;1007.176,3625.747;Inherit;False;FinalVertexDisplaement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;163;502.7725,1512.268;Inherit;True;Property;_MetallicTexture;Metallic Texture;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;47.28887,176.2776;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;203;236.1509,-131.4603;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2220.817,1355.663;Inherit;False;FinalAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;957.9808,1292.172;Inherit;False;51;FinalVertexDisplaement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;579.451,1165.885;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;587.8601,1063.024;Inherit;False;43;FinalAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;201;564.9861,739.3658;Inherit;False;Property;_EdgesAffect;EdgesAffect;14;0;Create;True;0;0;0;False;0;False;0;1;1;True;;KeywordEnum;2;Albedo;Emission;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;200;410.2835,318.8828;Inherit;False;Property;_EdgesAffect;EdgesAffect;13;0;Create;True;0;0;0;False;0;False;0;1;1;True;;KeywordEnum;2;Albedo;Emission;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;606.1675,1273.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;726.4832,1414.126;Inherit;False;Property;_SmoothnessValue;Smoothness Value;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;157;1293.521,782.0546;Inherit;True;Property;_NormalTexture;Normal Texture;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;167;1258.498,1009.614;Inherit;True;Property;_OcclusionMap;Occlusion Map;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;205;884.491,822.8542;Float;False;True;-1;2;;0;0;Standard;AxisDissolveMetallic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;177;0;176;0
WireConnection;177;1;178;0
WireConnection;65;0;66;0
WireConnection;65;1;177;0
WireConnection;181;0;180;0
WireConnection;181;1;177;0
WireConnection;171;0;21;0
WireConnection;171;1;20;0
WireConnection;170;0;20;0
WireConnection;170;1;21;0
WireConnection;68;0;69;0
WireConnection;68;9;181;0
WireConnection;68;3;66;0
WireConnection;7;0;6;0
WireConnection;70;0;69;0
WireConnection;70;1;65;0
WireConnection;71;1;70;1
WireConnection;71;0;68;1
WireConnection;58;1;170;0
WireConnection;58;0;171;0
WireConnection;57;1;15;1
WireConnection;57;0;15;2
WireConnection;57;2;15;3
WireConnection;172;0;58;0
WireConnection;24;0;26;0
WireConnection;24;1;25;0
WireConnection;17;0;71;0
WireConnection;17;1;18;0
WireConnection;103;0;172;1
WireConnection;16;0;17;0
WireConnection;16;1;57;0
WireConnection;104;0;24;0
WireConnection;154;0;32;0
WireConnection;102;0;172;0
WireConnection;155;1;156;0
WireConnection;155;0;154;0
WireConnection;38;0;25;0
WireConnection;38;1;32;0
WireConnection;96;1;57;0
WireConnection;96;0;16;0
WireConnection;19;1;102;0
WireConnection;19;2;103;0
WireConnection;19;3;16;0
WireConnection;152;0;105;0
WireConnection;152;1;155;0
WireConnection;153;0;110;0
WireConnection;153;1;155;0
WireConnection;108;1;106;0
WireConnection;108;2;107;0
WireConnection;108;3;96;0
WireConnection;31;0;26;0
WireConnection;31;1;38;0
WireConnection;146;0;133;0
WireConnection;22;0;27;0
WireConnection;22;1;19;0
WireConnection;34;0;31;0
WireConnection;34;1;19;0
WireConnection;109;0;152;0
WireConnection;109;1;108;0
WireConnection;75;0;74;0
WireConnection;112;0;153;0
WireConnection;112;1;108;0
WireConnection;139;0;142;0
WireConnection;139;1;75;0
WireConnection;143;0;147;0
WireConnection;143;1;146;0
WireConnection;113;0;112;0
WireConnection;113;1;109;0
WireConnection;140;0;142;0
WireConnection;140;3;74;0
WireConnection;189;0;190;0
WireConnection;189;1;191;0
WireConnection;35;0;22;0
WireConnection;35;1;34;0
WireConnection;144;0;147;0
WireConnection;144;3;133;0
WireConnection;98;0;35;0
WireConnection;183;0;182;0
WireConnection;183;1;189;0
WireConnection;101;0;113;0
WireConnection;145;1;143;1
WireConnection;145;0;144;1
WireConnection;141;1;139;1
WireConnection;141;0;140;1
WireConnection;41;0;98;0
WireConnection;128;0;130;0
WireConnection;128;1;129;0
WireConnection;128;2;145;0
WireConnection;72;0;37;0
WireConnection;72;1;73;0
WireConnection;72;2;141;0
WireConnection;186;0;185;0
WireConnection;186;1;183;0
WireConnection;36;0;128;0
WireConnection;36;1;72;0
WireConnection;36;2;40;0
WireConnection;188;0;186;1
WireConnection;188;1;54;0
WireConnection;197;0;50;0
WireConnection;197;1;186;1
WireConnection;79;1;36;0
WireConnection;79;2;78;0
WireConnection;53;0;197;0
WireConnection;53;1;188;0
WireConnection;53;2;46;0
WireConnection;56;1;53;0
WireConnection;56;2;55;0
WireConnection;85;0;79;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;47;0;56;0
WireConnection;47;1;48;0
WireConnection;160;0;159;1
WireConnection;160;1;161;0
WireConnection;162;0;86;0
WireConnection;162;1;160;0
WireConnection;51;0;47;0
WireConnection;30;0;10;0
WireConnection;30;1;77;0
WireConnection;30;2;42;0
WireConnection;203;0;10;0
WireConnection;203;1;202;0
WireConnection;203;2;204;0
WireConnection;43;0;22;0
WireConnection;201;1;160;0
WireConnection;201;0;162;0
WireConnection;200;1;203;0
WireConnection;200;0;30;0
WireConnection;164;0;163;1
WireConnection;164;1;165;0
WireConnection;205;0;200;0
WireConnection;205;1;157;0
WireConnection;205;2;201;0
WireConnection;205;3;164;0
WireConnection;205;4;166;0
WireConnection;205;5;167;0
WireConnection;205;10;44;0
WireConnection;205;11;52;0
ASEEND*/
//CHKSM=364EA2F39A71EDA46E4034930CCD84F76DC36FCB