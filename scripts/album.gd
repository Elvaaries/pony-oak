extends Control

@onready var grid_container: GridContainer = $GridContainer
@onready var horses: Array[Sprite2D] = [
	$GridContainer/Horse0,
	$GridContainer/Horse1,
	$GridContainer/Horse2,
	$GridContainer/Horse3,
	$GridContainer/Horse4
]

func _ready() -> void:
	# Обновляем отображение сохраненных окрасов
	update_display()

func update_display() -> void:
	var saved_horses = HorseData.get_all_horses()
	
	# Обновляем каждую позицию в альбоме
	for i in range(5):
		if i < saved_horses.size():
			# Есть сохраненный окрас, применяем его
			var colors = saved_horses[i]
			apply_colors(horses[i], colors)
		else:
			# Нет окраса, оставляем дефолтный цвет
			var mat = horses[i].material as ShaderMaterial
			if mat:
				# Светло-серый цвет для пустого слота
				mat.set_shader_parameter("base_color", Color(0.7, 0.7, 0.7, 1))
				mat.set_shader_parameter("shadow_color", Color(0.4, 0.4, 0.4, 1))
				mat.set_shader_parameter("highlight_color", Color(0.9, 0.9, 0.9, 1))

func apply_colors(sprite: Sprite2D, colors: Dictionary) -> void:
	var mat = sprite.material as ShaderMaterial
	if mat == null:
		return
	
	if colors.has("body"):
		mat.set_shader_parameter("base_color", Color(colors["body"]))
	if colors.has("shadow"):
		mat.set_shader_parameter("shadow_color", Color(colors["shadow"]))
	if colors.has("highlight"):
		mat.set_shader_parameter("highlight_color", Color(colors["highlight"]))

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
