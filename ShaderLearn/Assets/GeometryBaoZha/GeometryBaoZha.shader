// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GeometryBaoZha"
{
	Properties
	{
		_SpriteTex("Base (RGB)", 2D) = "white" {}
		_AccelerationValue("加速度", float) = 0
		_Speed("速度", float) = 0
	}

		SubShader
	{
		Pass
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma target 4.0
		#pragma vertex VS_Main
		#pragma fragment FS_Main
		#pragma geometry GS_Main
		#include "UnityCG.cginc"

		// **************************************************************
		// Data structures                                              *
		// **************************************************************
	struct GS_INPUT
	{
		float4  pos     : POSITION;
		float3  normal  : NORMAL;
		float2  tex0    : TEXCOORD0;
	};

	struct FS_INPUT
	{
		float4  pos     : POSITION;
		float2  tex0    : TEXCOORD0;
	};


	// **************************************************************
	// Vars                                                         *
	// **************************************************************

	float4x4 _VP;
	sampler2D _SpriteTex;
	float4 _SpriteTex_ST;
	float _AccelerationValue;
	float _Speed;

	// **************************************************************
	// Shader Programs                                              *
	// **************************************************************

	// Vertex Shader ------------------------------------------------
	GS_INPUT VS_Main(appdata_base v)
	{
		GS_INPUT output = (GS_INPUT)0;

		output.pos = v.vertex;
		output.normal = v.normal;
		output.tex0 = v.texcoord;

		return output;
	}



	// Geometry Shader -----------------------------------------------------
	[maxvertexcount(4)]
	void GS_Main(triangle GS_INPUT p[3], inout PointStream<FS_INPUT> triStream)
	{

//		正常输出
//		for (int i = 0; i < 3; i++) {
//			FS_INPUT pIn;
//			pIn.pos = mul(UNITY_MATRIX_MVP, p[i].pos);
//			pIn.tex0 = p[i].tex0;
//			triStream.Append(pIn);
//		}

		float3 v1 = p[0].pos - p[1].pos;
		float3 v2 = p[1].pos - p[2].pos;
		float3 normalDir = normalize(cross(v1, v2));
		float3 centerPos = (p[0].pos + p[1].pos + p[2].pos) / 3;
		float3 finallyPos = centerPos + normalDir * (_Time.y * _Speed + 0.5 * pow(_Time.y, 2) * _AccelerationValue);

		FS_INPUT pIn;
		pIn.tex0 = (p[0].tex0 + p[1].tex0 + p[2].tex0) / 3;
		pIn.pos = UnityObjectToClipPos(finallyPos);
		triStream.Append(pIn);
	}



	// Fragment Shader -----------------------------------------------
	float4 FS_Main(FS_INPUT input) : COLOR
	{
//		return fixed4(0, 1, 0, 0);
		return tex2D(_SpriteTex, input.tex0);
	}

		ENDCG
	}
	}
}