varying vec2 v_uv;

uniform vec2 u_resolution;
uniform float u_time;
uniform sampler2D u_texturemap;
uniform vec4 u_tint;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

vec3 saturate(vec3 x) {
    return clamp(x, vec3(0.0), vec3(1.0));
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

// basic color manipulation
void main() {
    vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
    v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
    vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

    if (v_uv.x > 0.5) {
        // tinting
        color *= (u_tint.xyz);
        // brightness
        color += 0.25;
        // saturation
        float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
        float sat = 0.0;
        color = mix(vec3(luminance), color, sat);
        // contrast
        float contrast = 1.0;
        float midpoint = 0.5;
        color = saturate((color - midpoint) * contrast + midpoint);
        // color grading
        color = pow(color, vec3(1.5, 0.8, 1.5));
    }   
    gl_FragColor = vec4(color, 1.0);
}

// color boosting
// void main() {
//     vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
//     v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
//     vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

//     if (v_uv.x > 0.5) {
//         float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
//         // contrast
//         float contrast = 1.0;
//         float midpoint = 0.5;
//         color = saturate((color - midpoint) * contrast + midpoint);
//         // color boost
//         vec3 ref = vec3(0.3, 0.5, 0.9);
//         float weight = dot(normalize(color), normalize(ref));
//         weight = pow(weight, 32.0);
//         color = mix(vec3(luminance), color,  weight);
//     }   

//     gl_FragColor = vec4(color, 1.0);
// }

// vignette
// void main() {
//     vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
//     v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
//     vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

//     if (v_uv.x > 0.5) {
//         float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
//         // contrast
//         float contrast = 1.0;
//         float midpoint = 0.5;
//         color = saturate((color - midpoint) * contrast + midpoint);
//         // color boost
//         vec3 ref = vec3(0.3, 0.5, 0.9);
//         float weight = dot(normalize(color), normalize(ref));
//         weight = pow(weight, 32.0);
//         //olor = mix(vec3(luminance), color,  weight);

//         // vignette
//         vec2 v_coords = fract((v_uv * vec2(2.0, 1.0)));
//         float v1 = smoothstep(0.5, 0.2, abs(v_coords.x - 0.5));
//         float v2 = smoothstep(0.5, 0.2, abs(v_coords.y - 0.5));
//         float vignette = v1 * v2;
//         vignette = pow(vignette, 0.25);
//         vignette = remap(vignette, 0.0, 1.0, 0.5, 1.0);
//         color *= vignette;
//     }   

//     gl_FragColor = vec4(color, 1.0);
// }

// pixelation
// void main() {
//     vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
//     v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
//     vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

//     if (v_uv.x > 0.5) {
//         float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
//         // contrast
//         float contrast = 1.0;
//         float midpoint = 0.5;
//         color = saturate((color - midpoint) * contrast + midpoint);
//         // color boost
//         vec3 ref = vec3(0.3, 0.5, 0.9);
//         float weight = dot(normalize(color), normalize(ref));
//         weight = pow(weight, 32.0);
//         color = mix(vec3(luminance), color,  weight);
//         // pixelation
//         vec2 dims = vec2(64.0);
//         vec2 tex_uv = floor(v_uv2x * dims) / dims;
//         vec3 pixelation = texture2D(u_texturemap, tex_uv).xyz;
//         color = pixelation;
//     }   

//     gl_FragColor = vec4(color, 1.0);
// }

// distortions
// void main() {
//     vec2 v_uv2x = fract(v_uv * vec2(2.0, 1.0));
//     v_uv2x.x = remap(v_uv2x.x, 0.0, 1.0, 0.25, 0.75);
//     vec3 color = texture2D(u_texturemap, v_uv2x).xyz;

//     if (v_uv.x > 0.5) {
//         // ripples 
//         float dist = length(v_uv2x - 0.5);
//         float d = sin(dist * 50.0 - u_time * 2.0);
//         vec2 dir = normalize(v_uv2x - 0.5);
//         vec2 ripple = v_uv2x + d * dir * 0.1;
//         color = texture2D(u_texturemap, ripple).xyz;
//     }   

//     gl_FragColor = vec4(color, 1.0);
// }
