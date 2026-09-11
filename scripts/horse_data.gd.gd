extends Node

const SAVE_PATH = "user://horses.save"
const MAX_HORSES = 5

var horses: Array = []		# массив словарей с окрасами

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

func add_horse(colors: Dictionary) -> bool:
	if horses.size() >= MAX_HORSES:
		return false		# альбом полон
	
	horses.append(colors)
	save_horses()
	return true

func delete_horse(index: int) -> void:
	if index >= 0 and index < horses.size():
		horses.remove_at(index)
		save_horses()
