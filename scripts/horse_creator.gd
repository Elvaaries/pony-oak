extends Control

@onready var sphere: Sprite2D = $MarginContainer/VBoxContainer/SpherePreview
@onready var body_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/BodyBox/BodyPicker
@onready var shadow_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/ShadowBox/ShadowPicker
@onready var highlight_picker: ColorPickerButton = $MarginContainer/VBoxContainer/ColorBox/HighlightBox/HighlightPicker
@onready var save_dialog: AcceptDialog = $SaveDialog

var last_code: String = ""

func _ready() -> void:
	var mat = sphere.material as ShaderMaterial
	body_picker.color = mat.get_shader_parameter("base_color")
	shadow_picker.color = mat.get_shader_parameter("shadow_color")
	highlight_picker.color = mat.get_shader_parameter("highlight_color")
	
	body_picker.color_changed.connect(func(c): mat.set_shader_parameter("base_color", c))
	shadow_picker.color_changed.connect(func(c): mat.set_shader_parameter("shadow_color", c))
	highlight_picker.color_changed.connect(func(c): mat.set_shader_parameter("highlight_color", c))
	
	save_dialog.confirmed.connect(_on_save_dialog_confirmed)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_button_pressed() -> void:
	var colors = {
		"body": body_picker.color.to_html(false),
		"shadow": shadow_picker.color.to_html(false),
		"highlight": highlight_picker.color.to_html(false)
	}
	
	var success = HorseData.add_horse(colors)
	
	if success:
		# Генерируем код
		var json = JSON.stringify(colors)
		last_code = Marshalls.utf8_to_base64(json)
		
		save_dialog.dialog_text = "Окрас сохранён в альбом!\n\nКод:\n" + last_code
		save_dialog.popup_centered()
	else:
		save_dialog.dialog_text = "Альбом полон!\nМаксимум 5 окрасов.\nУдалите старые в Альбоме."
		save_dialog.popup_centered()

func _on_save_dialog_confirmed() -> void:
	if last_code != "":
		DisplayServer.clipboard_set(last_code)
		print("Код скопирован в буфер обмена")
