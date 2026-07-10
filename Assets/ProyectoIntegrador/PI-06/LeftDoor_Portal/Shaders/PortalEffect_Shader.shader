// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PortalEffect_Shader"
{
	Properties
	{
		_BackgroundColor("Background Color", Color) = (1,0,0,1)
		_Albedo("Albedo", 2D) = "white" {}
		_Bias_Fresnel("Bias_Fresnel", Range( 0 , 1)) = 0
		_Scale("Scale", Vector) = (20,20,0,0)
		_Scale_Fresnel("Scale_Fresnel", Range( 0 , 5)) = 1
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_Power_Fresnel("Power_Fresnel", Range( 0 , 5)) = 1
		_Invert("Invert?", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 2
		_FresnelColor("Fresnel Color", Color) = (1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _BackgroundColor;
		uniform sampler2D _Albedo;
		uniform float2 _Scale;
		uniform float _Speed;
		uniform float _Bias_Fresnel;
		uniform float _Scale_Fresnel;
		uniform float _Power_Fresnel;
		uniform float _Invert;
		uniform float4 _FresnelColor;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime43 = _Time.y * _Speed;
			float4 appendResult44 = (float4(0.0 , mulTime43 , 0.0 , 0.0));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV97 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode97 = ( _Bias_Fresnel + _Scale_Fresnel * pow( 1.0 - fresnelNdotV97, _Power_Fresnel ) );
			float lerpResult101 = lerp( fresnelNode97 , ( 1.0 - fresnelNode97 ) , _Invert);
			o.Albedo = ( ( _BackgroundColor * tex2D( _Albedo, ( float4( ( i.uv_texcoord * _Scale ), 0.0 , 0.0 ) + appendResult44 ).xy ) ) + ( lerpResult101 * _FresnelColor ) ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
377;81;1189;593;3257.882;537.3728;3.548095;True;False
Node;AmplifyShaderEditor.RangedFloatNode;96;-1524.553,939.5896;Inherit;False;Property;_Power_Fresnel;Power_Fresnel;6;0;Create;True;0;0;0;False;0;False;1;1.14046;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-1531.172,735.4896;Inherit;False;Property;_Bias_Fresnel;Bias_Fresnel;2;0;Create;True;0;0;0;False;0;False;0;0.1882353;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1511.273,422.8736;Inherit;False;Property;_Speed;Speed;9;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-1527.147,839.4892;Inherit;False;Property;_Scale_Fresnel;Scale_Fresnel;4;0;Create;True;0;0;0;False;0;False;1;2.129412;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;97;-1234.299,780.2459;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-1293.37,428.7768;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;106;-1407.793,44.56989;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;38;-1354.914,183.1919;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;0;False;0;False;20,20;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-1128.155,163.6655;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1044.369,429.7768;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-1105.099,1035.601;Inherit;False;Property;_Invert;Invert?;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;98;-941.7947,847.789;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;100;-735.0551,1040.722;Inherit;False;Property;_FresnelColor;Fresnel Color;10;0;Create;True;0;0;0;False;0;False;1,0,0,0;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;101;-766.1915,780.1197;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.09;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-795.4788,100.7051;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-866.8188,-161.2421;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;a2986a87276e6ea44a553f2159fb9714;a2986a87276e6ea44a553f2159fb9714;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;1;-397.5789,-135.9356;Inherit;False;Property;_BackgroundColor;Background Color;0;0;Create;True;0;0;0;False;0;False;1,0,0,1;0.5379593,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-481.9217,71.5539;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;9851dfcdef4fcd4458527a6f4e45b375;9851dfcdef4fcd4458527a6f4e45b375;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-458.9547,774.1418;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;105;89.13322,618.3523;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-119.311,54.18618;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1718.482,416.5664;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;228.8067,51.47972;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;263.2116,315.7121;Inherit;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;0;False;0;False;0.5;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2207.49,509.5663;Inherit;False;Property;_Divide;Divide;7;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;36;-2225.979,618.6216;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;40;-1962.49,416.5664;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;37;-1970.941,613.6534;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;609.2084,51.19202;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PortalEffect_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;97;1;95;0
WireConnection;97;2;94;0
WireConnection;97;3;96;0
WireConnection;43;0;42;0
WireConnection;107;0;106;0
WireConnection;107;1;38;0
WireConnection;44;1;43;0
WireConnection;98;0;97;0
WireConnection;101;0;97;0
WireConnection;101;1;98;0
WireConnection;101;2;99;0
WireConnection;45;0;107;0
WireConnection;45;1;44;0
WireConnection;4;0;3;0
WireConnection;4;1;45;0
WireConnection;102;0;101;0
WireConnection;102;1;100;0
WireConnection;105;0;102;0
WireConnection;5;0;1;0
WireConnection;5;1;4;0
WireConnection;41;0;40;0
WireConnection;41;1;37;0
WireConnection;104;0;5;0
WireConnection;104;1;105;0
WireConnection;40;1;39;0
WireConnection;37;0;36;0
WireConnection;0;0;104;0
WireConnection;0;9;67;0
ASEEND*/
//CHKSM=7FAF8568184A34986D3025888C13C04A132F9BC8