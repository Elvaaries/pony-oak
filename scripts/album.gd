extends Control

@onready var horses_list: VBoxContainer = $MarginContainer/VBoxContainer/HorsesList

func _ready() -> void:
	update_list()

func update_list() -> void:
	for child in horses_list.get_children():
		child.queue_free()
	
	if HorseData.horses.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Альбом пуст"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		horses_list.add_child(empty_label)
		return
	
	for i in HorseData.horses.size():
		var colors = HorseData.horses[i]
		
		var card = HBoxContainer.new()
		card.add_theme_constant_override("separation", 15)
		
		var number = Label.new()
		number.text = str(i + 1) + "."
		number.custom_minimum_size.x = 30
		card.add_child(number)
		
		var color_box = HBoxContainer.new()
		color_box.add_theme_constant_override("separation", 6)
		
		for key in ["body", "shadow", "highlight"]:
			var rect = ColorRect.new()
			rect.custom_minimum_size = Vector2(28, 28)
			rect.color = Color(colors[key])
			color_box.add_child(rect)
		
		card.add_child(color_box)
		
		var load_btn = Button.new()
		load_btn.text = "Загрузить"
		load_btn.pressed.connect(_on_load_pressed.bind(i))
		card.add_child(load_btn)
		
		var delete_btn = Button.new()
		delete_btn.text = "Удалить"
		delete_btn.pressed.connect(_on_delete_pressed.bind(i))
		card.add_child(delete_btn)
		
		horses_list.add_child(card)

func _on_load_pressed(index: int) -> void:
	HorseData.selected_horse = HorseData.horses[index]
	get_tree().change_scene_to_file("res://scenes/horse_viewer.tscn")

func _on_delete_pressed(index: int) -> void:
	HorseData.delete_horse(index)
	update_list()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
