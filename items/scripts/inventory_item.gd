extends Resource
class_name InventoryItem

var id: int
var stack:int = 1
var additional_info:Dictionary = {}

func create(id:int, stack:int=1,additional_info:Dictionary={}):
	self.id = id
	self.stack = stack
	for x in ItemDict.get_item(id).additional_info_keys:
		self.additional_info[x] = "default"
	self.additional_info = additional_info
	return self

func add_additional(key,data):
	additional_info[key] = data

func get_additional(key):
	if key in additional_info:
		return additional_info[key]
	else:
		push_warning("No key {k} in {s}".format({"k":key,"s":self}))
		return null

func get_item_info():
	return ItemDict.get_item(id)

static func can_stack(a:InventoryItem,b:InventoryItem):
	if not equal(a,b): return false
	return a.get_item_info().max_stack-a.stack>=b.stack

static func equal(a:InventoryItem,b:InventoryItem):
	return a.id == b.id and a.additional_info.values() == b.additional_info.values()
