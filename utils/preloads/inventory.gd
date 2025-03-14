extends Node

signal inventory_update()
signal slot_updated(slot)

var inventory_size = 30

var inventory: Dictionary ={}

func _ready():
	for x in inventory_size:
		inventory[x] = null

func find_item(id):
	for x in inventory.keys():
		if not inventory[x]:
			continue
		if inventory[x].id == id:
			return x
	return -1

func find_empty():
	for x in inventory.keys():
		if not inventory[x]:
			return x
	return -1

func item_count(id):
	var count = 0
	for x in inventory.keys():
		if not inventory[x]:
			continue
		if inventory[x].id == id:
			count += inventory[x].stack
	return count

func get_item(slot):
	return inventory[slot]

func can_place_item(item:InventoryItem,pos:int):
	var curr_item = Inventory.get_item(pos)
	if not curr_item: return true
	return InventoryItem.can_stack(curr_item,item)

func can_add_item(item:InventoryItem):
	var invent_pos = Inventory.find_item(item.id)
	if invent_pos != -1:
		if InventoryItem.can_stack(Inventory.get_item(invent_pos),item):
			return true
	invent_pos = Inventory.find_empty()
	if invent_pos == -1:
		return false
	else:
		return true

func add_to_best(item:InventoryItem):
	var invent_pos = Inventory.find_item(item.id)
	if invent_pos != -1:
		if InventoryItem.can_stack(Inventory.get_item(invent_pos),item):
			return add_item(item,invent_pos)
	invent_pos = Inventory.find_empty()
	if invent_pos == -1:
		return 
	else:
		return add_item(item,invent_pos)

func add_item(item:InventoryItem,slot:int):
	if inventory[slot]:
		if InventoryItem.can_stack(inventory[slot],item):
			inventory[slot].stack += item.stack
		return
	inventory[slot] = item
	inventory_update.emit()
	slot_updated.emit(slot)
	print_status()

func move_item(a:int, b:int):
	if not a in inventory or not b in inventory: return
	var a_temp = inventory[a]
	inventory[a] = inventory[b]
	inventory[b] = a_temp
	slot_updated.emit(a)
	slot_updated.emit(b)

func remove_item_quant(id,quant):
	var slots = []
	for x in inventory.keys():
		if not inventory[x]:
			continue
		if inventory[x].id == id:
			var sub = min(inventory[x].stack,quant)
			print(inventory[x].stack," ",quant)
			inventory[x].stack -= sub
			if inventory[x].stack == 0:
				inventory[x] = null
			slots.append(x)
			quant -= sub
	inventory_update.emit()
	for x in slots:
		slot_updated.emit(x)
	print_status()

func remove_item(pos:int):
	if not pos in inventory: return
	inventory[pos] = null
	slot_updated.emit(pos)

func print_status():
	for x in inventory.keys():
		if inventory[x]:
			print("{x}: {n}, {s}".format({"x":x,"n":inventory[x].get_item_info().item_name,"s":inventory[x].stack}))
		else:
			print("{x}: Empty".format({"x":x}))
