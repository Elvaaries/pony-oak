extends Control

@onready var horse_preview: Sprite2D = $MarginContainer/VBoxContainer/HorsePreview
@onready var spots_layer: Sprite2D = $MarginContainer/VBoxContainer/SpotsLayer
@onready var code_input: LineEdit = $MarginContainer/VBoxContainer/CodeInput

func _ready() -> void:
	if horse_preview == null:
		push_error("HorsePreview не найден!")
		return
	
	# Делаем материал уникальным
	if horse_preview.material:
		horse_preview.material = horse_preview.material.duplicate()
	
	if spots_layer:
		spots_layer.centered = horse_preview.centered
		spots_layer.offset = horse_preview.offset
		spots_layer.position = horse_preview.position
		spots_layer.scale = horse_preview.scale
		spots_layer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# Если пришли из альбома по кнопке «Смотр»
	if HorseData.selected_horse != null:
		print("Загрузка из альбома")
		apply_horse_data(HorseData.selected_horse)
		HorseData.selected_horse = null
	else:
		print("Ожидание ввода кода")
		if code_input:
			code_input.grab_focus()

func apply_horse_data(data: Dictionary) -> void:
	var mat = horse_preview.material as ShaderMaterial
	if mat == null:
		print("ОШИБКА: нет ShaderMaterial")
		return
	
	print("Применяю цвета...")
	
	if data.has("head"): mat.set_shader_parameter("head_color", Color(data["head"]))
	if data.has("neck"): mat.set_shader_parameter("neck_color", Color(data["neck"]))
	if data.has("ear_left"): mat.set_shader_parameter("ear_left_color", Color(data["ear_left"]))
	if data.has("ear_right"): mat.set_shader_parameter("ear_right_color", Color(data["ear_right"]))
	if data.has("chest"): mat.set_shader_parameter("chest_color", Color(data["chest"]))
	if data.has("body"): mat.set_shader_parameter("body_color", Color(data["body"]))
	if data.has("leg_fl"): mat.set_shader_parameter("leg_front_left_color", Color(data["leg_fl"]))
	if data.has("leg_fr"): mat.set_shader_parameter("leg_front_right_color", Color(data["leg_fr"]))
	if data.has("leg_bl"): mat.set_shader_parameter("leg_back_left_color", Color(data["leg_bl"]))
	if data.has("leg_br"): mat.set_shader_parameter("leg_back_right_color", Color(data["leg_br"]))
	
	# Пятна
	if data.has("spots") and spots_layer:
		var path = "user://horse_spots/" + str(data["spots"])
		if FileAccess.file_exists(path):
			var img = Image.load_from_file(path)
			if img:
				spots_layer.texture = ImageTexture.create_from_image(img)
				print("Пятна загружены")
			else:
				print("Не удалось загрузить пятна")
		else:
			print("Файл пятен не найден: ", path)
	else:
		if spots_layer:
			spots_layer.texture = null

func _on_load_button_pressed() -> void:
	if code_input == null:
		print("CodeInput не найден")
		return
	
	var code = code_input.text.strip_edges()
	if code.is_empty():
		print("Код пустой")
		return
	
	# Декодируем base64 → JSON
	var json_str = Marshalls.base64_to_utf8(code)
	if json_str.is_empty():
		print("Не удалось декодировать base64")
		return
	
	var data = JSON.parse_string(json_str)
	if data == null or not data is Dictionary:
		print("Неправильный формат кода")
		return
	
	print("Код успешно распознан")
	apply_horse_data(data)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
