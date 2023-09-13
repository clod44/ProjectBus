shader_type canvas_item;

uniform sampler2D sprite_texture: filter_nearest, repeat_disable, hint_default_transparent;
uniform vec2 shadow_dir = vec2(1.0, 0.0);
uniform float shadow_length = 5.0;
uniform vec4 shadow_color = vec4(0.0, 0.0, 0.0, 0.5);
uniform float my_rotation = 0.0;

void fragment() {
	COLOR = texture(sprite_texture, UV);
	COLOR.rgb *= shadow_color.rgb * COLOR.a;
	COLOR.a *= shadow_color.a;
}

vec2 rotateVector(vec2 v, float radians) {
    float cosAngle = cos(radians);
    float sinAngle = sin(radians);
    
    float newX = v.x * cosAngle - v.y * sinAngle;
    float newY = v.x * sinAngle + v.y * cosAngle;
    
    return vec2(newX, newY);
}


void vertex() {
  VERTEX += rotateVector(shadow_dir, -my_rotation) * shadow_length;
}


