shader_type spatial;
render_mode blend_mul,diffuse_toon,specular_toon;

uniform float ToonRampOffset: hint_range(0.0, 1.0) = 0.5;
uniform float ToonRampSmoothness: hint_range(0.0, 1.0) = 0.5;
uniform float Glossiness: hint_range(0.0, 1.0) = 1.0; 
uniform float Fresnel: hint_range(0.0, 1.0) = 0.5;

void light() {
	// Diffuse Shading
	float d =  dot(NORMAL,LIGHT) * 0.5 + 0.5;
	float delta = fwidth(d);
	float d_smooth = smoothstep(0.0,delta, d);
	float toonRamp = smoothstep(ToonRampOffset, ToonRampOffset + ToonRampSmoothness, d_smooth);
	DIFFUSE_LIGHT += vec3(toonRamp);
	//Specular lighting
	vec3 halfvec = normalize(LIGHT + VIEW);
	float spec = pow(max(0.0, dot(NORMAL, halfvec)), Glossiness);
	SPECULAR_LIGHT += vec3(spec);
	//remove diffuse contribution to spec
	SPECULAR_LIGHT -= ALBEDO*0.5 * DIFFUSE_LIGHT;

	// Fresnel
	float rim = 1.0- dot(NORMAL,VIEW);
	rim = rim*toonRamp;
	float fresnel_amount = 1.0-Fresnel;
	float rimSmooth = smoothstep(Fresnel, fresnel_amount * 1.4, rim);

	toonRamp *= ATTENUATION;
}