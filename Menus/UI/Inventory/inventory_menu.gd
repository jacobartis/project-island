extends Panel
const INVENTORY_SLOT = preload("res://Menus/UI/Inventory/inventory_slot.tscn")
const DROPPED_ITEM = preload("res://items/dropped_item/dropped_item.tscn")

@onready var slot_container = $SlotContainer
@export var shemp_counter:Label
@export var description: Control

var selected:int = -1
var drag: bool = false
var drag_time:float = 0
var hovered: int = -1
var hover_drop: bool = false

var slots = {}

func _ready():
	for x in Inventory.inventory_size:
		var slot = INVENTORY_SLOT.instantiate()
		slots[x] = slot
		slot.set_slot(x)
		slot_container.add_child(slot)
		slot.clicked.connect(slot_clicked.bind(x))
		slot.mouse_entered.connect(slot_hovered.bind(x))
		slot.mouse_exited.connect(slot_unhovered.bind(x))

func _process(delta):
	check_selected()
	if State.in_dialogue: return
	if State.in_menu and !visible: return
	if Input.is_action_just_pressed("toggle_inventory"):
		visible = !visible
		if visible:
			Mouse.unlock()
		else:
			Mouse.lock()
		State.in_menu = visible
		update()
	
	description.global_position = get_global_mouse_position()-description.size/2+Vector2(0,description.size.y)
	
	if Input.is_action_pressed("use_primary") and drag:
		slots[selected].drag()
		description.hide()
		drag_time += delta
	elif Input.is_action_just_released("use_primary") and drag:
		if hover_drop:
			var dropped = DROPPED_ITEM.instantiate()
			dropped.item = Inventory.get_item(selected)
			Inventory.remove_item(selected)
			get_tree().current_scene.add_child(dropped)
			dropped.owner = get_tree().current_scene
			dropped.global_position = get_tree().get_first_node_in_group("player").global_position
		if drag_time>=.2 and hovered in slots:
			description.show_item(slots[selected])
			if Inventory.can_place_item(Inventory.get_item(selected),hovered):
				var item = Inventory.get_item(selected)
				Inventory.remove_item(selected)
				Inventory.add_item(item,hovered)
				slot_clicked(hovered)
			else:
				Inventory.move_item(selected,hovered)
				slot_clicked(hovered)
		
		drag = false
		drag_time = 0
		slots[selected].reset_drag()
		description.update_display()
		update()

func update():
	for x in slots.values():
		x.update()
	shemp_counter.set_text("Shemps: {s}".format({"s":Inventory.shmeppins}))

func check_selected():
	var player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	var selected = player.current
	for x in slots:
		if x == selected: continue
		slots[x].set_selected(false)
	slots[selected].set_selected(true)

func slot_clicked(pos:int):
	if selected in slots:
		slots[selected].set_highlight(false)
	selected = pos
	slots[selected].set_highlight(true)
	
	drag = true

func slot_hovered(pos:int):
	if drag:
		hovered = pos
	description.show_item(slots[pos])

func slot_unhovered(pos:int):
	if drag and pos == hovered:
		hovered = -1
	description.hide_item(slots[pos])

func _on_drop_mouse_entered():
	hover_drop = true

func _on_drop_mouse_exited():
	hover_drop = false
