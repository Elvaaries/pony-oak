extends Control

@onready var horse_preview: Sprite2D = $MarginContainer/VBoxContainer/HorsePreview
@onready var spots_layer: Sprite2D = $MarginContainer/VBoxContainer/SpotsLayer
@onready var body_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/BodyBox/BodyPicker
@onready var shadow_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/ShadowBox/ShadowPicker
@onready var highlight_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/HighlightBox/HighlightPicker
@onready var spots_color_picker: ColorPickerButton = $MarginContainer/VBoxContainer/SpotsBox/SpotsColorPicker
@onready var save_dialog: AcceptDialog = $SaveDialog

var spots_image: Image
var spots_texture: ImageTexture
var is_drawing := false
var brush_size := 6
var last_code := ""

func _ready() -> void:
	# Создаём прозрачную картинку для пятен такого же размера, как силуэт
	var horse_tex = horse_preview.texture
	if horse_tex == null:
		print("Нет текстуры у HorsePreview!")
		return
	
	var size = horse_tex.get_size()
	spots_image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	spots_image.fill(Color(0, 0, 0, 0))  # полностью прозрачная
	
	spots_texture = ImageTexture.create_from_image(spots_image)
	spots_layer.texture = spots_texture
	
	# Синхронизируем позицию и масштаб пятен с лошадью
	spots_layer.position = horse_preview.position
	spots_layer.scale = horse_preview.scale
	spots_layer.offset = horse_preview.offset
	
	# Начальный цвет пятен
	spots_color_picker.color = Color(0.95, 0.9, 0.75)
	
	# Подключаем цвета силуэта (если используешь шейдер)
	# Пока оставляем простой modulate, потом вернём шейдер
	
	save_dialog.confirmed.connect(_on_save_dialog_confirmed)

func _process(_delta: float) -> void:
	if is_drawing:
		draw_spot_at_mouse()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_drawing = event.pressed
			if is_drawing:
				draw_spot_at_mouse()

func draw_spot_at_mouse() -> void:
	if spots_image == null:
		return
	
	# Переводим позицию мыши в локальные координаты слоя пятен
	var local_pos = spots_layer.get_local_mouse_position()
	
	# Учитываем, что у Sprite2D центр может быть смещён
	var tex_size = spots_image.get_size()
	var pixel_x = int(local_pos.x + tex_size.x / 2.0)
	var pixel_y = int(local_pos.y + tex_size.y / 2.0)
	
	# Рисуем круглую кисть
	var color = spots_color_picker.color
	for x in range(-brush_size, brush_size + 1):
		for y in range(-brush_size, brush_size + 1):
			if x*x + y*y <= brush_size * brush_size:
				var px = pixel_x + x
				var py = pixel_y + y
				if px >= 0 and py >= 0 and px < tex_size.x and py < tex_size.y:
					spots_image.set_pixel(px, py, color)
	
	# Обновляем текстуру
	spots_texture.update(spots_image)

func _on_clear_spots_button_pressed() -> void:
	if spots_image:
		spots_image.fill(Color(0, 0, 0, 0))
		spots_texture.update(spots_image)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_button_pressed() -> void:
	# Пока сохраняем только цвета (пятна сохраним в следующем шаге)
	var colors = {
		"body": body_picker.color.to_html(false),
		"shadow": shadow_picker.color.to_html(false),
		"highlight": highlight_picker.color.to_html(false),
		"spots_color": spots_color_picker.color.to_html(false)
	}
	
	var success = HorseData.add_horse(colors)
	
	if success:
		var json = JSON.stringify(colors)
		last_code = Marshalls.utf8_to_base64(json)
		save_dialog.dialog_text = "Окрас сохранён!\n\nКод:\n" + last_code
		save_dialog.popup_centered()
	else:
		save_dialog.dialog_text = "Альбом полон (максимум 5)."
		save_dialog.popup_centered()

func _on_save_dialog_confirmed() -> void:
	if last_code != "":
		DisplayServer.clipboard_set(last_code)
