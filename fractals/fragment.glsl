#define PI 3.1415926535

varying vec2 v_uv;

uniform float u_time;
uniform vec2 u_resolution;

vec3 palette(float t) {
        vec3 a = vec3(0.5, 0.5, 0.5);
        vec3 b = vec3(0.75, 0.75, 0.75);
        vec3 c = vec3(1.0, 1.0, 1.0);
        vec3 d = vec3(0.0, 0.333, 0.667);

        return a + b * cos((PI * 2.0) * (c * t + d));
}

// void main() {
//     // control the speed of the animation
//     float angle = u_time / 13.0;
//     //  center our uvs
//     vec2 uv = v_uv * 2.0 - 1.0;
//     // make it responsive to the current screen size
//     uv.x *= u_resolution.x / u_resolution.y;
//     // start the fractal process
//     for (float i = 0.0; i < 64.0; i += 1.0) {
//         uv = abs(uv);
//         uv -= 0.5;
//         uv *= 1.1;
//         uv *= mat2(
//             cos(angle), -sin(angle),
//             sin(angle), cos(angle)
//         );    
//     }
//     vec3 color = 1.0 - palette(length(uv) + u_time);
//     // render the final color
//     gl_FragColor = vec4(vec3(color / PI * length(uv)), 1.0);
// }

void main() {
    vec2 uv = v_uv * 2.0 - 1.0;
    uv.x *= u_resolution.x / u_resolution.y;
    vec2 l_uv = uv;
    vec3 final = vec3(0.0);

    for (float i = 0.0; i < 3.0; i += 1.0) {
        uv = fract(uv * 2.0) - 0.5;

        float l = length(uv) * exp(-length(l_uv));
        vec3 color = palette(length(l_uv) + (i * PI) + u_time);

        l = sin(l * 8.0 - (u_time * 1.28)) / 8.0;
        l = abs(l);

        l = mod(0.01 / l, 1.5);

        final += color * l;
    }

    gl_FragColor = vec4(final, 1.0);
}