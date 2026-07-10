// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "mysteryPortal"
{
	Properties
	{
		_OffsetVFXTexture("OffsetVFXTexture", 2D) = "white" {}
		_BGTextTilling("BGTextTilling", Vector) = (0.13,1.24,0,0)
		_DistortionSpeed("DistortionSpeed", Vector) = (0,-22,0,0)
		_DistortionTexture("DistortionTexture", 2D) = "white" {}
		_TessScale("TessScale", Float) = 1.44
		_DistortionProportion("DistortionProportion", Range( 0 , 1)) = 1
		_BGTexture("BGTexture", 2D) = "white" {}
		_Color("Color", Color) = (0,0,0,0)
		_LivingDir1("LivingDir1", Vector) = (4.88,2.26,-2,0)
		_LivingDir2("LivingDir2", Vector) = (-1,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _OffsetVFXTexture;
		uniform float4 _OffsetVFXTexture_ST;
		uniform float3 _LivingDir1;
		uniform float3 _LivingDir2;
		uniform sampler2D _BGTexture;
		uniform float2 _DistortionSpeed;
		uniform float2 _BGTextTilling;
		uniform sampler2D _DistortionTexture;
		uniform float4 _DistortionTexture_ST;
		uniform float _DistortionProportion;
		uniform float4 _Color;
		uniform float _TessScale;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _TessScale);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_OffsetVFXTexture = v.texcoord * _OffsetVFXTexture_ST.xy + _OffsetVFXTexture_ST.zw;
			float simplePerlin2D55 = snoise( float2( 1,1 )*sin( _Time.y ) );
			simplePerlin2D55 = simplePerlin2D55*0.5 + 0.5;
			float clampResult51 = clamp( simplePerlin2D55 , 0.0 , 1.0 );
			float3 lerpResult43 = lerp( _LivingDir1 , _LivingDir2 , clampResult51);
			v.vertex.xyz += ( tex2Dlod( _OffsetVFXTexture, float4( uv_OffsetVFXTexture, 0, 0.0) ) * float4( lerpResult43 , 0.0 ) ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord21 = i.uv_texcoord * _BGTextTilling;
			float2 uv_DistortionTexture = i.uv_texcoord * _DistortionTexture_ST.xy + _DistortionTexture_ST.zw;
			float2 appendResult22 = (float2(tex2D( _DistortionTexture, uv_DistortionTexture ).rg));
			float2 lerpResult26 = lerp( uv_TexCoord21 , ( appendResult22 + uv_TexCoord21 ) , _DistortionProportion);
			float2 panner27 = ( 1.0 * _Time.y * _DistortionSpeed + lerpResult26);
			o.Emission = ( tex2D( _BGTexture, panner27 ) * _Color ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
367;73;1139;652;2011.102;674.2585;2.144444;True;False
Node;AmplifyShaderEditor.SamplerNode;6;-1517.479,-429.1625;Inherit;True;Property;_DistortionTexture;DistortionTexture;3;0;Create;True;0;0;0;False;0;False;-1;0262722e373030545b7df0e094b697c6;0262722e373030545b7df0e094b697c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;19;-1504.723,-123.6977;Inherit;False;Property;_BGTextTilling;BGTextTilling;1;0;Create;True;0;0;0;False;0;False;0.13,1.24;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1304.711,-112.3009;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1216.643,-321.2301;Inherit;False;FLOAT2;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-1417.548,881.996;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1060.643,-222.2299;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;48;-1240.527,858.5828;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1219.643,12.0531;Inherit;False;Property;_DistortionProportion;DistortionProportion;5;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;25;-851.049,30.06206;Inherit;False;Property;_DistortionSpeed;DistortionSpeed;2;0;Create;True;0;0;0;False;0;False;0,-22;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;26;-918.6434,-139.2301;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;55;-1077.15,819.4536;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;51;-895.1985,684.9337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-671.2433,-112.158;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;-571.1754,-315.9106;Inherit;True;Property;_BGTexture;BGTexture;6;0;Create;True;0;0;0;False;0;False;0262722e373030545b7df0e094b697c6;0262722e373030545b7df0e094b697c6;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector3Node;39;-1131.387,428.5515;Inherit;False;Property;_LivingDir1;LivingDir1;8;0;Create;True;0;0;0;False;0;False;4.88,2.26,-2;-4,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;44;-1118.795,600.7682;Inherit;False;Property;_LivingDir2;LivingDir2;9;0;Create;True;0;0;0;False;0;False;-1,0,0;3,-2,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-924.2218,304.6909;Inherit;True;Property;_OffsetVFXTexture;OffsetVFXTexture;0;0;Create;True;0;0;0;False;0;False;-1;ed149bcd490b31d4c88cb74d9b2000e5;ed149bcd490b31d4c88cb74d9b2000e5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-339.6398,-178.3026;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-741.399,555.5345;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-547.4802,852.4893;Inherit;False;Property;_TessScale;TessScale;4;0;Create;True;0;0;0;False;0;False;1.44;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-332.2077,54.10596;Inherit;False;Property;_Color;Color;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.EdgeLengthTessNode;8;-389.4802,750.4896;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-506.1834,524.9756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-13.97958,-30.41833;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;158.6954,-34.60412;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;mysteryPortal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;19;0
WireConnection;22;0;6;0
WireConnection;24;0;22;0
WireConnection;24;1;21;0
WireConnection;48;0;15;0
WireConnection;26;0;21;0
WireConnection;26;1;24;0
WireConnection;26;2;23;0
WireConnection;55;1;48;0
WireConnection;51;0;55;0
WireConnection;27;0;26;0
WireConnection;27;2;25;0
WireConnection;30;0;32;0
WireConnection;30;1;27;0
WireConnection;43;0;39;0
WireConnection;43;1;44;0
WireConnection;43;2;51;0
WireConnection;8;0;9;0
WireConnection;2;0;1;0
WireConnection;2;1;43;0
WireConnection;33;0;30;0
WireConnection;33;1;34;0
WireConnection;0;2;33;0
WireConnection;0;11;2;0
WireConnection;0;14;8;0
ASEEND*/
//CHKSM=25C4ECBB74CF0AB4FD4C9D332382EB5965C23457