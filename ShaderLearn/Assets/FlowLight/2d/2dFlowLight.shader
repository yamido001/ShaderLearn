Shader "Custom/2dFlowLight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Flow ("Flow texture", 2D) = "white" {}
		_Mask ("Mask texture", 2D) = "white" {}
		_SpeedX("X speed", Float) = 5
		_Stronghold("Strong hold", Range(0, 1)) = 0.5
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
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Flow;
			sampler2D _Mask;
			float _SpeedX;
			float _Stronghold;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed2 flowUV = i.uv;
				flowUV.x = flowUV.x + _SpeedX * _Time.y;
				fixed flowCol = tex2D(_Flow, flowUV).r;
				fixed maskAlpha = tex2D(_Mask, i.uv).a;
				col.rgb = col.rgb + flowCol.xxx * _Stronghold * maskAlpha;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
