Shader "MSK/Filter/FilterHSBC" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_TintColor("TintColor", Color) = (1,1,1,0)
		_Hue("Hue", range(0, 360)) = 0.0
		_Saturation("Saturation", range(-1, 2.0)) = 0.0
		_Brightness("Brightness", range(-1.0, 10.0)) = 0.0
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
	
	fixed4 _BaseColor;
	fixed4 _TintColor;
	fixed _Hue;
	fixed _Saturation;
	fixed _Brightness;
	fixed _Contrast;

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
	fixed3 getContrast(fixed3 rgb) {
		rgb = ((rgb - 0.5f) * _Contrast) + 0.5f;
		return rgb;
	}
	fixed3 getSaturation(fixed3 rgb) {
		fixed3 intensity = dot(rgb, fixed3(0.299, 0.587, 0.114)); /*fixed3(0.3, 0.59, 0.91));*/
		rgb = lerp(intensity, rgb, _Saturation + 1.0);
		return rgb;
	}
	fixed3 getHue(fixed3 rgb) {
		fixed angle = radians(_Hue);
		fixed3 k = fixed3(0.57735, 0.57735, 0.57735);
		fixed cosAngle = cos(angle);

		return rgb*cosAngle + cross(k, rgb)*sin(angle) + k*dot(k, rgb)*(1 - cosAngle);
	}

	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0)*_BaseColor;
		c.rgb = lerp(c.rgb, _TintColor.rgb, _TintColor.a);
		c.rgb = getHue(c.rgb);
		c.rgb = getContrast(c.rgb);
		c.rgb = getBrightness(c.rgb);
		c.rgb = getSaturation(c.rgb);
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