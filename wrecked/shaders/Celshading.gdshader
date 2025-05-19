shader_type spatial;
render_mode unshaded,diffuse_toon,specular_toon;
//depth texture
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable;
uniform vec3 global_light_dir;


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

void fragment() {
	float depth = Depthapply(SCREEN_UV,INV_PROJECTION_MATRIX);
	//outlines
	//cel shading
	vec3 pos = GetPosFromDepth(SCREEN_UV,depth,INV_PROJECTION_MATRIX);
	vec3 normal = normalize( cross(dFdx(pos), dFdy(pos) ) );
	float diffuse = clamp(max(dot(normal,global_light_dir),0.0),0.0,1.0 );
	ALBEDO = vec3(diffuse)*vec3(1.0,0.0,0.0);
	ALPHA = diffuse;
}


//void light() {
    //DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI;
//}


