shader_type canvas_item;

uniform vec2 swirl_center = vec2(0.425, 0.425); // UV space (0–1)
uniform float swirl_strength = 0.8;
uniform float swirl_radius = 1.5;

void fragment() {
    vec2 uv = UV; // Use UV directly — already in [0,1] range
    vec4 color = texture(TEXTURE, uv);

    vec2 offset = uv - swirl_center;
    float dist = length(offset);

    if (dist < swirl_radius) {
        float angle = atan(offset.y, offset.x);
        float swirl_amount = (1.0 - dist / swirl_radius);
        float rotated_angle = angle + swirl_strength * swirl_amount * swirl_amount * TIME;
        vec2 rotated = vec2(cos(rotated_angle), sin(rotated_angle)) * dist;

        vec2 new_uv = swirl_center + rotated;
        // Only sample if inside texture bounds
        if (new_uv.x >= 0.0 && new_uv.x <= 1.0 && new_uv.y >= 0.0 && new_uv.y <= 1.0) {
            color = texture(TEXTURE, new_uv);
        }
    }

    COLOR = color;
}
