extends Control

@onready var horses_list = $MarginContainer/VBoxContainer/HorsesList

func _ready() -> void:
	if horses_list == null:
		push_error("Не найден HorsesList!")
		return
	update_display()

func update_display() -> void:
	for child in horses_list.get_children():
		child.queue_free()
	
	var saved = HorseData.get_all_horses()
	for i in range(saved.size()):
		horses_list.add_child(create_slot(i, saved[i]))

func create_slot(index: int, data: Dictionary) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(150, 210)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.22, 0.22, 0.25)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 6)
	panel.add_child(vbox)
	
	# Имя
	var name_label = Label.new()
	name_label.text = data.get("name", "Окрас " + str(index + 1))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(name_label)
	
	# Превью
	var preview = TextureRect.new()
	preview.custom_minimum_size = Vector2(110, 110)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	var path = HorseData.get_preview_path(index)
	if path != "" and FileAccess.file_exists(path):
		var img = Image.load_from_file(path)
		if img:
			preview.texture = ImageTexture.create_from_image(img)
	else:
		preview.modulate = Color(data.get("body", "#888888"))
	
	vbox.add_child(preview)
	
	# Кнопки
	var buttons = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 4)
	
	var edit_btn = Button.new()
	edit_btn.text = "Изм"
	edit_btn.custom_minimum_size = Vector2(40, 28)
	edit_btn.pressed.connect(_on_edit.bind(index))
	buttons.add_child(edit_btn)
	
	var view_btn = Button.new()
	view_btn.text = "Смотр"
	view_btn.custom_minimum_size = Vector2(50, 28)
	view_btn.pressed.connect(_on_view.bind(index))
	buttons.add_child(view_btn)
	
	var copy_btn = Button.new()
	copy_btn.text = "Код"
	copy_btn.custom_minimum_size = Vector2(40, 28)
	copy_btn.pressed.connect(_on_copy.bind(index))
	buttons.add_child(copy_btn)
	
	var del_btn = Button.new()
	del_btn.text = "✕"
	del_btn.custom_minimum_size = Vector2(32, 28)
	del_btn.pressed.connect(_on_delete.bind(index))
	buttons.add_child(del_btn)
	
	vbox.add_child(buttons)
	return panel

func _on_edit(index: int) -> void:
	HorseData.selected_horse = HorseData.get_horse(index)
	get_tree().change_scene_to_file("res://scenes/horse_creator.tscn")

func _on_view(index: int) -> void:
	HorseData.selected_horse = HorseData.get_horse(index)
	get_tree().change_scene_to_file("res://scenes/horse_viewer.tscn")

func _on_copy(index: int) -> void:
	var data = HorseData.get_horse(index)
	var code = Marshalls.utf8_to_base64(JSON.stringify(data))
	DisplayServer.clipboard_set(code)

func _on_delete(index: int) -> void:
	HorseData.remove_horse(index)
	update_display()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
