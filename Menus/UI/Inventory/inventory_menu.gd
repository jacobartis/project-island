extends Panel
const INVENTORY_SLOT = preload("res://Menus/UI/Inventory/inventory_slot.tscn")

@onready var slot_container = $SlotContainer
@export var shemp_counter:Label

var selected:int = -1
var drag: bool = false
var drag_time:float = 0
var hovered: int = -1

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
	
	if Input.is_action_pressed("l_click") and drag:
		slots[selected].drag()
		drag_time += delta
	elif Input.is_action_just_released("l_click") and drag:
		if drag_time>=.2 and hovered in slots:
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

func slot_unhovered(pos:int):
	if drag and pos == hovered:
		hovered = -1
