// .gdshader
// 3D Noir Shader
// by Kyle Furey

shader_type spatial;
render_mode unshaded, depth_draw_never, cull_disabled;

uniform bool m_monochrome = true;
uniform sampler2D m_texture : hint_screen_texture;
uniform float m_contrast = 2.0f;
uniform int m_steps = 8;
uniform int m_size = 256;

vec4 monochrome(vec4 color) {
	// Converts a color into black and white.
	vec3 hue = vec3(color.rgb);
	vec3 constant = vec3(0.299, 0.587, 0.114);
	float gray = dot(hue, constant);
	return vec4(vec3(gray), color.a);
}

vec4 contrast(vec4 color, float contrast) {
	// Adjusts the contrast of a color.
	vec3 contrasted = (color.rgb - 0.5) * contrast + 0.5;
	return vec4(contrasted, color.a);
}

vec4 quantize(vec4 color, int steps) {
	// Quantizes a color so that colors round to the nearest step.
	vec3 quantized = floor(color.rgb * float(steps)) / float(steps);
	return vec4(quantized, color.a);
}

vec2 pixelate(vec2 uv, int size) {
	// Converts UV's into lower resolution pixels.
	return floor(uv * float(size)) / float(size);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = pixelate(SCREEN_UV, m_size);
	vec4 color = texture(m_texture, uv);
	if (m_monochrome)
		color = monochrome(color);
	color = contrast(color, m_contrast);
	color = quantize(color, m_steps);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
