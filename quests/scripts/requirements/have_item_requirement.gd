extends QuestRequirement
class_name HaveItemRequirement

@export var item_id: int = 0
@export var quant: int = 1

func is_complete():
	return Inventory.item_count(item_id)>=quant

func get_status()-> String:
	return "Have {IName}: {curr}/{req}".format({"IName":ItemDict.get_item(item_id).item_name,
			"curr":min(Inventory.item_count(item_id),quant),"req":quant})

func get_completed() ->String:
	return "Have {IName}: {curr}/{req}".format({"IName":ItemDict.get_item(item_id).item_name,
			"curr":quant,"req":quant})
