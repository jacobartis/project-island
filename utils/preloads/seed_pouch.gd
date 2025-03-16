extends Node


var crops: Dictionary ={
	0:preload("res://farming/crops/test_crop.tres")
}

func get_crop(id):
	return crops[id]
