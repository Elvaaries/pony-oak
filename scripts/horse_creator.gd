extends Control

@onready var sphere: Sprite2D = $MarginContainer/VBoxContainer/SpherePreview
@onready var body_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/BodyPicker
@onready var shadow_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/ShadowPicker
@onready var highlight_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/HighlightPicker

func _ready() -> void:
	var mat = sphere.material as ShaderMaterial
	body_picker.color = mat.get_shader_parameter("base_color")
	shadow_picker.color = mat.get_shader_parameter("shadow_color")
	highlight_picker.color = mat.get_shader_parameter("highlight_color")
	
	body_picker.color_changed.connect(func(c): mat.set_shader_parameter("base_color", c))
	shadow_picker.color_changed.connect(func(c): mat.set_shader_parameter("shadow_color", c))
	highlight_picker.color_changed.connect(func(c): mat.set_shader_parameter("highlight_color", c))

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_button_pressed() -> void:
	var colors = {
		"body": body_picker.color.to_html(false),
		"shadow": shadow_picker.color.to_html(false),
		"highlight": highlight_picker.color.to_html(false)
	}
	
	# Пробуем сохранить в альбом
	var success = HorseData.add_horse(colors)
	
	if success:
		print("Окрас сохранён в альбом! Всего: ", HorseData.horses.size())
		# Позже здесь будет красивое окно
	else:
		print("Альбом полон! Максимум 5 окрасов.")
