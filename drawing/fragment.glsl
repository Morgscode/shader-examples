#define PI 3.1415926535

uniform float u_time;
uniform vec2 u_resolution;

varying vec2 v_uv;

float plot(vec2 st, float pct) {
     return smoothstep( pct - 0.02, pct, st.y) -
          smoothstep( pct, pct + 0.02, st.y);
}

// draw a striaght line
void main() {
    vec3 color = vec3(v_uv.x);

    float line = smoothstep(0.02, 0.0, abs(v_uv.x - v_uv.y));
    color = (1.0 - line) * color + line * vec3(0.0, 1.0, 0.0);

    gl_FragColor = vec4(color, 1.0);
}

// draw a curved line
// void main() {
//     vec2 uv = v_uv * 2.0 - 1.0;
//     float y = pow(v_uv.x, PI);

//     vec3 color = vec3(y);

//     float pct = plot(v_uv, y);
//     color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

//     gl_FragColor = vec4(color, 1.0);
// }

// draw a straight vertical line
// void main() {
//     vec3 color = vec3(0.0);
//     float line = smoothstep(0.0001, 0.005, abs(v_uv.x - 0.5));
//     color = vec3(line);

//     color = mix(vec3(0.0), color, line);
//     gl_FragColor = vec4(color, 1.0);
// }

// drawing lines
// void main() {
//     vec3 color = vec3(0.0);

//     float line = smoothstep(0.0001, 0.005, abs(v_uv.y - 0.5));
//     float linearLine = smoothstep(0.0, 0.0075, abs(v_uv.y - mix(0.5, 1.0, v_uv.x)));
//     float smoothLine = smoothstep(0.0, 0.0075, abs(v_uv.y - mix(0.0, 0.5, smoothstep(0.0, 1.0, v_uv.x))));

//     color = vec3(line);

//     if (v_uv.y > 0.5) {
//         color = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), v_uv.x);
//     } else {
//         color = mix(vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0), smoothstep(0.0, 1.0, v_uv.x));
//     }

//     color = mix(vec3(1.0, 1.0, 1.0), color, vec3(line));
//     color = mix(vec3(1.0, 1.0, 1.0), color, linearLine);
//     color = mix(vec3(1.0, 1.0, 1.0), color, smoothLine);

//     gl_FragColor = vec4(color, 1.0);
// }

// resoloution independant grid
// void main() {
//     vec3 color = vec3(1.0);
//     vec2 center = v_uv - 0.5;
    
//     vec2 cell = abs(fract(center * u_resolution / 100.0) - 0.5);
    
//     float dist = 1.0 - 2.0 * max(cell.x, cell.y);
//     float line = smoothstep(0.0, 0.05, dist);

//     float xAxis = smoothstep(0.0, 0.002, abs(v_uv.y - 0.5));
//     float yAxis = smoothstep(0.0, 0.002, abs(v_uv.x - 0.5));

//     vec2 pos = center * u_resolution / 100.0;
//     float val_1 = pos.x;
//     float val_2 = abs(pos.x);
//     float functionLine1 = smoothstep(0.0, 0.075, abs(pos.y - val_1));
//     float functionLine2 = smoothstep(0.0, 0.075, abs(pos.y - val_2));

//     color = mix(vec3(0.0), color, line);
//     color = mix(vec3(1.0, 1.0, 0.0), color, xAxis);
//     color = mix(vec3(1.0, 1.0, 0.0), color, yAxis);
//     color = mix(vec3(0.0, 1.0, 1.0), color, functionLine1);
//     color = mix(vec3(0.0, 1.0, 1.0), color, functionLine2);

//     gl_FragColor = vec4(color, 1.0);
// }