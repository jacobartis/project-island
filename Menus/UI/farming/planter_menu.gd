extends Control

const SEED_UI_ENTRY = preload("res://Menus/UI/farming/seed_ui_entry.tscn")

@export var seed_container: VBoxContainer
var current_planter:Node3D = null


func plant(id):
	if !current_planter: return
	var crop_data = SeedPouch.get_crop(id)
	current_planter.plant(crop_data)

func display():
	show()
	update()
	Mouse.unlock()
	State.in_menu = true

func _on_hidden():
	Mouse.lock()
	State.in_menu = false


func update():
	for x in seed_container.get_children():
		x.queue_free()
	for id in SeedPouch.crops.keys():
		var entry = SEED_UI_ENTRY.instantiate()
		entry.set_seed(id)
		seed_container.add_child(entry)
		entry.pressed.connect(plant.bind(id))
	print(seed_container.get_children())
