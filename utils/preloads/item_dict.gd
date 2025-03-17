extends Node

@export var list_resource:ItemListResource = preload("res://items/game_item_list.tres")

func is_item(id):
	return id in list_resource.item_list

func get_item(id):
	if not is_item(id): return
	return list_resource.item_list[id]
