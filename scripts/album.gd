extends Control

@onready var color_rects: Array[ColorRect] = [
	$VBoxContainer/HorsesContainer/Horse0/ColorRect0,
	$VBoxContainer/HorsesContainer/Horse1/ColorRect1,
	$VBoxContainer/HorsesContainer/Horse2/ColorRect2,
	$VBoxContainer/HorsesContainer/Horse3/ColorRect3,
	$VBoxContainer/HorsesContainer/Horse4/ColorRect4
]

func _ready() -> void:
	# Обновляем отображение сохраненных окрасов
	update_display()

func update_display() -> void:
	var saved_horses = HorseData.get_all_horses()
	
	print("Сохраненных окрасов: ", saved_horses.size())
	
	# Обновляем каждую позицию в альбоме
	for i in range(5):
		if i < saved_horses.size():
			# Есть сохраненный окрас, применяем его
			var colors = saved_horses[i]
			apply_colors(color_rects[i], colors)
			print("Слот ", i, ": применен окрас")
		else:
			# Нет окраса, оставляем дефолтный цвет
			color_rects[i].color = Color(0.7, 0.7, 0.7, 1)
			print("Слот ", i, ": пусто")

func apply_colors(color_rect: ColorRect, colors: Dictionary) -> void:
	if colors.has("body"):
		color_rect.color = Color(colors["body"])
	else:
		color_rect.color = Color(0.5, 0.5, 0.5, 1)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
