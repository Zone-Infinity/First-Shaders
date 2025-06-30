#version 330 compatibility

uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 texcoord;
in vec4 glcolor;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(gtexture, texcoord) * glcolor;

	// Make clouds circular (DOesn't work right now)
	float dist = length(texcoord - vec2(0.5, 0.5));
	if (dist > 0.5) {
		color.a = 0.0; // Set alpha to 0 if outside the circle
	}
	// Ensure the alpha is always 1.0 to prevent Iris from discarding the fragment
	//color.a = max(color.a, 1.0);
	// Apply alpha testing
	// If the alpha is less than the reference, discard the fragment
	// This is to ensure that the data always gets written,
	// because if the alpha is 0, Iris may decide that it shouldn’t be written anyway.
	// This is because of alpha blending.
	// Note: The alpha test is applied after the circular mask to ensure that
	// fragments outside the circle are discarded correctly.

	if (color.a < alphaTestRef) {
		discard;
	}
}