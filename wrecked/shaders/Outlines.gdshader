shader_type spatial;
render_mode unshaded, cull_front;
//depth texture
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable;
uniform float thickness : hint_range(0.000,1.0,0.0001);
uniform float steps : hint_range(0.000,1.0,0.0001);
uniform vec3 line_color : source_color = vec3(0.0);
uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D normal_rough_texture : hint_normal_roughness_texture;

float Depthapply(vec2 uv, mat4 inv_proj_mat){
	float depth = texture(depth_tex,uv).r;
	return 1. / (depth*inv_proj_mat[2].w +inv_proj_mat[3].w);
}

//normal reconstruction based on https://wickedengine.net/2019/09/improved-normal-reconstruction-from-depth/
vec3 GetPosFromDepth( vec2 uv, float depth, mat4 inv_proj_mat) {
	float x = uv.x*2.0f -1.0f;
	float y = (1.0-uv.y)*2.0f -1.0f;
	vec4 position_s = vec4(x,y,depth,1.0f);
	vec4 position_v = inv_proj_mat * position_s;
	vec3 final_pos = vec3(position_v.xyz/position_v.w);
	return final_pos;
}

void vertex() {
	POSITION = vec4(VERTEX.xy,0.0,0.0);
	// Called for every vertex the material is visible on.
}

//void fragment() {

void fragment() {
	float depth = Depthapply(SCREEN_UV,INV_PROJECTION_MATRIX);
	vec3 normals = texture(normal_rough_texture, SCREEN_UV).rgb;
		
	//outlines
	float line_thickness = thickness;
	//sample right and left of border of depth:
	float border_r = Depthapply(SCREEN_UV-vec2(thickness,0.0),INV_PROJECTION_MATRIX)-depth;
	float border_l = Depthapply(SCREEN_UV+vec2(-thickness,0.0),INV_PROJECTION_MATRIX)-depth;
	float border_u = Depthapply(SCREEN_UV+vec2(0.0,thickness),INV_PROJECTION_MATRIX)-depth;
	float border_d = Depthapply(SCREEN_UV-vec2(0.0,thickness),INV_PROJECTION_MATRIX)-depth;
	float clamp_depth = clamp(border_l-border_r-border_d-border_u,0.0,1.0);
	float outline = smoothstep(0.0, steps,clamp_depth);
	ALBEDO = vec3(normals)*outline*line_color;
	
	ALPHA = outline*10.9;
}



