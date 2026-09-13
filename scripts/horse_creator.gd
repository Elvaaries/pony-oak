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
var horse_mask: Image          # маска силуэта (где можно рисовать)
var is_drawing := false
var brush_size := 1
var last_code := ""

func _ready() -> void:
	# --- Настройка пятен ---
	var horse_tex = horse_preview.texture
	if horse_tex == null:
		print("Нет текстуры лошади")
		return
	
	# Создаём прозрачный слой пятен 64x64
	spots_image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	spots_image.fill(Color(0, 0, 0, 0))
	spots_texture = ImageTexture.create_from_image(spots_image)
	spots_layer.texture = spots_texture
	spots_layer.centered = horse_preview.centered
	spots_layer.offset = horse_preview.offset
	spots_layer.position = horse_preview.position
	spots_layer.scale = horse_preview.scale
	spots_layer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# Создаём маску силуэта (где alpha > 0 — можно рисовать)
	horse_mask = horse_tex.get_image()
	
	# --- Цвета зон ---
	var mat = horse_preview.material as ShaderMaterial
	if mat:
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
	
	spots_color_picker.color = Color(0.95, 0.9, 0.75)
	save_dialog.confirmed.connect(_on_save_dialog_confirmed)

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
	
	# Рисуем только если внутри силуэта
	if horse_mask.get_pixel(px, py).a > 0.5:
		spots_image.set_pixel(px, py, spots_color_picker.color)
		spots_texture.update(spots_image)
func _on_clear_spots_button_pressed() -> void:
	if spots_image:
		spots_image.fill(Color(0, 0, 0, 0))
		spots_texture.update(spots_image)

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
		"spots_color": spots_color_picker.color.to_html(false)
	}
	
	# TODO: здесь позже добавим сохранение самой маски пятен и превью
	
	var success = HorseData.add_horse(colors)
	
	if success:
		last_code = Marshalls.utf8_to_base64(JSON.stringify(colors))
		save_dialog.dialog_text = "Окрас сохранён в альбом!"
		save_dialog.popup_centered()
		DisplayServer.clipboard_set(last_code)
	else:
		save_dialog.dialog_text = "Альбом полон (макс. 5)."
		save_dialog.popup_centered()

func _on_save_dialog_confirmed() -> void:
	pass
