shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 10.0) = 1.5;
uniform float fire_height : hint_range(0.0, 1.0) = 0.5;
uniform float distortion_strength : hint_range(0.0, 1.0) = 0.3;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + 
           (c - a)* u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

vec3 fire_gradient(float t) {
    // A cartoon-style gradient from white -> yellow -> orange -> red -> black
    return mix(
        mix(
            mix(vec3(1.0, 1.0, 1.0), vec3(1.0, 1.0, 0.0), smoothstep(0.0, 0.25, t)),
            vec3(1.0, 0.5, 0.0), smoothstep(0.25, 0.5, t)
        ),
        vec3(0.8, 0.0, 0.0), smoothstep(0.5, 1.0, t)
    );
}

void fragment() {
    vec2 uv = UV;

    // Scroll fire upward over time
    uv.y -= TIME * time_speed;

    // Add horizontal distortion for flame wobble
    uv.x += sin(uv.y * 10.0 + TIME * 3.0) * distortion_strength;

    // Scale and distort noise coordinates
    float n = noise(uv * vec2(5.0, 10.0));

    // Fire fades out vertically
    float height_mask = smoothstep(0.0, fire_height, 1.0 - UV.y);

    // Control cartoon-style sharpness
    float flame = step(0.5, n) * height_mask-0.2;

    vec3 color = fire_gradient(UV.y + n * 0.5);
    COLOR = vec4(color, flame);
}
