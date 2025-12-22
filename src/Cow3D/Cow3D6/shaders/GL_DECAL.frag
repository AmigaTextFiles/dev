#version 130

in vec4 Colour;
in vec2 TexCoord;

uniform sampler2D texSampler;

void main(void) {
	vec4 texel = texture(texSampler, TexCoord);
	vec3 rgbCol = texel.rgb * (1.0 - Colour.a) + Colour.rgb * Colour.a;
	gl_FragColor = vec4(rgbCol, texel.a);

}