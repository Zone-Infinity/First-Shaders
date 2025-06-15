#version 330 compatibility

out vec2 lmcoord; // lightmap
out vec2 texcoord; // texture atlas
out vec4 glcolor;
out vec3 normal;

uniform mat4 gbufferModelViewInverse;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	lmcoord = (lmcoord * 33.05 / 32.0) - (1.05 / 32.0);
	glcolor = gl_Color;
	// glcolor = vec4(1.0); // Removes grass block tints (Greyscale of grass blocks)

	// gl_Normal gives model space normal
	normal = gl_NormalMatrix * gl_Normal; // this gives us the normal in view space
	normal = mat3(gbufferModelViewInverse) * normal; // this converts the normal to world/player space
	// Doubt : mat3(mat4) ??
}