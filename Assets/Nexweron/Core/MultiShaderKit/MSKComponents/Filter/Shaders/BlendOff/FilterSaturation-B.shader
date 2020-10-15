Shader "MSK/Filter/BlendOff/FilterSaturation" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_Saturation("Saturation", range(-1, 2.0)) = 0.0
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	
	fixed _Saturation;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		return o;
	}
	
	fixed3 getSaturation(fixed3 rgb) {
		fixed3 intensity = dot(rgb, fixed3(0.299, 0.587, 0.114)); /*fixed3(0.3, 0.59, 0.91));*/
		rgb = lerp(intensity, rgb, _Saturation + 1.0);
		return rgb;
	}

	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		c.rgb = getSaturation(c.rgb);
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