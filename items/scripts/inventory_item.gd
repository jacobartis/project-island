extends Resource
class_name InventoryItem

var id: String
var stack:int = 1
var additional_info:Dictionary[String,AdditionalItemData] = {}

func create(id:String, stack:int=1, init_add_info:Dictionary={}):
	self.id = id
	self.stack = stack
	self.additional_info = ItemDict.get_item(id).additional_info.duplicate(true)
	for x in init_add_info.keys():
		self.additional_info[x] = init_add_info[x]
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
	if not a and not b: return true
	if not a or not b: return false
	return a.id == b.id and a.additional_info.values() == b.additional_info.values()
