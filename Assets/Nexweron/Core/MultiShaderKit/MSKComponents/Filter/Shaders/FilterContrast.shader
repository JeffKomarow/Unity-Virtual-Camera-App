Shader "MSK/Filter/FilterContrast" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_Contrast("Contrast", range(0.0, 10.0)) = 1.0
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	
	fixed _Contrast;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		return o;
	}
	fixed3 getContrast(fixed3 rgb) {
		rgb = ((rgb - 0.5f) * _Contrast) + 0.5f;
		return rgb;
	}
	
	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		c.rgb = getContrast(c.rgb);
		return c;
	}
	ENDCG
	
	SubShader {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		Lighting Off
		ZWrite Off
		AlphaTest Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass {
			CGPROGRAM
			  #pragma vertex vert
			  #pragma fragment frag
			ENDCG
		}
	}
	Fallback Off
}