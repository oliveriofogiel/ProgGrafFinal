// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DroidekaShieldShader"
{
	Properties
	{
		_ShieldColor("ShieldColor", Color) = (0,0.8143575,1,0)
		_EdgeColor("EdgeColor", Color) = (0.7216981,1,0.9752858,0)
		_Opacity("Opacity", Float) = 0.2
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_FrenselPower("FrenselPower", Float) = 3
		_FrenselIntensity("FrenselIntensity", Float) = 2
		_LineStrength("LineStrength", Range( -1 , 1)) = 0
		_LineAmount("LineAmount", Float) = 40
		_LineSpeed("LineSpeed", Float) = 1
		_HitShield("HitShield", Vector) = (0,0,0,0)
		_NoiseStrength("NoiseStrength", Range( -1 , 1)) = 0
		_ShieldPatternScale("ShieldPatternScale", Range( 0 , 10)) = 2.414924
		_impactRadius("impactRadius", Range( 0 , 2)) = 1
		_TimeMult("TimeMult", Float) = 0.62
		_MaxDeform("MaxDeform", Float) = 0.025
		_MinDeform("MinDeform", Float) = 0.01
		_HitTime("HitTime", Float) = 0
		_WaveFrequency("WaveFrequency", Float) = 0
		_WaveSpeed("WaveSpeed", Float) = 0
		_LifeShield("LifeShield", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
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

		uniform float _HitTime;
		uniform float _impactRadius;
		uniform float3 _HitShield;
		uniform float _WaveFrequency;
		uniform float _WaveSpeed;
		uniform float _MaxDeform;
		uniform float _MinDeform;
		uniform sampler2D _TextureSample0;
		uniform float _ShieldPatternScale;
		uniform float _TimeMult;
		uniform float _NoiseStrength;
		uniform float _LineAmount;
		uniform float _LineSpeed;
		uniform float _LineStrength;
		uniform float4 _ShieldColor;
		uniform float _LifeShield;
		uniform float _FrenselPower;
		uniform float _FrenselIntensity;
		uniform float4 _EdgeColor;
		uniform float _Opacity;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float age115 = (0.0 + (_HitTime - 500.0) * (1.0 - 0.0) / (0.0 - 500.0));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_81_0 = distance( ase_vertex3Pos , _HitShield );
			float smoothstepResult116 = smoothstep( _impactRadius , 0.0 , temp_output_81_0);
			float MaxDeformVar131 = _MaxDeform;
			float3 ase_vertexNormal = v.normal.xyz;
			float simplePerlin2D71 = snoise( ( v.texcoord.xy + ( _Time.y * float2( 0.1,0 ) ) )*15.0 );
			simplePerlin2D71 = simplePerlin2D71*0.5 + 0.5;
			v.vertex.xyz += ( ( ( ( ( sin( ( age115 * UNITY_PI ) ) * smoothstepResult116 ) * sin( ( ( temp_output_81_0 * _WaveFrequency ) - ( age115 * _WaveSpeed ) ) ) ) * MaxDeformVar131 ) * ase_vertexNormal ) + ( ase_vertexNormal * (_MinDeform + (simplePerlin2D71 - -1.0) * (_MaxDeform - _MinDeform) / (1.0 - -1.0)) ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult88 = (float4(_ShieldPatternScale , _ShieldPatternScale , _ShieldPatternScale , 0.0));
			float mulTime91 = _Time.y * _TimeMult;
			float4 appendResult94 = (float4(0.1 , mulTime91 , 0.0 , 0.0));
			float2 uv_TexCoord89 = i.uv_texcoord * appendResult88.xy + appendResult94.xy;
			float temp_output_44_0 = ( ( (tex2D( _TextureSample0, uv_TexCoord89 )).r * _NoiseStrength ) + ( pow( abs( sin( ( ( (i.uv_texcoord).y * _LineAmount ) + ( _Time.y * _LineSpeed ) ) ) ) , 8.0 ) * _LineStrength ) );
			float4 color138 = IsGammaSpace() ? float4(0.735849,0.03327752,0,0) : float4(0.5007474,0.002575659,0,0);
			float LifeVar144 = _LifeShield;
			float4 lerpResult139 = lerp( ( temp_output_44_0 * color138 ) , ( _ShieldColor * temp_output_44_0 ) , LifeVar144);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV15 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode15 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV15, _FrenselPower ) );
			float temp_output_16_0 = ( fresnelNode15 * _FrenselIntensity );
			float4 color142 = IsGammaSpace() ? float4(0.6698113,0,0,0) : float4(0.4061945,0,0,0);
			float4 lerpResult141 = lerp( ( temp_output_16_0 * color142 ) , ( temp_output_16_0 * _EdgeColor ) , _LifeShield);
			o.Emission = ( lerpResult139 + lerpResult141 ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
40;775;1197;517;3306.539;-979.7002;2.204097;True;False
Node;AmplifyShaderEditor.CommentaryNode;41;-3039.992,784.5515;Inherit;False;1646.765;368.4104;LinesVALUE;13;12;39;43;42;34;36;33;10;31;35;30;11;40;NoiseLines;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;97;-3064.698,1852.262;Inherit;False;2470.508;1156.761;Comment;27;135;117;134;133;132;130;129;116;125;127;128;126;118;124;81;120;115;114;119;113;107;82;122;85;121;83;136;ImpactReactionInProgress;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-3043.942,284.5549;Inherit;False;1825.964;442.0477;NoiseVALUE;11;22;9;90;89;88;94;87;91;93;92;23;Emission Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-2999.762,838.2636;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-2751.305,914.1052;Inherit;False;Property;_LineAmount;LineAmount;7;0;Create;True;0;0;0;False;0;False;40;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-2725.986,994.8419;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2704.705,1078.436;Inherit;False;Property;_LineSpeed;LineSpeed;8;0;Create;True;0;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-2941.864,649.5964;Inherit;False;Property;_TimeMult;TimeMult;13;0;Create;True;0;0;0;False;0;False;0.62;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-3013.577,1947.094;Inherit;False;Property;_HitTime;HitTime;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;-2746.938,833.0634;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-2490.186,837.7457;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;114;-2859.923,1934.905;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;500;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-2503.14,1008.841;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-2724.71,576.5163;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;91;-2747.329,654.9674;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2842.006,439.5385;Inherit;False;Property;_ShieldPatternScale;ShieldPatternScale;11;0;Create;True;0;0;0;False;0;False;2.414924;9.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-2458.22,580.4472;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;82;-3012.521,2236.367;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-2607.16,1998.371;Inherit;False;age;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-2252.616,837.9204;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;83;-2979.632,2400.355;Inherit;False;Property;_HitShield;HitShield;9;0;Create;True;0;0;0;False;0;False;0,0,0;-0.2529016,0,-0.3931968;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;88;-2460.849,440.2798;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;-2295.331,416.2977;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;42;-2116.32,837.9591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-2719.233,2829.064;Inherit;False;Property;_WaveSpeed;WaveSpeed;18;0;Create;True;0;0;0;False;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;121;-2436.709,2100.862;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-2725.079,2723.656;Inherit;False;115;age;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-3055.66,3035.546;Inherit;False;1422.49;639.8044;Comment;12;100;99;74;72;79;71;67;68;55;69;70;131;Bubble Movement;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2770.643,2458.577;Inherit;False;Property;_WaveFrequency;WaveFrequency;17;0;Create;True;0;0;0;False;0;False;0;25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;81;-2771.139,2236.844;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2232.297,1974.882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;69;-2980.43,3262.777;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2448.034,2653.9;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-2535.158,2457.089;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-2283.435,2370.419;Inherit;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-2055.239,411.8331;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;5798ded558355430c8a9b13ee12a847c;5798ded558355430c8a9b13ee12a847c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-3039.875,1239.922;Inherit;False;1529.042;492.269;FresnelCOLOR;10;17;2;16;5;15;4;140;141;142;143;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2565.646,2299.897;Inherit;False;Property;_impactRadius;impactRadius;12;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;70;-2966.204,3347.784;Inherit;False;Constant;_Vector0;Vector 0;11;0;Create;True;0;0;0;False;0;False;0.1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.AbsOpNode;43;-1976.374,838.9591;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2956.342,1479.107;Inherit;False;Property;_FrenselPower;FrenselPower;4;0;Create;True;0;0;0;False;0;False;3;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1773.007,608.7701;Inherit;False;Property;_NoiseStrength;NoiseStrength;10;0;Create;True;0;0;0;False;0;False;0;0.78;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;22;-1644.993,411.3184;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;39;-1799.906,838.0575;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1901.61,965.1008;Inherit;False;Property;_LineStrength;LineStrength;6;0;Create;True;0;0;0;False;0;False;0;0.43;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;122;-2059.077,1980.132;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;116;-2133.711,2236.845;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;-2142.51,2453.191;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2246.752,3593.165;Inherit;False;Property;_MaxDeform;MaxDeform;14;0;Create;True;0;0;0;False;0;False;0.025;0.025;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;55;-2806.235,3176.51;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2726.268,3329.054;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;47;-919.8848,272.5812;Inherit;False;1061.623;506.2635;EnergyColor;6;46;1;138;139;137;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-1783.843,2213.182;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;129;-1886.024,2452.692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-1977.051,3575.32;Inherit;False;MaxDeformVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2560.524,3305.43;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-1953.556,1597.852;Inherit;False;Property;_LifeShield;LifeShield;19;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2687.135,1475.562;Inherit;False;Property;_FrenselIntensity;FrenselIntensity;5;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1401.233,420.1552;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1149.136,557.1829;Inherit;False;202;185;EnergyPattern;1;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;15;-2716.357,1288.658;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1578.263,838.096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;138;-783.5859,357.9869;Inherit;False;Constant;_Color0;Color 0;19;0;Create;True;0;0;0;False;0;False;0.735849,0.03327752,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1669.719,1544.124;Inherit;False;LifeVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;142;-2317.062,1362.018;Inherit;False;Constant;_Color1;Color 1;19;0;Create;True;0;0;0;False;0;False;0.6698113,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-2434.739,1540.321;Inherit;False;Property;_EdgeColor;EdgeColor;1;0;Create;True;0;0;0;False;0;False;0.7216981,1,0.9752858,0;0.7215686,0.8619683,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2439.834,1305.262;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-783.4431,572.6006;Inherit;False;Property;_ShieldColor;ShieldColor;0;0;Create;True;0;0;0;False;0;False;0,0.8143575,1,0;0,0.6807935,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;-2244.277,3517.718;Inherit;False;Property;_MinDeform;MinDeform;15;0;Create;True;0;0;0;False;0;False;0.01;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;71;-2333.222,3299.837;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1545.518,2212.672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1099.136,607.1829;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1598.888,2435.232;Inherit;False;131;MaxDeformVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-520.6141,349.0153;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-2106.116,1306.105;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;135;-1358.172,2433.018;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-2185.896,1532.046;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-511.4381,564.3818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;79;-2052.962,3155.123;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;-1337.643,2211.436;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-315.8345,640.8782;Inherit;False;144;LifeVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;72;-2059.277,3304.236;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;0.025;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1765.744,3280.169;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;141;-1821.466,1387.433;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-1161.776,2211.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;139;-188.7788,459.8025;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-487.3008,995.8607;Inherit;False;Property;_Opacity;Opacity;2;0;Create;True;0;0;0;False;0;False;0.2;0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-478.5717,820.8838;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2790.974,2561.526;Inherit;False;HitVar;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-902.2335,2211.456;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;329.1,784.0998;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;DroidekaShieldShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;0
WireConnection;33;0;31;0
WireConnection;33;1;10;0
WireConnection;114;0;113;0
WireConnection;36;0;35;0
WireConnection;36;1;11;0
WireConnection;91;0;92;0
WireConnection;94;0;93;0
WireConnection;94;1;91;0
WireConnection;115;0;114;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;88;0;87;0
WireConnection;88;1;87;0
WireConnection;88;2;87;0
WireConnection;89;0;88;0
WireConnection;89;1;94;0
WireConnection;42;0;34;0
WireConnection;81;0;82;0
WireConnection;81;1;83;0
WireConnection;120;0;115;0
WireConnection;120;1;121;0
WireConnection;126;0;125;0
WireConnection;126;1;127;0
WireConnection;118;0;81;0
WireConnection;118;1;119;0
WireConnection;90;1;89;0
WireConnection;43;0;42;0
WireConnection;22;0;90;0
WireConnection;39;0;43;0
WireConnection;122;0;120;0
WireConnection;116;0;81;0
WireConnection;116;1;85;0
WireConnection;116;2;117;0
WireConnection;128;0;118;0
WireConnection;128;1;126;0
WireConnection;68;0;69;0
WireConnection;68;1;70;0
WireConnection;124;0;122;0
WireConnection;124;1;116;0
WireConnection;129;0;128;0
WireConnection;131;0;100;0
WireConnection;67;0;55;0
WireConnection;67;1;68;0
WireConnection;23;0;22;0
WireConnection;23;1;9;0
WireConnection;15;3;4;0
WireConnection;40;0;39;0
WireConnection;40;1;12;0
WireConnection;144;0;143;0
WireConnection;16;0;15;0
WireConnection;16;1;5;0
WireConnection;71;0;67;0
WireConnection;130;0;124;0
WireConnection;130;1;129;0
WireConnection;44;0;23;0
WireConnection;44;1;40;0
WireConnection;137;0;44;0
WireConnection;137;1;138;0
WireConnection;140;0;16;0
WireConnection;140;1;142;0
WireConnection;17;0;16;0
WireConnection;17;1;2;0
WireConnection;46;0;1;0
WireConnection;46;1;44;0
WireConnection;132;0;130;0
WireConnection;132;1;133;0
WireConnection;72;0;71;0
WireConnection;72;3;99;0
WireConnection;72;4;100;0
WireConnection;74;0;79;0
WireConnection;74;1;72;0
WireConnection;141;0;140;0
WireConnection;141;1;17;0
WireConnection;141;2;143;0
WireConnection;134;0;132;0
WireConnection;134;1;135;0
WireConnection;139;0;137;0
WireConnection;139;1;46;0
WireConnection;139;2;145;0
WireConnection;48;0;139;0
WireConnection;48;1;141;0
WireConnection;107;0;83;0
WireConnection;136;0;134;0
WireConnection;136;1;74;0
WireConnection;0;2;48;0
WireConnection;0;9;3;0
WireConnection;0;11;136;0
ASEEND*/
//CHKSM=DD63EC2E98C18AF18737635A37C9A6E708FBCB0A