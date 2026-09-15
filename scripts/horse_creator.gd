extends Control

@onready var horse_preview: Sprite2D = $MarginContainer/VBoxContainer/HorsePreview
@onready var spots_layer: Sprite2D = $MarginContainer/VBoxContainer/SpotsLayer

@onready var head_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/HeadPicker
@onready var neck_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/NeckPicker
@onready var ear_left_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/EarLeftPicker
@onready var ear_right_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/EarRightPicker
@onready var chest_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/ChestPicker
@onready var body_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/BodyPicker
@onready var leg_fl_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/LegFLPicker
@onready var leg_fr_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/LegFRPicker
@onready var leg_bl_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/LegBLPicker
@onready var leg_br_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/LegBRPicker

@onready var spots_color_picker: ColorPickerButton = $MarginContainer/VBoxContainer/SpotsBox/SpotsColorPicker
@onready var save_dialog: AcceptDialog = $SaveDialog

var spots_image: Image
var spots_texture: ImageTexture
var horse_mask: Image
var is_drawing := false
var brush_size := 1
var last_code := ""

func _ready() -> void:
	var horse_tex = horse_preview.texture
	if horse_tex == null:
		print("Нет текстуры лошади")
		return
	
	spots_image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	spots_image.fill(Color(0, 0, 0, 0))
	spots_texture = ImageTexture.create_from_image(spots_image)
	spots_layer.texture = spots_texture
	spots_layer.centered = horse_preview.centered
	spots_layer.offset = horse_preview.offset
	spots_layer.position = horse_preview.position
	spots_layer.scale = horse_preview.scale
	spots_layer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	horse_mask = horse_tex.get_image()
	
	var mat = horse_preview.material as ShaderMaterial
	if mat:
		_connect_pickers(mat)
	
	spots_color_picker.color = Color(0.95, 0.9, 0.75)
	save_dialog.confirmed.connect(_on_save_dialog_confirmed)
	
	# Загрузка из альбома (кнопка «Изм»)
	if HorseData.selected_horse != null:
		apply_horse_data(HorseData.selected_horse)
		HorseData.selected_horse = null

func _connect_pickers(mat: ShaderMaterial) -> void:
	head_picker.color = mat.get_shader_parameter("head_color")
	neck_picker.color = mat.get_shader_parameter("neck_color")
	ear_left_picker.color = mat.get_shader_parameter("ear_left_color")
	ear_right_picker.color = mat.get_shader_parameter("ear_right_color")
	chest_picker.color = mat.get_shader_parameter("chest_color")
	body_picker.color = mat.get_shader_parameter("body_color")
	leg_fl_picker.color = mat.get_shader_parameter("leg_front_left_color")
	leg_fr_picker.color = mat.get_shader_parameter("leg_front_right_color")
	leg_bl_picker.color = mat.get_shader_parameter("leg_back_left_color")
	leg_br_picker.color = mat.get_shader_parameter("leg_back_right_color")
	
	head_picker.color_changed.connect(func(c): mat.set_shader_parameter("head_color", c))
	neck_picker.color_changed.connect(func(c): mat.set_shader_parameter("neck_color", c))
	ear_left_picker.color_changed.connect(func(c): mat.set_shader_parameter("ear_left_color", c))
	ear_right_picker.color_changed.connect(func(c): mat.set_shader_parameter("ear_right_color", c))
	chest_picker.color_changed.connect(func(c): mat.set_shader_parameter("chest_color", c))
	body_picker.color_changed.connect(func(c): mat.set_shader_parameter("body_color", c))
	leg_fl_picker.color_changed.connect(func(c): mat.set_shader_parameter("leg_front_left_color", c))
	leg_fr_picker.color_changed.connect(func(c): mat.set_shader_parameter("leg_front_right_color", c))
	leg_bl_picker.color_changed.connect(func(c): mat.set_shader_parameter("leg_back_left_color", c))
	leg_br_picker.color_changed.connect(func(c): mat.set_shader_parameter("leg_back_right_color", c))

func apply_horse_data(data: Dictionary) -> void:
	var mat = horse_preview.material as ShaderMaterial
	if mat == null:
		return
	
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
	
	# Обновляем пикеры
	head_picker.color = mat.get_shader_parameter("head_color")
	neck_picker.color = mat.get_shader_parameter("neck_color")
	ear_left_picker.color = mat.get_shader_parameter("ear_left_color")
	ear_right_picker.color = mat.get_shader_parameter("ear_right_color")
	chest_picker.color = mat.get_shader_parameter("chest_color")
	body_picker.color = mat.get_shader_parameter("body_color")
	leg_fl_picker.color = mat.get_shader_parameter("leg_front_left_color")
	leg_fr_picker.color = mat.get_shader_parameter("leg_front_right_color")
	leg_bl_picker.color = mat.get_shader_parameter("leg_back_left_color")
	leg_br_picker.color = mat.get_shader_parameter("leg_back_right_color")
	
	# Загрузка пятен
	if data.has("spots"):
		var path = "user://horse_spots/" + str(data["spots"])
		print("Пытаюсь загрузить пятна: ", path)
		if FileAccess.file_exists(path):
			var img = Image.load_from_file(path)
			if img:
				spots_image = img
				spots_texture = ImageTexture.create_from_image(spots_image)
				spots_layer.texture = spots_texture
				print("Пятна успешно загружены")
			else:
				print("Image.load_from_file вернул null")
		else:
			print("Файл пятен не существует")
	else:
		print("В данных нет ключа spots")
	
	if data.has("spots_color"):
		spots_color_picker.color = Color(data["spots_color"])

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_drawing = event.pressed
		if is_drawing:
			draw_spot()

func _process(_delta: float) -> void:
	if is_drawing:
		draw_spot()

func draw_spot() -> void:
	if spots_image == null or horse_mask == null:
		return
	
	var local_pos = spots_layer.get_local_mouse_position()
	var px = int(local_pos.x + 32)
	var py = int(local_pos.y + 32)
	
	if px < 0 or py < 0 or px >= 64 or py >= 64:
		return
	
	if horse_mask.get_pixel(px, py).a > 0.5:
		spots_image.set_pixel(px, py, spots_color_picker.color)
		spots_texture.update(spots_image)

func _on_clear_spots_button_pressed() -> void:
	if spots_image:
		spots_image.fill(Color(0, 0, 0, 0))
		spots_texture.update(spots_image)

func _on_clear_button_pressed() -> void:
	clear_all()

func clear_all() -> void:
	var mat = horse_preview.material as ShaderMaterial
	if mat == null:
		return
	
	var defaults = {
		"head_color": Color(0.2, 0.15, 0.12),
		"neck_color": Color(0.4, 0.3, 0.22),
		"ear_left_color": Color(0.55, 0.45, 0.35),
		"ear_right_color": Color(0.6, 0.5, 0.4),
		"chest_color": Color(0.65, 0.52, 0.4),
		"body_color": Color(0.7, 0.55, 0.4),
		"leg_front_left_color": Color(0.3, 0.22, 0.15),
		"leg_front_right_color": Color(0.35, 0.26, 0.18),
		"leg_back_left_color": Color(0.4, 0.3, 0.22),
		"leg_back_right_color": Color(0.45, 0.35, 0.25)
	}
	
	for key in defaults:
		mat.set_shader_parameter(key, defaults[key])
	
	head_picker.color = defaults["head_color"]
	neck_picker.color = defaults["neck_color"]
	ear_left_picker.color = defaults["ear_left_color"]
	ear_right_picker.color = defaults["ear_right_color"]
	chest_picker.color = defaults["chest_color"]
	body_picker.color = defaults["body_color"]
	leg_fl_picker.color = defaults["leg_front_left_color"]
	leg_fr_picker.color = defaults["leg_front_right_color"]
	leg_bl_picker.color = defaults["leg_back_left_color"]
	leg_br_picker.color = defaults["leg_back_right_color"]
	
	if spots_image:
		spots_image.fill(Color(0, 0, 0, 0))
		spots_texture.update(spots_image)
	
	spots_color_picker.color = Color(0.95, 0.9, 0.75)
	print("Окрас полностью очищен")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_button_pressed() -> void:
	var colors = {
		"head": head_picker.color.to_html(false),
		"neck": neck_picker.color.to_html(false),
		"ear_left": ear_left_picker.color.to_html(false),
		"ear_right": ear_right_picker.color.to_html(false),
		"chest": chest_picker.color.to_html(false),
		"body": body_picker.color.to_html(false),
		"leg_fl": leg_fl_picker.color.to_html(false),
		"leg_fr": leg_fr_picker.color.to_html(false),
		"leg_bl": leg_bl_picker.color.to_html(false),
		"leg_br": leg_br_picker.color.to_html(false),
		"spots_color": spots_color_picker.color.to_html(false),
		"name": "Окрас " + str(HorseData.horses.size() + 1)
	}
	
	var preview = await capture_preview()
	var success = HorseData.add_horse(colors, preview, spots_image.duplicate())
	
	if success:
		last_code = Marshalls.utf8_to_base64(JSON.stringify(colors))
		save_dialog.dialog_text = "Окрас сохранён!"
		save_dialog.popup_centered()
		DisplayServer.clipboard_set(last_code)
		clear_all()
	else:
		save_dialog.dialog_text = "Альбом полон (макс. 5)."
		save_dialog.popup_centered()

func _on_save_dialog_confirmed() -> void:
	pass

func capture_preview() -> Image:
	var preview_size = 128
	var viewport = SubViewport.new()
	viewport.size = Vector2i(preview_size, preview_size)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(viewport)
	
	var horse_copy = Sprite2D.new()
	horse_copy.texture = horse_preview.texture
	horse_copy.material = horse_preview.material.duplicate()
	horse_copy.centered = true
	horse_copy.position = Vector2(preview_size / 2.0, preview_size / 2.0)
	horse_copy.scale = Vector2(1.6, 1.6)
	horse_copy.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	viewport.add_child(horse_copy)
	
	var spots_copy = Sprite2D.new()
	spots_copy.texture = spots_texture
	spots_copy.centered = true
	spots_copy.position = Vector2(preview_size / 2.0, preview_size / 2.0)
	spots_copy.scale = Vector2(1.6, 1.6)
	spots_copy.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	viewport.add_child(spots_copy)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	var img = viewport.get_texture().get_image()
	viewport.queue_free()
	return img
