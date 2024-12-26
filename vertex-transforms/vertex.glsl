varying vec3 v_normal; 
varying vec3 v_position;
varying vec3 v_color;

uniform float u_time;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

mat3 rotateY(float rads) {
    float s = sin(rads);
    float c = cos(rads);

    return mat3(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

float easeOutBounce(float x) {
  const float n1 = 7.5625;
  const float d1 = 2.75;

  if (x < 1.0 / d1) {
    return n1 * x * x;
  } else if (x < 2.0 / d1) {
    x -= 1.5 / d1;
    return n1 * x * x + 0.75;
  } else if (x < 2.5 / d1) {
    x -= 2.25 / d1;
    return n1 * x * x + 0.9375;
  } else {
    x -= 2.625 / d1;
    return n1 * x * x + 0.984375;
  }
}

float easeInBounce(float x) {
  return 1.0 - easeOutBounce(1.0 - x);
}

float easeInOutBounce(float x) {
  return x < 0.5
    ? (1.0 - easeOutBounce(1.0 - 2.0 * x)) / 2.0
    : (1.0 + easeOutBounce(2.0 * x - 1.0)) / 2.0;
}

// simple y-axis transform
void main() {
    vec3 localSpacePosition = position;

    localSpacePosition.y += sin(u_time);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
    v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
    v_position = (modelMatrix * vec4(position, 1.0)).xyz;
}

// 3-d scaling
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition *= remap(sin(u_time), -1.0, 1.0, 0.5, 1.5);

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// simple y-axis rotation
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition = rotateY(u_time) * localSpacePosition;

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// easing functions
// void main() {
//     vec3 localSpacePosition = position;

//     localSpacePosition *= easeOutBounce(clamp(u_time - 2.0, 0.0, 1.0));

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
// }

// vertex warping
// void main() {
//     vec3 localSpacePosition = position;

//     float t = sin(localSpacePosition.y * 20.0 + u_time * 10.0);
//     t = remap(t, -1.0, 1.0, 0.0, 0.2);
//     localSpacePosition += normal * t;

//     gl_Position = projectionMatrix * modelViewMatrix * vec4(localSpacePosition, 1.0);
//     v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
//     v_position = (modelMatrix * vec4(position, 1.0)).xyz;
//     v_color = mix(
//       vec3(0.0, 0.0, 0.5),
//       vec3(0.1, 0.5, 0.8),
//       smoothstep(0.0, 0.2, t)
//     );
// }