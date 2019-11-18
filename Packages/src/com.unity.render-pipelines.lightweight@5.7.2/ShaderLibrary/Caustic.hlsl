#ifndef LIGHTWEIGHT_CAUSTIC_INCLUDED
#define LIGHTWEIGHT_CAUSTIC_INCLUDED

#define TAU 6.28318530718
#define MAX_ITER 5


    float3 caustic(float2 uv)
    {
        float2 p = fmod(uv*TAU, TAU)-250.0;
        
        float time = _Time.y * .5+23.0;

        float2 i = float2(p);
        float c = 1.0;
        float inten = .005;

        for (int n = 0; n < MAX_ITER; n++) 
        {
            float t = time * (1.0 - (3.5 / float(n+1)));
            i = p + float2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
            c += 1.0/length(float2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
        }
        
        c /= float(MAX_ITER);
        c = 1.17-pow(c, 1.4);
		float num = pow(abs(c), 8.0f);
        float3 color = float3(num, num, num);
        color = clamp(color + float3(0.0, 0.35, 0.5), 0.0, 1.0);
        color = lerp(color, float3(1.0,1.0,1.0),0.3);
        
        return color;
    }

	// perf increase for god ray, eliminates Y
	float causticX(float x, float power, float gtime)
	{
		float p = fmod(x*TAU, TAU) - 250.0;
		float time = gtime * .5 + 23.0;

		float i = p;;
		float c = 1.0;
		float inten = .005;

		for (int n = 0; n < MAX_ITER / 2; n++)
		{
			float t = time * (1.0 - (3.5 / float(n + 1)));
			i = p + cos(t - i) + sin(t + i);
			c += 1.0 / length(p / (sin(i + t) / inten));
		}
		c /= float(MAX_ITER);
		c = 1.17 - pow(c, abs(power)+0.001f);
		c = max(c, 0.001f);
		// must postive
		return c;
	}

	float GodRays(float2 uv)
	{
		float light = 0.0;
		float time = _Time.y;
		light += pow(causticX((uv.x +(-1.0/ _MainLightSlope) *uv.y) / 1.7 + 0.5, 1.8, time*0.65), 10.0)*0.05;
		light -= pow((1.0 - uv.y)*0.3, 2.0)*0.2;
		light += pow(causticX(sin(uv.x), 0.3, time*0.7), 9.0)*0.4;
		light += pow(causticX(cos(uv.x*2.3), 0.3, time*1.3), 4.0)*0.1;

		light -= pow((1.0 - uv.y)*0.3, 3.0);
		light = clamp(light, 0.0, 1.0);

		return light;
	}


#endif
