#version 330 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;

uniform float alphaTestRef = 0.1;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;
in vec3 normal;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 lightmapData;
layout(location = 2) out vec4 encodedNormal;

// lightmapData and encodedNormal is stored in colortex1 and colortex2 respectively
// RENDERTARGETS is Iris's special property

void main() {
	color = texture(gtexture, texcoord) * glcolor; // glcolor is the biome tint
	// color *= texture(lightmap, lmcoord); // default lightmap lighting 
	if (color.a < alphaTestRef) {
		discard;
	}

	// color.rgb = abs(normal); // checking if normals are correct

	// we always set the alpha to 1.0. This is to ensure that the data always gets written, 
	// because if the alpha is 0, Iris may decide that it shouldn’t be written anyway. 
	// This is because of alpha blending.
	lightmapData = vec4(lmcoord, 0.0, 1.0);
	// since textures by default can only store numbers between 0.0 and 1.0, 
	// we must convert our components - which can range from -1.0 to 1.0 - into the [0, 1] range.
	encodedNormal = vec4(normal * 0.5 + 0.5, 1.0); 
}