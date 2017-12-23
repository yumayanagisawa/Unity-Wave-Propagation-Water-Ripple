Shader "Custom/Wave" {
	Properties {
		iChannel1("Albedo (RGB)", 2D) = "white" {}
		iMouse("mouse", Vector) = (0, 0, 0, 0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Pass{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _bufferB;
			sampler2D _bufferA;
			float3 iMouse;

			fixed4 frag(v2f_img i) : SV_Target{
				float3 e = float3(float2(1., 1.) / _ScreenParams.xy, 0.);
				float2 q = i.uv;

				float4 c = tex2D(_bufferA, q);

				float p11 = c.x;

				float p10 = tex2D(_bufferB, q - e.zy).x;
				float p01 = tex2D(_bufferB, q - e.xz).x;
				float p21 = tex2D(_bufferB, q + e.xz).x;
				float p12 = tex2D(_bufferB, q + e.zy).x;

				float d = 0.;
				
				if (iMouse.z > 0.)
				{
					// Mouse interaction:
					d = smoothstep(4.5, .5, length(iMouse.xy - (i.uv.xy *_ScreenParams.xy)));
				}
				else
				{
					// Simulate rain drops
					float t = _Time.y*2.;
					float2 pos = frac(floor(t)*float2(0.456665, 0.708618))*_ScreenParams.xy;
					float amp = 1. - step(.05, frac(t));
					d = -amp*smoothstep(2.5, .5, length(pos - (i.uv.xy *_ScreenParams.xy)));
				}

				// The actual propagation:
				d += -(p11 - .5)*2. + (p10 + p01 + p21 + p12 - 2.);
				d *= .99; // dampening
				// for now comment
				//d *= min(1., float(iFrame)); // clear the buffer at iFrame == 0
				d = d*.5 + .5;

				return fixed4(d, 0, 0, 0);
			}
		ENDCG
		}
		GrabPass{ "_bufferA" }
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"
			
			sampler2D _bufferB;
			sampler2D _bufferA;
			float3 iMouse;

			fixed4 frag(v2f_img i) : SV_Target{
				float3 e = float3(float2(1., 1.) / _ScreenParams.xy,0.);
				float2 q = i.uv;

				float4 c = tex2D(_bufferB, q);

				float p11 = c.x;

				float p10 = tex2D(_bufferA, q - e.zy).x;
				float p01 = tex2D(_bufferA, q - e.xz).x;
				float p21 = tex2D(_bufferA, q + e.xz).x;
				float p12 = tex2D(_bufferA, q + e.zy).x;

				float d = 0.;

				
				if (iMouse.z > 0.)
				{
					// Mouse interaction:
					d = smoothstep(4.5,.5,length(iMouse.xy - (i.uv.xy *_ScreenParams.xy)));
				}
				else
				{
					// Simulate rain drops
					float t = _Time.y*2.;
					float2 pos = frac(floor(t)*float2(0.456665,0.708618))*_ScreenParams.xy;
					float amp = 1. - step(.05,frac(t));
					d = -amp*smoothstep(2.5,.5,length(pos - (i.uv.xy *_ScreenParams.xy)));
				}

				// The actual propagation:
				d += -(p11 - .5)*2. + (p10 + p01 + p21 + p12 - 2.);
				d *= .99; // dampening
				//d *= min(1.,float(iFrame)); // clear the buffer at iFrame == 0
				d = d*.5 + .5;

				return fixed4(d, 0, 0, 0);
			}
		ENDCG
		}
		GrabPass{ "_bufferB" }
		Pass{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _bufferA;
			sampler2D iChannel1;

			#define TEXTURED 1

			fixed4 frag(v2f_img i) : SV_Target{
				float2 q = i.uv;

				#if TEXTURED == 1

				float3 e = float3(float2(1., 1.) / _ScreenParams.xy,0.);
				float p10 = tex2D(_bufferA, q - e.zy).x;
				float p01 = tex2D(_bufferA, q - e.xz).x;
				float p21 = tex2D(_bufferA, q + e.xz).x;
				float p12 = tex2D(_bufferA, q + e.zy).x;

				// Totally fake displacement and shading:
				float3 grad = normalize(float3(p21 - p01, p12 - p10, 1.));
				//float4 c = tex2D(iChannel1, (i.uv.xy *_ScreenParams.xy)*2. / iChannelResolution[1].xy + grad.xy*.35);
				// changed how to get "c" as in the sentence above. the displacement effect would look more organic, supposedly
				float4 c = tex2D(iChannel1, (i.uv.xy *_ScreenParams.xy)*1. / _ScreenParams.xy + grad.xy*.1);
				float3 light = normalize(float3(.2,-.5,.7));
				float diffuse = dot(grad,light);
				float spec = pow(max(0.,-reflect(light,grad).z),32.);
				//fragColor = mix(c,float4(.7,.8,1.,1.),.25)*max(diffuse,0.) + spec;
				return lerp(c, float4(.7, .8, 1., 1.), .25)*max(diffuse, 0.) + spec;

				#else

				float h = tex2D(_bufferA, q).x;
				float sh = 1.35 - h*2.;
				float3 c =
					float3(exp(pow(sh - .75,2.)*-10.),
						exp(pow(sh - .50,2.)*-20.),
						exp(pow(sh - .25,2.)*-10.));
				return fixed4(c,1.);

				#endif
				//return fixed4(1, 1, 1, 1);
			}
		ENDCG
		}
	}
	FallBack "Diffuse"
}
