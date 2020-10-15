Shader "MSK/Filter/FilterHue" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_Hue("Hue", range(0, 360)) = 0.0
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	
	fixed _Hue;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		return o;
	}

	fixed3 getHue(fixed3 rgb) {
		fixed angle = radians(_Hue);
		fixed3 k = fixed3(0.57735, 0.57735, 0.57735);
		fixed cosAngle = cos(angle);

		return rgb*cosAngle + cross(k, rgb)*sin(angle) + k*dot(k, rgb)*(1 - cosAngle);
	}

	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		c.rgb = getHue(c.rgb);
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