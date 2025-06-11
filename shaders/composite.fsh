#version 330 compatibility

uniform sampler2D colortex0;

in vec2 texcoord;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(colortex0, texcoord);



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
	color.rgb = floor(color.rgb * 8.0) / 8.0;
}