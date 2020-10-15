Shader "MSK/Blur/BlendOff/Blur_101-010-101" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_BlurOffsetX ("_BlurOffsetX", float) = 3
		_BlurOffsetY("_BlurOffsetY", float) = 3
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD4;
		fixed2 texcoords[4]:TEXCOORD0;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	fixed4 _MainTex_TexelSize;
	fixed _BlurOffsetX;
	fixed _BlurOffsetY;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		fixed2 offsetX = _MainTex_TexelSize * fixed2(0.5*_BlurOffsetX, 0);
		fixed2 offsetY = _MainTex_TexelSize * fixed2(0, 0.5*_BlurOffsetY);
		fixed2 texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		o.texcoord0 = texcoord0;
		o.texcoords[0] = texcoord0 + offsetX + offsetY;
		o.texcoords[1] = texcoord0 + offsetX - offsetY;
		o.texcoords[2] = texcoord0 - offsetX + offsetY;
		o.texcoords[3] = texcoord0 - offsetX - offsetY;
		return o;
	}
	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		c += tex2D(_MainTex, input.texcoords[0]);
		c += tex2D(_MainTex, input.texcoords[1]);
		c += tex2D(_MainTex, input.texcoords[2]);
		c += tex2D(_MainTex, input.texcoords[3]);
		return 0.2 * c;
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