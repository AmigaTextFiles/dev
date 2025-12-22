#version 130

in vec4 Colour;
in vec2 TexCoord;

uniform sampler2D texSampler;

void main(void) {
	vec4 texel = texture(texSampler, TexCoord);
	gl_FragColor =  texel;
}