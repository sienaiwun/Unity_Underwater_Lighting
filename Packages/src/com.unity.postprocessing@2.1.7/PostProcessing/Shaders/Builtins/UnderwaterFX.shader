Shader "Hidden/PostProcessing/UnderwaterFX"
{
	HLSLINCLUDE

#include "../StdLib.hlsl"
#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/LightInput.hlsl"
#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Caustic.hlsl"
	half4 _HolyLightColor;
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	

	float4 Frag(VaryingsDefault i) : SV_Target
	{
	
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float2 tc = i.texcoord * 2 - 1.0;
		tc.y * _ScreenParams.x / _ScreenParams.y;
		float3 skyColor = float3(0.3f, 1.0f, 1.0f);
		float go = GodRays(tc);
		float3 temp = lerp(skyColor, 1.0, tc.y*tc.y)*_HolyLightColor.xyz;
		color.xyz += go * temp;
		return color;
	}


	

		ENDHLSL

		SubShader
	{
		Cull Off ZWrite Off ZTest Always

			// 0 - Fullscreen triangle copy
			Pass
		{
			HLSLPROGRAM

				#pragma vertex VertDefault
				#pragma fragment Frag

			ENDHLSL
		}

			
	}
}
