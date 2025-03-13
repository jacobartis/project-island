extends Node
class_name Pickup

signal picked_up()

@export var item_id:int = 0
@export var stack:int = 1
@export var additional_info:Dictionary

func pickup():
	if not ItemDict.is_item(item_id):
		push_warning("No such item id {id}".format({"id":item_id}))
		return
	var item = InventoryItem.new().create(item_id,stack,additional_info)
	if Inventory.can_add_item(item):
		Inventory.add_to_best(item)
		picked_up.emit()
