#define PI 3.145926535
#define NUM_CLOUDS 8.0
#define NUM_STARS 8.0
#define DAY_LENGTH 24.0

varying vec2 v_uv;
 
uniform float u_time;
uniform vec2 u_resolution;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
} 

float opUnion(float d1, float d2) {
  return min(d1, d2);
}

float opSubtraction(float d1, float d2) {
  return max(-d1, d2);
}

float opIntersection(float d1, float d2) {
  return max(d1, d2);
}

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

mat2 rotate2d(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(
        c, -s, 
        s, c
    );
}

vec3 draw_bg(float t) {
    vec3 morning = mix(
        vec3(0.4, 0.6, 0.8),
        vec3(0.3, 0.5, 0.9),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 midday = mix(
        vec3(0.4, 0.5, 0.7),
        vec3(0.3, 0.4, 0.8),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 evening = mix(
        vec3(0.8, 0.5, 0.2),
        vec3(0.8, 0.7, 0.3),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 night = mix(
        vec3(0.1, 0.1, 0.1),
        vec3(0.1, 0.2, 0.3),
        smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    );

    vec3 color = vec3(0.0);
    if (t < DAY_LENGTH * 0.25) {
        color = mix(morning, midday, smoothstep(0.0, DAY_LENGTH * 0.25, t));
    } else if (t < DAY_LENGTH * 0.5) {
        color = mix(midday, evening, smoothstep(DAY_LENGTH * 0.25, DAY_LENGTH * 0.5, t));
    } else if (t < DAY_LENGTH * 0.75) {
        color = mix(evening, night, smoothstep(DAY_LENGTH * 0.5, DAY_LENGTH * 0.75, t));
    } else {
        color = mix(night, morning, smoothstep(DAY_LENGTH * 0.75, DAY_LENGTH, t));
    }

    return color;
}

float sdCloud(vec2 pixel_coords) {
    float puff1 = sdCircle(pixel_coords, 100.0);
    float puff2 = sdCircle(pixel_coords - vec2(120.0, -10.0), 75.0);
    float puff3 = sdCircle(pixel_coords + vec2(120.0, 10.0), 75.0);
    return min(puff1, min(puff2, puff3));
}

float sdMoon(vec2 pixel_coords) {
    float d = opSubtraction(sdCircle(pixel_coords + vec2(50.0, 0.0), 100.0), sdCircle(pixel_coords, 100.0));
    return d;
}

float hashish(vec2 v) {
    float t = dot(v, vec2(42.069, 69.420));
    return sin(t);
}

float saturate(float t) {
    return clamp(t, 0.0, 1.0);
}

float easeOut(float x, float p) {
    return 1.0 - pow(1.0 - x, p);
}

// simple cloud scene
// void main() {
//     vec2 pixel_coords = (v_uv) * u_resolution;
//     vec3 color = mix(
    //     vec3(0.4, 0.5, 0.75),
    //     vec3(0.3, 0.4, 0.8),
    //     smoothstep(0.0, 1.0, pow(v_uv.x * v_uv.y, 0.5))
    // );

//     for (float i = 0.0; i < NUM_CLOUDS; i += 1.0) {
//         float size = mix(2.0, 1.0, (i / NUM_CLOUDS) + 0.1 * hashish(vec2(i)));
//         float speed = size * 0.25;
//         vec2 offset = vec2(i * 200.0 + u_time * 20.0 * speed, 222.333 * hashish(vec2(i)));
//         vec2 pos = pixel_coords - offset;
//         pos = mod(pos, u_resolution);
//         pos = pos - u_resolution * 0.5;
//         float cloud = sdCloud(pos * size);
//         float shadow = sdCloud(pos * size + vec2(50.0)) - 20.0;
//         color = mix(color, vec3(0.0), 0.5 * smoothstep(0.0, -100.0, shadow));
//         color = mix(vec3(1.0), color, smoothstep(0.0, 1.0, cloud));
//     }

//     gl_FragColor = vec4(color, 1.0);
// }

// sun && moon cycle
void main() {
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    float time = mod(u_time + 8.0, DAY_LENGTH);
    vec3 color = draw_bg(time);

    if (time < DAY_LENGTH * 0.75) {
        float t = saturate(inverseLerp(time, 0.0, 1.0));
        vec2 offset = vec2(200.0, u_resolution.y * 0.8) + mix(vec2(0.0, 400.0), vec2(0.0), easeOut(t, 5.0));

        if (time > DAY_LENGTH * 0.6) {
            t = saturate(inverseLerp(time, DAY_LENGTH * 0.6, DAY_LENGTH * 0.6 + 1.0));
            offset = vec2(200.0, u_resolution.y * 0.8) + mix(vec2(0.0), vec2(0.0, 400.0), t);
        }
        
        vec2 pos = pixel_coords - offset;
        float sun = sdCircle(pos, 100.0);
        color = mix(vec3(0.8, 0.6, 0.2), color, smoothstep(0.0, 2.0, sun));
        float s = max(0.001, sun);
        float p = saturate(exp(-0.001 * s * s));
        color += 0.5 * mix(vec3(0.0), vec3(0.9, 0.8, 0.5), p);
    }

    if (time > DAY_LENGTH * 0.5) {
        float t = saturate(inverseLerp(time, DAY_LENGTH * 0.5, DAY_LENGTH * 0.5 + 1.5));
        vec2 offset = u_resolution * 0.8 + mix(vec2(0.0, 400.0), vec2(0.0), easeOut(t, 5.0));

        if (time > DAY_LENGTH * 0.9) {
            t = saturate(inverseLerp(time, DAY_LENGTH * 0.9, DAY_LENGTH * 0.95));
            offset = u_resolution * 0.8 + mix(vec2(0.0), vec2(0.0, 400.0), t);
        }

        vec2 moonShadowPos = pixel_coords - offset + vec2(15.0);
        moonShadowPos = rotate2d(PI * -0.2) * moonShadowPos;
        float moonShadow = sdMoon(moonShadowPos);
        color = mix(vec3(0.0), color, smoothstep(-40.0, 10.0, moonShadow));
        vec2 pos = pixel_coords - offset;
        pos = rotate2d(PI * -0.2) * pos;
        float moon = sdMoon(pos);
        color = mix(vec3(1.0), color, smoothstep(0.0, 2.0, moon));
        float glow = sdMoon(pos);
        color += 0.1 * mix(vec3(1.0), vec3(0.0), smoothstep(-10.0, 15.0, glow));
    }

    for (float i = 0.0; i < NUM_CLOUDS; i += 1.0) {
        float size = mix(2.0, 1.0, (i / NUM_CLOUDS) + 0.1 * hashish(vec2(i)));
        float speed = size * 0.25;
        vec2 offset = vec2(i * 200.0 + u_time * 20.0 * speed, 222.333 * hashish(vec2(i)));
        vec2 pos = pixel_coords - offset;
        pos = mod(pos, u_resolution);
        pos = pos - u_resolution * 0.5;
        float cloud = sdCloud(pos * size);
        float shadow = sdCloud(pos * size + vec2(50.0)) - 20.0;
        color = mix(color, vec3(0.0), 0.5 * smoothstep(0.0, -100.0, shadow));
        color = mix(vec3(1.0), color, smoothstep(0.0, 1.0, cloud));
    }

    gl_FragColor = vec4(color, 1.0);
}