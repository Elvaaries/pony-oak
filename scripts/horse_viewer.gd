extends Control

@onready var sphere: Sprite2D = $MarginContainer/VBoxContainer/SpherePreview
@onready var code_input: LineEdit = $MarginContainer/VBoxContainer/CodeInput

func _ready() -> void:
	# Можно сразу поставить фокус в поле ввода
	code_input.grab_focus()

func _on_load_button_pressed() -> void:
	var code = code_input.text.strip_edges()
	
	if code.is_empty():
		print("Код пустой")
		return
	
	# Декодируем
	var json = Marshalls.base64_to_utf8(code)
	var data = JSON.parse_string(json)
	
	if data == null:
		print("Неправильный код")
		return
	
	# Применяем цвета
	var mat = sphere.material as ShaderMaterial
	if mat == null:
		print("Нет материала у сферы")
		return
	
	if data.has("body"):
		mat.set_shader_parameter("base_color", Color(data["body"]))
	if data.has("shadow"):
		mat.set_shader_parameter("shadow_color", Color(data["shadow"]))
	if data.has("highlight"):
		mat.set_shader_parameter("highlight_color", Color(data["highlight"]))
	
	print("Окрас успешно загружен!")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
