using System;

namespace UnityEngine.Rendering.PostProcessing
{

    static class LightConstantBuffer
    {
        public static int _MainLightCookieColor;
        public static int _MainLightCookieSize;
    }

    static class UnderwaterFxParams
    {
        public static int _HolylightColor;
    }
        /// <summary>
        /// This class holds settings for the Vignette effect.
        /// </summary>
        [Serializable]
    [PostProcess(typeof(UnderwaterRenderer), PostProcessEvent.BeforeStack, "Custom/UnderwaterEffects")]
    public sealed class UnderwaterSettings : PostProcessEffectSettings
    {
        public UnderwaterSettings()
        {
            LightConstantBuffer._MainLightCookieSize = Shader.PropertyToID("_MainLightCookieSize");
            LightConstantBuffer._MainLightCookieColor = Shader.PropertyToID("_MainLightCookieColor");
            UnderwaterFxParams._HolylightColor = Shader.PropertyToID("_HolyLightColor");
        }
                    
        /// <summary>
        /// The color to use to tint the GodRay.
        /// </summary>
        [Tooltip("½¹É¢ÑÕÉ«")]
        public ColorParameter CausticColor = new ColorParameter { value = Color.green };


        [Tooltip("½¹É¢Æ½ÆÌ")]
        public FloatParameter CausticTiling = new FloatParameter { value = 3.0f };

        [Tooltip("HolyLightÑÕÉ«")]
        public ColorParameter HolylightColor = new ColorParameter { value = Color.white };


        /// <inheritdoc />
        public override bool IsEnabledAndSupported(PostProcessRenderContext context)
        {
            return enabled.value
            && SystemInfo.graphicsShaderLevel >= 35;
        }
    }

#if UNITY_2017_1_OR_NEWER
    [UnityEngine.Scripting.Preserve]
#endif
    internal sealed class UnderwaterRenderer : PostProcessEffectRenderer<UnderwaterSettings>
    {

        static readonly string EffectName = "Underwater Effects";
        static readonly string shaderName = "Hidden/PostProcessing/UnderwaterFX";

        public override void Render(PostProcessRenderContext context)
        {
            var cmd = context.command;
            cmd.BeginSample(EffectName);
            cmd.SetGlobalColor(LightConstantBuffer._MainLightCookieColor, settings.CausticColor);
            cmd.SetGlobalFloat(LightConstantBuffer._MainLightCookieSize, settings.CausticTiling);
            var shader = Shader.Find(shaderName);
            if (shader == null)
            {
                throw new System.ArgumentException(string.Format("Invalid shader ({0})", shaderName));
            }
            var sheet = context.propertySheets.Get(shader);
            sheet.properties.Clear();
            sheet.properties.SetColor(UnderwaterFxParams._HolylightColor, settings.HolylightColor);
            cmd.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
            cmd.EndSample(EffectName);


        }
    }
}
