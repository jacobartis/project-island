extends Node

var items: Dictionary = {
	0:preload("res://items/fishing_rod/fishing_rod.tres"),
	1:preload("res://items/fish/fish.tres")
}

func is_item(id):
	return id in items

func get_item(id):
	if not is_item(id): return
	return items[id]
