shader_type spatial;
render_mode world_vertex_coords; // add wireframe for debug

uniform sampler2D dudv_map;
uniform sampler2D normal_map : hint_normal;
uniform sampler2D refraction_map;
uniform vec4 albedo_color;
uniform float alpha : hint_range(0,1) = 1.0;
uniform float time;

void vertex() {
	VERTEX.y = 0.0;
	VERTEX.y += sin(VERTEX.x * 0.21 + VERTEX.z * 0.26 + time * 0.2) * 0.31;
	VERTEX.y += sin(VERTEX.x * 0.33 + VERTEX.z * 0.192 + time * 0.6) * 0.25;
	VERTEX.y += sin(VERTEX.x * 0.198 + VERTEX.z * 0.1 + time * 0.5) * 0.33;
	VERTEX.y += sin(VERTEX.x * 0.284 + VERTEX.z * 0.42 + time * 0.82) * 0.21;
	VERTEX.y += sin(VERTEX.x * 0.112 + VERTEX.z * 0.27 + time * 0.7) * 0.22;

	VERTEX.y *= clamp(1.0 - sqrt(VERTEX.x * VERTEX.x + VERTEX.z * VERTEX.z) / 128.0, 0.0, 1.0);
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
