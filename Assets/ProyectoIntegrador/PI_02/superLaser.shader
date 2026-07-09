// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "superLaser"
{
	Properties
	{
		_Color1("Color1", Color) = (0,1,0.8768053,1)
		_Color2("Color2", Color) = (0,0.2155747,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float4 _Color1;
		uniform float4 _Color2;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float cos17 = cos( 7.0 * _Time.y );
			float sin17 = sin( 7.0 * _Time.y );
			float2 rotator17 = mul( uv_Texture0 - float2( 1,1 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 1,1 );
			float clampResult22 = clamp( sin( _Time.y ) , 0.0 , 1.0 );
			float4 lerpResult20 = lerp( _Color1 , _Color2 , clampResult22);
			o.Emission = ( tex2D( _TextureSample0, rotator17 ) * lerpResult20 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
367;73;1139;652;1814.846;512.2841;1.926241;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;23;-606.5623,581.5443;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;19;-1264.848,-341.9211;Inherit;True;Property;_Texture0;Texture 0;3;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SinOpNode;21;-408.7631,576.4725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1025.455,-282.1733;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;22;-271.8248,522.3735;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-673.1318,105.1247;Inherit;False;Property;_Color1;Color1;0;0;Create;True;0;0;0;False;0;False;0,1,0.8768053,1;0,1,0.8768053,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-538.4271,284.7887;Inherit;False;Property;_Color2;Color2;1;0;Create;True;0;0;0;False;0;False;0,0.2155747,1,0;0,0.2155747,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;17;-764.0048,-249.2884;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;7;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;20;-214.3448,265.4032;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-536.8262,-149.7183;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;9789d23040cb1fb45ad60392430c3c15;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-220.8844,9.352451;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;114.9832,15.59094;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;superLaser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;23;0
WireConnection;15;2;19;0
WireConnection;22;0;21;0
WireConnection;17;0;15;0
WireConnection;20;0;10;0
WireConnection;20;1;11;0
WireConnection;20;2;22;0
WireConnection;13;1;17;0
WireConnection;12;0;13;0
WireConnection;12;1;20;0
WireConnection;0;2;12;0
ASEEND*/
//CHKSM=1664099761E9068D0A707C879AF3382821DDB63D