Shader "Custom/BlackHole"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlackHolePos("Black hole pos", vector) = (0, 0, 0, 0)
		_BlackRange("Balck range, 不是精确值", float) = 1
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
			float3 _BlackHolePos;
			float _BlackRange;

			v2f vert (appdata v)
			{
				v2f o;

				half4 worldPos = mul(unity_ObjectToWorld, v.vertex);

				//之所以减少0.5,是因为如果不减少的时候，是为了当worldPos和_BlackHolePos到达比较小的距离时，让结果为0，因为效果需要是在比较近的距离时，就完全吸收掉
				half _disLerpValue = saturate(distance(worldPos, _BlackHolePos) / _BlackRange - 1);
				o.vertex = UnityObjectToClipPos(lerp(_BlackHolePos, worldPos, _disLerpValue));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
