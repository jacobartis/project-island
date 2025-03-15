extends Area3D
class_name Interactable

signal show_highlight()
signal hide_highlight()
signal interacted()

@export var animation_name: String = "interact"

var highlight: bool = false :set=set_highlight

func set_highlight(new:bool):
	if new == highlight: return
	highlight = new
	if highlight:
		show_highlight.emit()
	else:
		hide_highlight.emit()
