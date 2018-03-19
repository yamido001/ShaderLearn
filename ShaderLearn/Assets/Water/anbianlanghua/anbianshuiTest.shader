// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/anbianshuiTest"
{
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		LOD 100
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
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
				float4 vertex : SV_POSITION;
				float4 projPos : TEXCOORD1;
			};

			sampler2D _CameraDepthTexture; 
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.projPos = ComputeScreenPos(UnityObjectToClipPos(v.vertex));  
            	COMPUTE_EYEDEPTH(o.projPos.z); 
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 col;
//				i.projPos.xy = 0.5;
				float depth = LinearEyeDepth(tex2Dproj (_CameraDepthTexture, i.projPos).r);  
				col.r = depth - i.projPos.z;
//				col.r = depth;
				col.a = 1;
				col.gb = 0;
				return col;
			}
			ENDCG
		}
	}
}
