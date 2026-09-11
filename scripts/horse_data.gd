extends Node

## Максимум сохраненных окрасов
const MAX_HORSES = 5

## Массив сохраненных окрасов
var horses: Array = []

func _ready() -> void:
	horses = []

## Добавить новый окрас в альбом
func add_horse(colors: Dictionary) -> bool:
	if horses.size() >= MAX_HORSES:
		return false
	
	horses.append(colors)
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

## Удалить окрас по индексу
func remove_horse(index: int) -> bool:
	if index < 0 or index >= horses.size():
		return false
	horses.remove_at(index)
	return true
