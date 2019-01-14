//https://www.shadertoy.com/view/4dK3Ww
Shader "Unlit/Simple Water Flexible Aspect Ratio"
{
	Properties
	{
		iChannel1("Texture", 2D) = "white" {}
		iMouse("mouse", Vector) = (0, 0, 0, 0)
		handPos1("handPos1", Vector) = (0, 0, 0, 0)
		handPos2("handPos2", Vector) = (0, 0, 0, 0)
		handPos3("handPos3", Vector) = (0, 0, 0, 0)
		handPos4("handPos4", Vector) = (0, 0, 0, 0)
		handPos5("handPos5", Vector) = (0, 0, 0, 0)
		handPos6("handPos6", Vector) = (0, 0, 0, 0)
		handPos7("handPos7", Vector) = (0, 0, 0, 0)
		handPos8("handPos8", Vector) = (0, 0, 0, 0)
		handPos9("handPos9", Vector) = (0, 0, 0, 0)
		handPos10("handPos10", Vector) = (0, 0, 0, 0)
		handPos11("handPos11", Vector) = (0, 0, 0, 0)
		handPos12("handPos12", Vector) = (0, 0, 0, 0)
		iMouse("mouse", Vector) = (0, 0, 0, 0)
		_RippleWidth("Ripple Width", float) = 1.0
		_RippleHeight("Ripple Height", float) = 1.0
		waveScaleFactor("Wave Scale", Range(5.0,10.0)) = 7.5
		_specular("Specular", Range(10.0,100.0)) = 10.0
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

			sampler2D _bufferA;
			float3 iMouse;
			float3 handPos1;
			float3 handPos2;
			float3 handPos3;
			float3 handPos4;
			float3 handPos5;
			float3 handPos6;
			float3 handPos7;
			float3 handPos8;
			float3 handPos9;
			float3 handPos10;
			float3 handPos11;
			float3 handPos12;
			float _RippleWidth;
			float _RippleHeight;
			float4 _bufferA_ST;
			float waveScaleFactor;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 screenPos : TEXCOORD1;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{

				float3 e = float3(float2(_RippleWidth, _RippleHeight) / _ScreenParams.xy, 0.);
				//float2 q = i.uv; //fragCoord.xy / _ScreenParams.xy;
				// flexible aspect ratio
				float2 q = (i.screenPos.xy / i.screenPos.w);

				float4 c = tex2D(_bufferA, q);

				float p11 = c.y;

				float p10 = tex2D(_bufferA, q - e.zy).x;
				float p01 = tex2D(_bufferA, q - e.xz).x;
				float p21 = tex2D(_bufferA, q + e.xz).x;
				float p12 = tex2D(_bufferA, q + e.zy).x;

				float d = 0.;

				// add ripples
				d = smoothstep(waveScaleFactor, .5, length(handPos1.xy - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos2.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos3.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos4.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos5.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos6.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos7.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos8.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos9.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos10.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos11.xy) - (q *_ScreenParams.xy)));
				d += smoothstep(waveScaleFactor, .5, length((handPos12.xy) - (q *_ScreenParams.xy)));

				// The actual propagation:
				d += -(p11 - .5)*2. + (p10 + p01 + p21 + p12 - 2.);
				d *= .99; // dampening
				//d *= float(iFrame >= 2); // clear the buffer at iFrame < 2
				d = d * .5 + .5;

				// Put previous state as "y":
				return fixed4(d, c.x, 0, 0);
			}
			ENDCG
		}
		GrabPass{ "_bufferA" }
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			sampler2D _bufferA;
			sampler2D iChannel1;
			float4 iChannel1_ST;
			float4 _bufferA_ST;
			float3 iMouse;
			float _specular;

			#define TEXTURED 1

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
				float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, iChannel1);
				o.screenPos = ComputeScreenPos(o.vertex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				//float2 q = i.uv; //fragCoord.xy / iResolution.xy;
				// uv -> screenpos
				float2 q = (i.screenPos.xy / i.screenPos.w);

				#if TEXTURED == 1

				float3 e = float3(float2(1., 1.) / _ScreenParams.xy,0.);
				float p10 = tex2D(_bufferA, q - e.zy).x;
				float p01 = tex2D(_bufferA, q - e.xz).x;
				float p21 = tex2D(_bufferA, q + e.xz).x;
				float p12 = tex2D(_bufferA, q + e.zy).x;

				// Totally fake displacement and shading:
				float3 grad = normalize(float3(p21 - p01, p12 - p10, 1.));
				//float4 c = tex2D(iChannel1, fragCoord.xy*2. / iChannelResolution[1].xy + grad.xy*.35);
				//float4 c = tex2D(iChannel1, ((i.uv.xy *_ScreenParams.xy)*1.) / (_ScreenParams.xy + grad.xy*.35));
				// flexible aspect ratio thing
				float4 c = tex2D(iChannel1, ((q *_ScreenParams.xy)*1.) / (_ScreenParams.xy + grad.xy*.35));
				// multiply color, before adding ripples.
				c *= 1.7;
				//float3 light = normalize(float3(.2,-.5,.7));
				float3 light = normalize(float3(1., 1., 1.));
				float diffuse = dot(grad,light);
				float spec = pow(max(0.,-reflect(light,grad).z),32.) * _specular;
				// original method
				//return lerp(c, float4(.7, .8, 1., 1.), .25)*max(diffuse, 0.) +spec;
				return c * max(diffuse, 0.0) + spec;

				#else
				//return fixed4(0, 0, 0, 0);
				float h = tex2D(_bufferA, q).x;
				float sh = 1.35 - h * 2.;
				float3 c =
					float3(exp(pow(sh - .75, 2.)*-10.),
						exp(pow(sh - .50, 2.)*-20.),
						exp(pow(sh - .25, 2.)*-10.));
				return float4(c, 1.);

				#endif
			}
			ENDCG
		}
	}
}
