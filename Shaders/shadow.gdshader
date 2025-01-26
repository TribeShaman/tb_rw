shader_type canvas_item;

uniform float rotation_angle = 0.0;
uniform float shadow_offset = 0.1;
uniform vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.5);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
    float cos_angle = cos(rotation_angle);
    float sin_angle = sin(rotation_angle);
    mat2 rotation_matrix = mat2(
        vec2(cos_angle, -sin_angle),
        vec2(sin_angle, cos_angle)
    );

    mat2 scale_matrix = mat2(
        vec2(1.0, 0.0),
        vec2(0.0, TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y)
    );

    vec2 transformed_uv = (UV - vec2(0.5)) * scale_matrix;
    transformed_uv = rotation_matrix * transformed_uv;
	vec2 offset_direction = vec2(cos(rotation_angle), sin(rotation_angle)) * shadow_offset;
    transformed_uv += vec2(0.5) + offset_direction;
	
    vec4 shadow_texture = vec4(0.0);
    if (transformed_uv.x >= 0.0 && transformed_uv.x <= 1.0 && transformed_uv.y >= 0.0 && transformed_uv.y <= 1.0) {
        shadow_texture = texture(TEXTURE, transformed_uv) * vec4(shadow_color.rgb, shadow_color.a * texture(TEXTURE, transformed_uv).a);
    }

    vec4 original_texture = texture(TEXTURE, UV);

    COLOR = mix(shadow_texture, original_texture, original_texture.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
