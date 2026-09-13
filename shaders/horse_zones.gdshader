shader_type canvas_item;

uniform vec4 head_color : source_color = vec4(0.2, 0.15, 0.12, 1.0);
uniform vec4 neck_color : source_color = vec4(0.4, 0.3, 0.22, 1.0);
uniform vec4 ear_left_color : source_color = vec4(0.55, 0.45, 0.35, 1.0);
uniform vec4 ear_right_color : source_color = vec4(0.6, 0.5, 0.4, 1.0);
uniform vec4 chest_color : source_color = vec4(0.65, 0.52, 0.4, 1.0);
uniform vec4 body_color : source_color = vec4(0.7, 0.55, 0.4, 1.0);
uniform vec4 leg_front_left_color : source_color = vec4(0.3, 0.22, 0.15, 1.0);
uniform vec4 leg_front_right_color : source_color = vec4(0.35, 0.26, 0.18, 1.0);
uniform vec4 leg_back_left_color : source_color = vec4(0.4, 0.3, 0.22, 1.0);
uniform vec4 leg_back_right_color : source_color = vec4(0.45, 0.35, 0.25, 1.0);

uniform float tolerance : hint_range(0.01, 0.1) = 0.03;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 final_color = tex;
	
	if (tex.a > 0.1) {
		float gray = tex.r;
		
		if (abs(gray - 0.0) < tolerance) {
			final_color = vec4(head_color.rgb, tex.a);
		}
		else if (abs(gray - 0.220) < tolerance) { // 383838
			final_color = vec4(neck_color.rgb, tex.a);
		}
		else if (abs(gray - 0.620) < tolerance) { // 9e9e9e
			final_color = vec4(ear_left_color.rgb, tex.a);
		}
		else if (abs(gray - 0.702) < tolerance) { // b3b3b3
			final_color = vec4(ear_right_color.rgb, tex.a);
		}
		else if (abs(gray - 0.451) < tolerance) { // 737373
			final_color = vec4(body_color.rgb, tex.a);
		}
		else if (abs(gray - 0.110) < tolerance) { // 1c1c1c
			final_color = vec4(leg_front_left_color.rgb, tex.a);
		}
		else if (abs(gray - 0.180) < tolerance) { // 2e2e2e
			final_color = vec4(leg_front_right_color.rgb, tex.a);
		}
		else if (abs(gray - 0.290) < tolerance) { // 4a4a4a
			final_color = vec4(leg_back_left_color.rgb, tex.a);
		}
		else if (abs(gray - 0.380) < tolerance) { // 616161
			final_color = vec4(leg_back_right_color.rgb, tex.a);
		}
	}
	
	COLOR = final_color;
}