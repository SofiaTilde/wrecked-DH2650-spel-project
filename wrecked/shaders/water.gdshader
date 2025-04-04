shader_type spatial;

uniform sampler2D dudv_map;
uniform sampler2D normal_map : hint_normal;
uniform sampler2D refraction_map;
uniform vec4 albedo_color;
uniform float alpha : hint_range(0,1) = 1.0;

void vertex() {
	VERTEX.y += sin(VERTEX.x * 0.1 + VERTEX.y * 0.15 + TIME) * 0.21;
	VERTEX.y += sin(VERTEX.x * 0.23 + VERTEX.y * 0.32 + TIME) * 0.15;
	VERTEX.y += sin(VERTEX.x * 0.08 + VERTEX.y * 0.41 + TIME) * 0.13;
	VERTEX.y += sin(VERTEX.x * 0.24 + VERTEX.y * 0.32 + TIME) * 0.11;
	VERTEX.y += sin(VERTEX.x * 0.42 + VERTEX.y * 0.2 + TIME) * 0.12;
}

const float move_factor = 0.005;

void fragment() {
	ALBEDO = albedo_color.rgb;
    ALPHA  = alpha * albedo_color.a;

	vec2 distorted_uv = texture(dudv_map, vec2(UV.x + move_factor * TIME, UV.y)).xy * 0.01;
	distorted_uv = UV + vec2(distorted_uv.x, distorted_uv.y + move_factor * TIME * 0.1);

    vec3 normal_sample = texture(normal_map, distorted_uv * 100.0).rgb;
    NORMAL = normal_sample * 2.0 - 1.0;
		
    ROUGHNESS = 0.0;
    METALLIC = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
