extends Node3D
class_name BarMinigameItem

signal selected()
signal unselected()

@export var cam_pos:Marker3D
var bar_minigame:BarMinigame

func select():
	selected.emit()

func unselect():
	unselected.emit()
