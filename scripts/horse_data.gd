extends Node

const SAVE_PATH = "user://horses.save"
const PREVIEWS_DIR = "user://horse_previews/"
const SPOTS_DIR = "user://horse_spots/"
const MAX_HORSES = 5

var horses: Array = []
var selected_horse = null   # для передачи в создатель / просмотр

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(PREVIEWS_DIR)
	DirAccess.make_dir_recursive_absolute(SPOTS_DIR)
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

func add_horse(colors: Dictionary, preview_image: Image = null, spots_image: Image = null) -> bool:
	if horses.size() >= MAX_HORSES:
		return false
	
	var index = horses.size()
	
	if preview_image:
		var preview_name = str(index) + ".png"
		preview_image.save_png(PREVIEWS_DIR + preview_name)
		colors["preview"] = preview_name
	
	if spots_image:
		var spots_name = str(index) + "_spots.png"
		spots_image.save_png(SPOTS_DIR + spots_name)
		colors["spots"] = spots_name
	
	if not colors.has("name") or colors["name"].strip_edges() == "":
		colors["name"] = "Окрас " + str(index + 1)
	
	horses.append(colors)
	save_horses()
	return true

func get_horse(index: int) -> Dictionary:
	if index < 0 or index >= horses.size():
		return {}
	return horses[index]

func get_all_horses() -> Array:
	return horses

func get_preview_path(index: int) -> String:
	if index < 0 or index >= horses.size():
		return ""
	var horse = horses[index]
	if horse.has("preview"):
		return PREVIEWS_DIR + horse["preview"]
	return ""

func get_spots_path(index: int) -> String:
	if index < 0 or index >= horses.size():
		return ""
	var horse = horses[index]
	if horse.has("spots"):
		return SPOTS_DIR + horse["spots"]
	return ""

func remove_horse(index: int) -> bool:
	if index < 0 or index >= horses.size():
		return false
	
	# Удаляем файлы
	var p = get_preview_path(index)
	if p != "" and FileAccess.file_exists(p):
		DirAccess.remove_absolute(p)
	var s = get_spots_path(index)
	if s != "" and FileAccess.file_exists(s):
		DirAccess.remove_absolute(s)
	
	horses.remove_at(index)
	
	# Переименовываем оставшиеся файлы
	for i in range(index, horses.size()):
		var h = horses[i]
		if h.has("preview"):
			var old_p = PREVIEWS_DIR + h["preview"]
			var new_name = str(i) + ".png"
			if FileAccess.file_exists(old_p):
				DirAccess.rename_absolute(old_p, PREVIEWS_DIR + new_name)
			h["preview"] = new_name
		if h.has("spots"):
			var old_s = SPOTS_DIR + h["spots"]
			var new_s = str(i) + "_spots.png"
			if FileAccess.file_exists(old_s):
				DirAccess.rename_absolute(old_s, SPOTS_DIR + new_s)
			h["spots"] = new_s
	
	save_horses()
	return true
