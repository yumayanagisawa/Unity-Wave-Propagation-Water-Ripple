// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/sample unlit"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
				float4 screenPos : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : POSITION;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				UNITY_TRANSFER_FOG(o,o.vertex);

				return o;
				
				/*
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.uv = IN.uv;
				//OUT.color = IN.color;
				OUT.screenPos = ComputeScreenPos(OUT.vertex);

				return OUT;
				*/

			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				/*
				float4 screenPos = i.screenPos;
				screenPos.xy = floor(screenPos.xy * _ScreenParams.xy);
				screenPos.xy = floor(screenPos.xy * 0.1) * 0.5;
				// sample the texture
				//float2 p = i.screenPos.xy * i.uv / _ScreenParams.xy;
				fixed4 col = tex2D(_MainTex, screenPos);
				return col;
				*/
				float2 screenPosition = (i.screenPos.xy / i.screenPos.w);

				half4 tex = tex2D(_MainTex, screenPosition);// *IN.color;
				return tex;
			}
			ENDCG
		}
	}
}
