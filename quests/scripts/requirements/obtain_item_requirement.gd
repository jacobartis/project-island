extends QuestRequirement
class_name ObtainItemRequirement

@export var item_id: int = 0
@export var quant: int = 1
var complete: bool = false

func is_complete():
	if Inventory.item_count(item_id)>=quant:
		complete = true
	return complete

func get_status()-> String:
	return "Collect {IName}: {curr}/{req}".format({"IName":ItemDict.get_item(item_id).item_name,
			"curr":min(Inventory.item_count(item_id),quant),"req":quant})

func get_completed() ->String:
	return "Collect {IName}: {curr}/{req}".format({"IName":ItemDict.get_item(item_id).item_name,
			"curr":quant,"req":quant})
