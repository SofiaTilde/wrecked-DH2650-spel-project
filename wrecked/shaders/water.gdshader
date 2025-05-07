shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D dudv_map;
uniform sampler2D normal_map : hint_normal;
uniform sampler2D refraction_map;
uniform vec4 albedo_color;
uniform float alpha : hint_range(0,1) = 1.0;
uniform float time;

void vertex() {
	VERTEX.y = 0.0;

	VERTEX.y += sin(VERTEX.x * 0.51 + VERTEX.z * 0.56 + time * 0.6) * 0.41;
	VERTEX.y += sin(VERTEX.x * 0.73 + VERTEX.z * 0.392 + time * 0.9) * 0.35;
	VERTEX.y += sin(VERTEX.x * 0.398 + VERTEX.z * 0.2 + time * 0.7) * 0.43;
	VERTEX.y += sin(VERTEX.x * 0.484 + VERTEX.z * 0.82 + time * 0.82) * 0.21;
	VERTEX.y += sin(VERTEX.x * 0.212 + VERTEX.z * 0.47 + time * 0.75) * 0.32;

	VERTEX.y *= pow(clamp(1.0 - sqrt(VERTEX.x * VERTEX.x + VERTEX.z * VERTEX.z) / 128.0, 0.05, 1.0), 0.5);
}

const float move_factor = 0.05;

void fragment() {
	ALBEDO = albedo_color.rgb;
    ALPHA  = alpha * albedo_color.a;

	vec2 distorted_uv = texture(dudv_map, vec2(UV.x * 16.0 + move_factor * TIME, UV.y * 16.0)).xy * 0.05;
	distorted_uv = UV + vec2(distorted_uv.x, distorted_uv.y + move_factor * TIME * 0.1);

    vec3 normal_sample = texture(normal_map, distorted_uv * 32.0).rgb;
    NORMAL = normal_sample * 2.0 - 1.0;

    ROUGHNESS = 0.0;
    METALLIC = 0.0;
}
