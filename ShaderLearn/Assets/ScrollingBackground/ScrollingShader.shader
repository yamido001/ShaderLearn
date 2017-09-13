Shader "Custom/ScrollingShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DetailTex("Detail texture", 2D) = "white"{}
		_ScrollX1("Base layer scroll speed", Float) = 1
		_ScrollX2("2nd layer scroll speed", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _DetailTex;
			float4 _MainTex_ST;
			float4 _DetailTex_ST;
			float _ScrollX1;
			float _ScrollX2;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex) + float2(_Time.y * _ScrollX1, 0);
				o.uv.zw = TRANSFORM_TEX(v.uv, _DetailTex) + float2(_Time.y * _ScrollX2, 0);
				UNITY_TRANSFER_FOG(o,o.vertex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 mainColor = tex2D(_MainTex, i.uv.xy);
				fixed4 detailColor = tex2D(_DetailTex, i.uv.zw);
				fixed4 finalColor = lerp(mainColor, detailColor, detailColor.a);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, finalColor);
				return finalColor;
			}
			ENDCG
		}
	}
}
