extends QuestRequirement
class_name ItemRequirement

@export var item_id: int = 0
@export var quant: int = 1

func is_complete():
	return Inventory.item_count(item_id)>=quant

func get_status()-> String:
	return "Collect {IName}: {curr}/{req}".format({"IName":ItemDict.get_item(item_id).item_name,
			"curr":Inventory.item_count(item_id),"req":quant})
