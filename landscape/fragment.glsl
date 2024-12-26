varying vec2 v_uv;

uniform float u_time;
uniform vec2  u_resolution;

float inverseLerp(float v, float minValue, float maxValue) {
  return (v - minValue) / (maxValue - minValue);
}

float remap(float v, float inMin, float inMax, float outMin, float outMax) {
  float t = inverseLerp(v, inMin, inMax);
  return mix(outMin, outMax, t);
}

// The MIT License
// Copyright © 2013 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// https://www.youtube.com/c/InigoQuilez
// https://iquilezles.org/
//
// https://www.shadertoy.com/view/Xsl3Dl
vec3 hash( vec3 p ) // replace this by something better
{
	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
            dot(p,vec3(269.5,183.3,246.1)),
            dot(p,vec3(113.5,271.9,124.6)));

	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float noise( in vec3 p )
{
  vec3 i = floor( p );
  vec3 f = fract( p );
  vec3 u = f*f*(3.0-2.0*f);

  return mix( mix( mix( dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
                        dot( hash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
                   mix( dot( hash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
                        dot( hash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
              mix( mix( dot( hash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
                        dot( hash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
                   mix( dot( hash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
                        dot( hash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}

float fbm(vec3 p, int octaves, float persistence, float lacunarity) {
  float amplitude = 0.5;
  float frequency = 1.0;
  float total = 0.0;
  float normalization = 0.0;

  for (int i = 0; i < octaves; ++i) {
    float noiseValue = noise(p * frequency);
    total += noiseValue * amplitude;
    normalization += amplitude;
    amplitude *= persistence;
    frequency *= lacunarity;
  }

  total /= normalization;

  return total;
}

vec3 sky() {
  vec3 color1 = vec3(0.3, 0.5, 0.9);
  vec3 color2 = vec3(0.1, 0.15, 0.4);
  return mix(color1, color2, smoothstep(0.875, 1.0, v_uv.y));
}

vec3 mountains(vec3 bg, vec3 color, vec2 px, float depth) {
  float y = fbm(vec3(px.x / 256.0, 1.432, 3.643), 6, 0.5, 2.0) * 256.0;
  vec3 fog = vec3(0.4, 0.6, 0.9);
  float f = smoothstep(0.0, 8000.0, depth);
  float h = smoothstep(256.0, -512.00, px.y);
  f *= h;
  f = mix(h, f, f);
  color = mix(color, fog, f); 
  float sdMountain = px.y - y;
  return mix(color, bg, smoothstep(0.0, 1.0, sdMountain));
}

void main() {
    vec2 pixel_coords = (v_uv - 0.5) * u_resolution;
    vec3 color = sky();
    vec2 t_offset = vec2(u_time * 50.0, 0.0);
    vec2 coords = (pixel_coords - vec2(0.0, 400.0)) * 8.0 + t_offset;
    color = mountains(color, vec3(0.5), coords, 6000.0);
    coords = (pixel_coords - vec2(0.0, 360.0)) * 4.0 + t_offset;
    color = mountains(color, vec3(0.420), coords, 3200.0);
    coords = (pixel_coords - vec2(0.0, 280.0)) * 2.0 + t_offset;
    color = mountains(color, vec3(0.38), coords, 1600.0);
    coords = (pixel_coords - vec2(0.0, 150.0)) * 1.1 + t_offset;
    color = mountains(color, vec3(0.33), coords, 800.0);
    coords = (pixel_coords - vec2(0.0, -100.0)) * 0.5 + t_offset;
    color = mountains(color, vec3(0.3), coords, 400.0);
    coords = (pixel_coords - vec2(0.0, -500.0)) * 0.25 + t_offset;
    color = mountains(color, vec3(0.25), coords, 200.0);
    coords = (pixel_coords - vec2(0.0, -1200.0)) * 0.111 + t_offset;
    color = mountains(color, vec3(0.2), coords, 0.0);
    gl_FragColor = vec4(color, 1.0);
}
