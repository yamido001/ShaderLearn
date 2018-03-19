// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/anbianshui"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite On
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 projPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _CameraDepthTexture; 
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.projPos = ComputeScreenPos(o.vertex);
				COMPUTE_EYEDEPTH(o.projPos.z);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);


				o.projPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));  
            	COMPUTE_EYEDEPTH(o.projPos.z); 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				half cameraDepth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, i.projPos).r);
				col.r = i.projPos.z;
				col.gb = 0;
				col.a = 1;

				float4 testPos;
				testPos.rgba = 0.5;
				float m_depth = LinearEyeDepth(tex2Dproj (_CameraDepthTexture, testPos).r);  
				col.r = m_depth;
				return col;
			}
			ENDCG
		}
	}
}
