#ifndef LIGHTWEIGHT_LIGHTINPUT_INCLUDED
#define LIGHTWEIGHT_LIGHTINPUT_INCLUDED

#define MAX_VISIBLE_LIGHTS 16

CBUFFER_START(_LightBuffer)
float4 _MainLightPosition;
half4 _MainLightColor;
float4x4 _MainLightWorldToLight;
float _MainLightCookieSize;
float _MainLightSlope;// for god rays
half4 _MainLightCookieColor;
half4 _AdditionalLightsCount;
float4 _AdditionalLightsPosition[MAX_VISIBLE_LIGHTS];
half4 _AdditionalLightsColor[MAX_VISIBLE_LIGHTS];
half4 _AdditionalLightsAttenuation[MAX_VISIBLE_LIGHTS];
half4 _AdditionalLightsSpotDir[MAX_VISIBLE_LIGHTS];
CBUFFER_END


CBUFFER_START(_PerCamera)
float4x4 _InvCameraViewProj;
float4 _ScaledScreenParams;
CBUFFER_END

#endif
