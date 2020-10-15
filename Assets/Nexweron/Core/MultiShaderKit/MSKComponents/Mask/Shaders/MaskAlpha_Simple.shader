Shader "MSK/Mask/MaskAlpha_Simple" {
	Properties{
		_MainTex("MainTex", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
	}
	CGINCLUDE
	#include "UnityCG.cginc"
	struct VS_OUT {
		half4 position:POSITION;
		fixed2 texcoord0:TEXCOORD0;
		fixed2 texcoord1:TEXCOORD1;
	};

	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	sampler2D _MaskTex;
	fixed4 _MaskTex_ST;

	VS_OUT vert(appdata_base input) {
		VS_OUT o;
		o.position = UnityObjectToClipPos(input.vertex);
		o.texcoord0 = TRANSFORM_TEX(input.texcoord, _MainTex);
		o.texcoord1 = TRANSFORM_TEX(input.texcoord, _MaskTex);
		return o;
	}
	fixed4 frag(VS_OUT input) : SV_Target {
		fixed4 c = tex2D(_MainTex, input.texcoord0);
		fixed4 cm = tex2D(_MaskTex, input.texcoord1);
		c.a = cm.a;
		return c;
	}
	ENDCG
	
	SubShader {
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		ZWrite Off
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