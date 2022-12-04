// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissolveMetallic"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(PBR Settings)][NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		[NoScaleOffset][Normal]_NormalTexture("Normal Texture", 2D) = "bump" {}
		[NoScaleOffset]_MetallicTexture("Metallic Texture", 2D) = "white" {}
		_MetallicValue("Metallic Value", Range( 0 , 1)) = 0
		_SmoothnessValue("Smoothness Value", Range( 0 , 1)) = 0
		[NoScaleOffset]_EmissionTexture("Emission Texture", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[NoScaleOffset]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		[Header(Dissolve Settings)]_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0.3801628
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,0,0,0)
		_EdgeWidth("Edge Width", Range( 0 , 0.1)) = 0
		_GuideTexture("Guide Texture", 2D) = "white" {}
		_GuideAdjuster("Guide Adjuster", Range( 1 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalTexture;
		uniform sampler2D _Albedo;
		uniform float4 _Color;
		uniform float4 _DissolveColor;
		uniform sampler2D _GuideTexture;
		uniform float4 _GuideTexture_ST;
		uniform float _GuideAdjuster;
		uniform float _DissolveAmount;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionColor;
		uniform sampler2D _MetallicTexture;
		uniform float _MetallicValue;
		uniform float _SmoothnessValue;
		uniform sampler2D _OcclusionMap;
		uniform float _EdgeWidth;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTexture44 = i.uv_texcoord;
			o.Normal = UnpackNormal( tex2D( _NormalTexture, uv_NormalTexture44 ) );
			float2 uv_Albedo7 = i.uv_texcoord;
			o.Albedo = ( tex2D( _Albedo, uv_Albedo7 ) * _Color ).rgb;
			float2 uv_GuideTexture = i.uv_texcoord * _GuideTexture_ST.xy + _GuideTexture_ST.zw;
			float temp_output_59_0 = ( tex2D( _GuideTexture, uv_GuideTexture ).r * _GuideAdjuster );
			float DissolveAmount39 = _DissolveAmount;
			float4 lerpResult24 = lerp( float4( 0,0,0,0 ) , _DissolveColor , step( temp_output_59_0 , DissolveAmount39 ));
			float2 uv_EmissionTexture49 = i.uv_texcoord;
			o.Emission = ( lerpResult24 + ( tex2D( _EmissionTexture, uv_EmissionTexture49 ).r * _EmissionColor ) ).rgb;
			float2 uv_MetallicTexture56 = i.uv_texcoord;
			o.Metallic = ( tex2D( _MetallicTexture, uv_MetallicTexture56 ).r * _MetallicValue );
			o.Smoothness = _SmoothnessValue;
			float2 uv_OcclusionMap54 = i.uv_texcoord;
			o.Occlusion = tex2D( _OcclusionMap, uv_OcclusionMap54 ).r;
			o.Alpha = 1;
			clip( ( temp_output_59_0 <= (0.0 + (( DissolveAmount39 - _EdgeWidth ) - 0.0) * (1.0 - 0.0) / (( 1.0 - _EdgeWidth ) - 0.0)) ? 0.0 : 1.0 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18935
1048;73;1511;652;1514.235;249.665;1.685445;True;True
Node;AmplifyShaderEditor.RangedFloatNode;27;-1203.065,-293.2148;Inherit;False;Property;_DissolveAmount;Dissolve Amount;10;1;[Header];Create;True;1;Dissolve Settings;0;0;False;0;False;0.3801628;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-864.3917,-94.01279;Inherit;False;DissolveAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-1576.852,-221.8973;Inherit;True;Property;_GuideTexture;Guide Texture;13;0;Create;True;0;0;0;False;0;False;-1;16d574e53541bba44a84052fa38778df;16d574e53541bba44a84052fa38778df;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-1360.229,-7.896393;Inherit;False;Property;_GuideAdjuster;Guide Adjuster;14;0;Create;True;0;0;0;False;0;False;1;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1861.998,772.6605;Inherit;False;Property;_EdgeWidth;Edge Width;12;0;Create;True;0;0;0;False;0;False;0;0;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-1538.719,941.8334;Inherit;False;39;DissolveAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1242.229,-150.8964;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-1197.868,794.4542;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-1367.477,642.2601;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-438.3654,-158.2253;Inherit;True;Property;_EmissionTexture;Emission Texture;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;26;-596.3804,-201.6516;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-728.9799,-756.7633;Inherit;False;Property;_DissolveColor;Dissolve Color;11;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;46;-392.8739,33.20774;Inherit;False;Property;_EmissionColor;Emission Color;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;56;-550.8893,526.211;Inherit;True;Property;_MetallicTexture;Metallic Texture;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-544.8893,742.211;Inherit;False;Property;_MetallicValue;Metallic Value;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1125.353,-612.3256;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1155.964,-804.7487;Inherit;True;Property;_Albedo;Albedo;1;2;[Header];[NoScaleOffset];Create;True;1;PBR Settings;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1006.775,630.3441;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-44.80141,-32.70926;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;24;-406.8965,-349.3625;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-222.8892,586.211;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-122.6805,-328.9593;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-840.9538,-630.8445;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;29.09024,144.7016;Inherit;False;Property;_SmoothnessValue;Smoothness Value;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;54;62.08884,428.3388;Inherit;True;Property;_OcclusionMap;Occlusion Map;9;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;65.70275,-597.1037;Inherit;True;Property;_NormalTexture;Normal Texture;3;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;37;-737.0383,85.54443;Inherit;True;5;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;61;391.9247,0;Float;False;True;-1;2;;0;0;Standard;DissolveMetallic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;False;Opaque;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;39;0;27;0
WireConnection;59;0;21;1
WireConnection;59;1;60;0
WireConnection;29;0;40;0
WireConnection;29;1;28;0
WireConnection;31;1;28;0
WireConnection;26;0;59;0
WireConnection;26;1;39;0
WireConnection;33;0;29;0
WireConnection;33;2;31;0
WireConnection;42;0;49;1
WireConnection;42;1;46;0
WireConnection;24;1;25;0
WireConnection;24;2;26;0
WireConnection;57;0;56;1
WireConnection;57;1;55;0
WireConnection;58;0;24;0
WireConnection;58;1;42;0
WireConnection;22;0;7;0
WireConnection;22;1;23;0
WireConnection;37;0;59;0
WireConnection;37;1;33;0
WireConnection;61;0;22;0
WireConnection;61;1;44;0
WireConnection;61;2;58;0
WireConnection;61;3;57;0
WireConnection;61;4;47;0
WireConnection;61;5;54;0
WireConnection;61;10;37;0
ASEEND*/
//CHKSM=F796EC4C36E61C236DF3F3B70ACD23AC51E44E1B