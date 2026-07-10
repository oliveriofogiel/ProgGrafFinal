// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "superLaser"
{
	Properties
	{
		_Color1("Color1", Color) = (0.6544433,0,1,1)
		_Color2("Color2", Color) = (0,0.2155747,1,0)
		_SurfaceTexture("_SurfaceTexture", 2D) = "white" {}
		_TextureController("_TextureController", 2D) = "white" {}
		_VibrationSpeed("_VibrationSpeed", Float) = 20
		_VibrationAmount("_VibrationAmount", Float) = 0.1
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VibrationSpeed;
		uniform float _VibrationAmount;
		uniform sampler2D _SurfaceTexture;
		uniform sampler2D _TextureController;
		uniform float4 _TextureController_ST;
		uniform float4 _Color1;
		uniform float4 _Color2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ase_vertexNormal * ( sin( ( _Time.y * _VibrationSpeed ) ) * _VibrationAmount ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureController = i.uv_texcoord * _TextureController_ST.xy + _TextureController_ST.zw;
			float cos17 = cos( 7.0 * _Time.y );
			float sin17 = sin( 7.0 * _Time.y );
			float2 rotator17 = mul( uv_TextureController - float2( 1,1 ) , float2x2( cos17 , -sin17 , sin17 , cos17 )) + float2( 1,1 );
			float clampResult22 = clamp( sin( _Time.y ) , 0.0 , 1.0 );
			float4 lerpResult20 = lerp( _Color1 , _Color2 , clampResult22);
			o.Emission = ( tex2D( _SurfaceTexture, rotator17 ) * lerpResult20 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
200;73;1168;645;1846.65;86.5614;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;26;-1012.659,901.395;Inherit;False;Property;_VibrationSpeed;_VibrationSpeed;4;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-1048.146,818.5928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-1098.927,594.7202;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;19;-1348.634,39.81249;Inherit;True;Property;_TextureController;_TextureController;3;0;Create;True;0;0;0;False;0;False;0262722e373030545b7df0e094b697c6;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SinOpNode;21;-888.9542,594.1699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1105.388,39.84689;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-835.2252,818.5929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-730.2444,926.5323;Inherit;False;Property;_VibrationAmount;_VibrationAmount;5;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-654.8345,820.071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;22;-747.0157,594.0709;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-812.7783,225.5125;Inherit;False;Property;_Color1;Color1;0;0;Create;True;0;0;0;False;0;False;0.6544433,0,1,1;0,1,0.8768053,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;17;-863.201,43.83819;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;7;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;11;-810.0738,399.1768;Inherit;False;Property;_Color2;Color2;1;0;Create;True;0;0;0;False;0;False;0,0.2155747,1,0;0,0.2155747,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-489.2289,818.5922;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;24;-538.0236,630.8085;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-500.1339,230.3319;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-628.7596,16.30193;Inherit;True;Property;_SurfaceTexture;_SurfaceTexture;2;0;Create;True;0;0;0;False;0;False;-1;9789d23040cb1fb45ad60392430c3c15;9789d23040cb1fb45ad60392430c3c15;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-283.8186,22.37269;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-174.2811,629.3286;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;94.9256,-24.52432;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;superLaser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;23;0
WireConnection;15;2;19;0
WireConnection;27;0;29;0
WireConnection;27;1;26;0
WireConnection;30;0;27;0
WireConnection;22;0;21;0
WireConnection;17;0;15;0
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;20;0;10;0
WireConnection;20;1;11;0
WireConnection;20;2;22;0
WireConnection;13;1;17;0
WireConnection;12;0;13;0
WireConnection;12;1;20;0
WireConnection;25;0;24;0
WireConnection;25;1;31;0
WireConnection;0;2;12;0
WireConnection;0;11;25;0
ASEEND*/
//CHKSM=44C3C2E375CE3B70012F0A43F059B85AA1302D0A