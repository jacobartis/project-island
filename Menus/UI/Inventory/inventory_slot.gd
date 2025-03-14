extends Control

signal clicked()
signal highlighted()
signal unhighlighted()
signal selected()
signal unselected()

var invent_slot: int = -1
var current_item:InventoryItem
var highlight: bool = false
var select: bool = false

@onready var stack = $Stack
@onready var ghost_icon = $Control/GhostIcon
@onready var icon = $Control/Icon

func set_slot(slot):
	invent_slot = slot
	update()

func set_highlight(val:bool):
	if highlight == val: return
	highlight = val
	if highlight:
		highlighted.emit()
	else:
		unhighlighted.emit()

func set_selected(val:bool):
	if select == val: return
	select = val
	if select:
		selected.emit()
	else:
		unselected.emit()

func update():
	var item = Inventory.get_item(invent_slot)
	if not item and current_item:
		clear()
		return
	elif not item:
		return
	reset_drag()
	display_item(item)

func clear():
	current_item = null
	stack.set_text("")
	icon.set_texture(null)
	ghost_icon.set_texture(null)

func display_item(item:InventoryItem):
	current_item = item
	var info = item.get_item_info()
	stack.set_text(str(item.stack))
	icon.set_texture(info.icon)
	ghost_icon.set_texture(info.icon)

func get_description():
	if not current_item:
		return ""
	else:
		return current_item.get_item_info().description

func drag():
	icon.global_position = get_global_mouse_position()

func reset_drag():
	icon.position = Vector2.ZERO

func _on_pickup_pressed():
	clicked.emit()
