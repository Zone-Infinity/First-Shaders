#version 330 compatibility
#include /lib/distort.glsl

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform vec3 shadowLightPosition; // Position of Sun OR Moon
uniform sampler2D depthtex0; // Tells us how far the pixel is

uniform sampler2D shadowtex0;
// To check if a pixel is shadowed, we need to know where in the shadow map it is. 
// We can do this by transforming the position of the pixel into shadow space. 
// We will need the following transformation matrices:
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

// Because colortex buffers are designed to hold gamma corrected colors, 
// you will lose some possible color values if you write linear color to them.
// To solve this, the following
/*
const int colortex0Format = RGB16;
*/
// Observe that the declaration for the format is in a multi - line comment.
// This is because this code does not actually need to make it onto the GPU.
// Instead, Iris reads it, and knows to set the format of the buffer as we defined it.
// That means we can place this code anywhere in the shaderpack.

const vec3 blocklightColor = vec3(1.0, 0.5, 0.08);
const vec3 skylightColor = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColor = vec3(1.0);
const vec3 ambientColor = vec3(0.1);

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position) {
	vec4 homPos = projectionMatrix * vec4(position, 1.0);
	return homPos.xyz / homPos.w;
}

void main() {
	color = texture(colortex0, texcoord);

	color.rgb = pow(color.rgb, vec3(2.2)); // Inversing Gamma correction

	float depth = texture(depthtex0, texcoord).r;
	if(depth == 1.0) {
	 	return;
	}

	vec2 lightmap = texture(colortex1, texcoord).rg;
	vec3 encodedNormal = texture(colortex2, texcoord).rgb;
	vec3 normal = normalize((encodedNormal - 0.5) * 2.0); // we normalize to make sure it is of unit length

	vec3 lightVector = normalize(shadowLightPosition);
	vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;

	// color.rgb = vec3(lightmap, 0.0); // To verify lightmap
	// After verifying, we realise that r is block light (torch, etc), and g is sky light

	vec3 blocklight = lightmap.r * blocklightColor;
	vec3 skylight = lightmap.g * skylightColor;
	vec3 ambient = ambientColor;
	// vec3 sunlight = sunlightColor * clamp(dot(worldLightVector, normal), 0.0, 1.0) * lightmap.g;

	// color.rgb = texture(shadowtex0, texcoord).rgb; // Shadow texture

	// Space Conversion
	vec3 NDCPos = vec3(texcoord.xy, depth) * 2.0 - 1.0;
	vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
	vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
	shadowClipPos.z -= 0.001; //shadow bias
	shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz); // distortion
	vec3 shadowNDCPos = shadowClipPos.xyz / shadowClipPos.w;
	vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5; // We can sample shadow map at this pos

	float shadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);
	vec3 sunlight = sunlightColor * clamp(dot(worldLightVector, normal), 0.0, 1.0) * shadow;

	color.rgb *= blocklight + skylight + ambient + sunlight;


	/// Greyscale effect 
	// float grayscale = dot(color.rgb, vec3(1.0 / 3.0));
	// color.rgb = vec3(grayscale);

	/// Making the screen Cyan (tried R, G, B, C, Y, P)
	// color.rgb = vec3(0, color.g, color.b);

	/// Half red Half green
	// if(texcoord.x > 0.5)
	// 	color.rgb = vec3(color.r, 0, 0);
	// else 
	// 	color.rgb = vec3(0 , color.g, 0);

	/// Inverting the colors
	//color.rgb = vec3(1.0) - color.rgb;

	/// Vignette effect
	// float vignette = 1.0 - length(texcoord - vec2(0.5)) * 1.0; // 1.0 is strength
	// color.rgb *= vignette * vignette;

	/// Sepia effect
	// color.rgb = vec3(
	//     dot(color.rgb, vec3(0.393, 0.769, 0.189)),
	//     dot(color.rgb, vec3(0.349, 0.686, 0.168)),
	//     dot(color.rgb, vec3(0.272, 0.534, 0.131))
	// );

	/// Noise/Grain Effect
	// float noise = fract(sin(dot(texcoord * 100.0, vec2(12.9898, 78.233))) * 43758.5453);
	// color.rgb += vec3(noise * 0.2);

	/// Color shift Effect
	// color.rgb += vec3(0.1 * sin(texcoord.x * 10.0), 0.1 * cos(texcoord.y * 10.0), 0.1 * sin(texcoord.x * texcoord.y * 10.0));

	/// Pixelation effect
	// vec2 pixelatedCoord = floor(texcoord * 100.0) / 100.0;
	// color.rgb = texture(colortex0, pixelatedCoord).rgb;

	/// Scanline effect
	// float scanline = 0.5 + 0.5 * sin(texcoord.y * 100.0);
	// color.rgb *= vec3(scanline, scanline, scanline);

	/// Glitch effect (lined :P)
	// if (fract(texcoord.y * 10.0) < 0.1) {
	//     color.rgb = vec3(1.0) - color.rgb;
	// }

	/// Posterization effect
	// color.rgb = floor(color.rgb * 8.0) / 8.0;

	/// These were only color effects, later will try to make 3D Effects
	/// Like "Screen spinning about y axis, so basically you'll see a 2D Plane rotating in 3D"
	///      "Ripple effect maybe ?"
	/// 	 and etc etc
	
}