Shader "MSK/ChromaKey/BlendOff/ChromaKey_Alpha_General" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_KeyColor("KeyColor", Color) = (1,1,1,1)
		_DChroma("D Chroma", range(0.0, 1.0)) = 0.5
		_DChromaT("D ChromaT", range(0.0, 1.0)) = 0.05
		_DLuma("D Luma", range(0.0, 1.0)) = 0.5
		_DLumaT("D LumaT", range(0.0, 1.0)) = 0.05
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	
	fixed4 _KeyColor;
	fixed _DChroma;
	fixed _DLuma;
	
	fixed _DLumaT;
	fixed _DChromaT;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		return o;
	}

	fixed3 RGB_To_YCbCr(fixed3 rgb) {
		fixed Y = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
		fixed Cb = 0.564 * (rgb.b - Y);
		fixed Cr = 0.713 * (rgb.r - Y);
		return fixed3(Cb, Cr, Y);
	}

	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		
		if (c.a > 0) {
			fixed3 src_YCbCr = RGB_To_YCbCr(c.rgb);
			fixed3 key_YCbCr = RGB_To_YCbCr(_KeyColor);

			fixed dChroma = distance(src_YCbCr.xy, key_YCbCr.xy);
			fixed dLuma = distance(src_YCbCr.z, key_YCbCr.z);

			if (dLuma < _DLuma && dChroma < _DChroma) {
				fixed a = 0;
				if (dChroma > _DChroma - _DChromaT) {
					a = (dChroma -_DChroma + _DChromaT) / _DChromaT;
				}
				if (dLuma > _DLuma - _DLumaT) {
					a = max(a, (dLuma - _DLuma + _DLumaT) / _DLumaT);
				}
				if(c.a > a) {
					c.a = a;
				}
			}
		}
		return c;
	}
	ENDCG
	
	SubShader {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		Lighting Off
		ZWrite Off
		AlphaTest Off
		Blend Off

		Pass {
			CGPROGRAM
			  #pragma vertex vert
			  #pragma fragment frag
			ENDCG
		}
	}
	Fallback Off
}