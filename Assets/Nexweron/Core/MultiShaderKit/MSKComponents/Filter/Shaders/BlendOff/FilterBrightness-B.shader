Shader "MSK/Filter/BlendOff/FilterBrightness" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_Brightness("Brightness", range(-1.0, 10.0)) = 0.0
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		float4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	
	fixed _Brightness;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		return o;
	}

	fixed3 getBrightness(fixed3 rgb) {
		rgb *= _Brightness + 1.0;
		return rgb;
	}
	
	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		c.rgb = getBrightness(c.rgb);
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