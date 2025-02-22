uniform samplerCube u_specmap;

varying vec3 v_normal;
varying vec3 v_position;
varying vec3 v_color;

float inverseLerp(float v, float minVal, float maxVal) {
    return (v - minVal) / (maxVal - minVal);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
    float t = inverseLerp(v, inMin, inMax);
    return mix(outMin, outMax, t);
}

vec3 linearTosRGB(vec3 value ) {
    vec3 lt = vec3(lessThanEqual(value.rgb, vec3(0.0031308)));
    vec3 v1 = value * 12.92;
    vec3 v2 = pow(value.xyz, vec3(0.41666)) * 1.055 - vec3(0.055);
    return mix(v2, v1, lt);
}

// specular IBL with fresnel
void main() {
    vec3 base = v_color.xyz;
    vec3 lighting = vec3(0.0);
    vec3 normal = normalize(cross(dFdx(v_position.xyz), dFdy(v_position.xyz)));
    vec3 viewDirection = normalize(cameraPosition - v_position);

    vec3 ambient = vec3(0.5);

    vec3 sColor = vec3(0.0, 0.3, 0.6);
    vec3 gColor = vec3(0.6, 0.3, 0.1);

    float hemiMix = remap(normal.y, -1.0, 1.0, 0.0, 1.0);
    vec3 hemi = mix(gColor, sColor, hemiMix);

    vec3 lightDirection = normalize(vec3(1.0));
    vec3 lightColor = vec3(1.0, 1.0, 0.9);
    float dotProduct = max(0.0, dot(lightDirection, normal));

    vec3 diffuse = dotProduct * lightColor;

    vec3 reflection = normalize(reflect(-lightDirection, normal));
    float phongValue = max(0.0, dot(viewDirection, reflection));

    vec3 specular = vec3(phongValue);

    vec3 iblCord = normalize(reflect(-viewDirection, normal));
    vec3 iblSample = textureCube(u_specmap, iblCord).xyz;

    specular += iblSample * 0.5;

    float fresnel = 1.0 - max(0.0, dot(viewDirection, normal));
    fresnel = pow(fresnel, 2.0);

    specular *= fresnel;

    lighting = ambient + 0.0 + hemi * 0.0 + diffuse * 1.0;

    vec3 color = base * lighting + specular;

    color = linearTosRGB(color);

    gl_FragColor = vec4(color, 1.0);
}