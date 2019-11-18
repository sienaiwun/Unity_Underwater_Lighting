#ifndef LIGHTWEIGHT_FORWARD_LIT_PASS_INCLUDED
#define LIGHTWEIGHT_FORWARD_LIT_PASS_INCLUDED

#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Caustic.hlsl"
struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float4 tangentOS    : TANGENT;
    float2 texcoord     : TEXCOORD0;
    float2 lightmapUV   : TEXCOORD1;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct Varyings
{
    float4 screen_uv                       : TEXCOORD0;
    half3 positionWS                 : TEXCOORD1;

  

    float4 positionCS               : SV_POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};


///////////////////////////////////////////////////////////////////////////////
//                  Vertex and Fragment functions                            //
///////////////////////////////////////////////////////////////////////////////
inline float4 ComputeNonStereoScreenPos(float4 pos) {
	float4 o = pos * 0.5f;
	o.xy = float2(o.x, o.y*_ProjectionParams.x) + o.w;
	o.zw = pos.zw;
	return o;
}
// Used in Standard (Physically Based) shader
Varyings LitPassVertex(Attributes input)
{
    Varyings output = (Varyings)0;

    UNITY_SETUP_INSTANCE_ID(input);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);
    VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
    half3 viewDirWS = GetCameraPositionWS() - vertexInput.positionWS;
   
    output.positionWS = vertexInput.positionWS;
	
    
  

    output.positionCS = vertexInput.positionCS;
	output.screen_uv = ComputeNonStereoScreenPos(vertexInput.positionCS);

    return output;
}

// Used in Standard (Physically Based) shader
half4 LitPassFragment(Varyings input) : SV_Target
{
    half4 color;
    float4 cs = input.screen_uv;
	float2 ss_pos = cs.xy / cs.w;
	float2 p = ss_pos * 2 - 1.0;
	half3 viewDirWS = GetCameraPositionWS() - input.positionWS;

    float3 viewDir = -normalize(viewDirWS.xyz).xyz;


	float sky = clamp(0.8 * (1.0 - 0.8 * viewDir.y), 0.0, 1.0);
	float3  skyColor = float3(0.3, 1.0, 1.0);
	float3 horizonColor = unity_FogColor.xyz;
	color.xyz = sky * skyColor;
	color.xyz += ((0.3*caustic(float2(p.x, p.y*1.0))) + (0.3*caustic(float2(p.x, p.y*2.7))))*pow(p.y, 4.0);
	color.xyz = lerp(color, horizonColor, pow(1.0 - pow(viewDir.y, 4.0), 20.0));
    return color;
}

#endif
