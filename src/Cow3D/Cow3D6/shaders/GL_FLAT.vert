#version 130

in vec3 vertPosition;
in vec3 vertNormal;
in vec2 vertTexCoord;

uniform mat4 ModelViewProjectionMatrix;
uniform mat4 NormalMatrix;
uniform vec4 LightSourcePosition;

out vec4 Colour;
out vec2 TexCoord;

void main(void) {
	// Transform the position to clip coordinates
	gl_Position = ModelViewProjectionMatrix * vec4(vertPosition, 1.0);
	
	Colour = vec4(1.0,1.0,1.0,0.5);

	// Simply pass the texture coordinate straight through...
	TexCoord = vertTexCoord;
}