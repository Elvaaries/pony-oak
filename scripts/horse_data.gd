extends Node

const SAVE_PATH = "user://horses.save"
## Максимум сохраненных окрасов
const MAX_HORSES = 5

## Массив сохраненных окрасов
var horses: Array = []

func _ready() -> void:
	load_horses()

func save_horses() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(horses))
	file.close()

func load_horses() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data is Array:
			horses = data
	else:
		horses = []

## Добавить новый окрас в альбом
func add_horse(colors: Dictionary) -> bool:
	if horses.size() >= MAX_HORSES:
		return false
	
	horses.append(colors)
	save_horses()
	return true

## Получить окрас по индексу
func get_horse(index: int) -> Dictionary:
	if index < 0 or index >= horses.size():
		return {}
	return horses[index]

## Получить все сохраненные окрасы
func get_all_horses() -> Array:
	return horses

## Очистить альбом
func clear_all() -> void:
	horses = []
	save_horses()

## Удалить окрас по индексу
func remove_horse(index: int) -> bool:
	if index < 0 or index >= horses.size():
		return false
	horses.remove_at(index)
	save_horses()
	return true
