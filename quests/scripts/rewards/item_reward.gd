extends QuestReward
class_name ItemReward

@export var item_id: int = 0
@export var quant: int = 1
@export var additional_info: Dictionary

func give():
	if not ItemDict.is_item(item_id):
		push_warning("Invalid item at ",self)
		return
	var item = InventoryItem.new().create(item_id,quant,additional_info)
	if not Inventory.can_add_item(item):
		await Inventory.inventory_update
		give()
		return
	Inventory.add_to_best(item)
