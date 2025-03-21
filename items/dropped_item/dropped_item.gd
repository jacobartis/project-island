extends Node3D

@export var item: InventoryItem

func _on_interactable_interacted():
	if not item: return
	if not Inventory.can_add_item(item): return
	Inventory.add_to_best(item)
	queue_free()

func _process(delta):
	%TextHolder.global_position = global_position

func _on_interactable_show_highlight():
	
	if !item:
		%Text.text = ""
		return
	var item_name = item.get_item_info().item_name
	%Text.text = "{n} X{quant}".format({"n":item_name,"quant":item.stack})
