extends Control

@onready var sphere: Sprite2D = $MarginContainer/VBoxContainer/SpherePreview
@onready var code_input: LineEdit = $MarginContainer/VBoxContainer/CodeInput

func _ready() -> void:
	code_input.grab_focus()
	
	# Если пришли из альбома
	if HorseData.selected_horse != null:
		apply_colors(HorseData.selected_horse)
		HorseData.selected_horse = null

func apply_colors(colors: Dictionary) -> void:
	var mat = sphere.material as ShaderMaterial
	if mat == null:
		return
	
	if colors.has("body"):
		mat.set_shader_parameter("base_color", Color(colors["body"]))
	if colors.has("shadow"):
		mat.set_shader_parameter("shadow_color", Color(colors["shadow"]))
	if colors.has("highlight"):
		mat.set_shader_parameter("highlight_color", Color(colors["highlight"]))

func _on_load_button_pressed() -> void:
	var code = code_input.text.strip_edges()
	
	if code.is_empty():
		print("Код пустой")
		return
	
	var json = Marshalls.base64_to_utf8(code)
	var data = JSON.parse_string(json)
	
	if data == null:
		print("Неправильный код")
		return
	
	apply_colors(data)
	print("Окрас успешно загружен!")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
