extends Control

func _ready() -> void:
	# Можно потом добавить анимацию появления кнопок
	pass

func _on_create_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/horse_creator.tscn")

func _on_view_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/horse_viewer.tscn")
func _on_album_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/album.tscn")
