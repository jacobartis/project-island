extends QuestRequirement
class_name HaveTagRequirement

@export var tag: String = ""
@export var quant: int = 1

func is_complete():
	return Inventory.count_tag(tag)>=quant

func get_status()-> String:
	return "Have {IName}: {curr}/{req}".format({"IName":tag,
			"curr":min(Inventory.count_tag(tag),quant),"req":quant})

func get_completed() ->String:
	return "Have {IName}: {curr}/{req}".format({"IName":tag,
			"curr":min(Inventory.count_tag(tag),quant),"req":quant})
