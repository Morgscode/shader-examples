uniform samplerCube u_specmap;

varying vec2 v_uv;
varying vec3 v_normal;
varying vec3 v_position;

void main () {
    vec4 localPosition = vec4(position, 1.0);
    gl_Position = projectionMatrix * modelViewMatrix * localPosition;
    v_uv = uv;
    v_normal = (modelMatrix * vec4(normal, 0.0)).xyz;
    v_position = (modelMatrix * localPosition).xyz;
}