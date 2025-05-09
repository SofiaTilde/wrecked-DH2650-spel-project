shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 0.1) = 0.01;
uniform float frequency : hint_range(0.0, 50.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec2 uv = UV;
    uv.y += sin(uv.x * frequency + TIME * speed) * amplitude;
    uv.x += sin(uv.y * frequency + TIME * speed) * amplitude * 0.5;
    COLOR = texture(TEXTURE, uv);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
