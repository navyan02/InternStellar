shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 2.0) = 0.15;
uniform float density : hint_range(0.1, 2.0) = 0.75;
uniform float brightness : hint_range(0.5, 2.0) = 1.2;

float hash(vec2 p) {
	p = vec2(dot(p, vec2(127.1, 311.7)),
	         dot(p, vec2(269.5, 183.3)));
	return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);

	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
	vec2 uv = UV;
	// Scroll vertically
	uv.y += TIME * scroll_speed;

	// Star layers by thresholding noise
	float n = noise(uv * 80.0);
	float stars = smoothstep(1.0 - 0.001 * (1.5 - density), 1.0, n);

	// Twinkle
	float twinkle = 0.85 + 0.15 * sin(TIME * 5.0 + n * 20.0);

	// Base space gradient (subtle blue tint)
	vec3 base = vec3(0.02, 0.02, 0.07);
	vec3 color = base + vec3(stars) * twinkle * brightness;

	COLOR = vec4(color, 1.0);
}