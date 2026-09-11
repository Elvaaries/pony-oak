shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.72, 0.48, 0.28, 1.0);
uniform vec4 shadow_color : source_color = vec4(0.28, 0.16, 0.08, 1.0);
uniform vec4 highlight_color : source_color = vec4(1.0, 0.92, 0.75, 1.0);

void fragment() {
	vec2 center = vec2(0.5);
	float dist = distance(UV, center);
	
	// Круглая маска
	if (dist > 0.48) {
		discard;
	}
	
	// Простое освещение (объём)
	float light = 1.0 - dist * 1.65;
	light = clamp(light, 0.0, 1.0);
	
	// Смешивание цветов
	vec3 col = mix(shadow_color.rgb, base_color.rgb, light);
	col = mix(col, highlight_color.rgb, pow(light, 5.0) * 0.5);
	
	COLOR = vec4(col, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
