extends StaticBody3D

@export var crop_holder:Node3D

var current_crop: Crop = null
var farming: bool = false

func enter_farming_mode():
	get_tree().get_first_node_in_group("player_cam").disable()
	if get_tree().get_first_node_in_group("room_cam"):
		get_tree().get_first_node_in_group("room_cam").disable()
	get_tree().get_first_node_in_group("planter_ui").display()
	get_tree().get_first_node_in_group("planter_ui").current_planter = self
	$Camera3D.current = true
	$Highlight.hide()
	farming = true

func exit_farming_mode():
	get_tree().get_first_node_in_group("player_cam").enable()
	if get_tree().get_first_node_in_group("room_cam"):
		get_tree().get_first_node_in_group("room_cam").enable()
	get_tree().get_first_node_in_group("planter_ui").hide()
	$Highlight.show()
	farming = false

func plant(crop_data:CropEntry):
	if current_crop:
		remove_current()
	var crop = crop_data.scene.instantiate()
	crop_holder.add_child(crop)
	current_crop = crop
	crop.owner = self

func remove_current():
	current_crop.queue_free()
	current_crop = null

func toggle_farming_mode():
	print(farming)
	if farming:
		exit_farming_mode()
	else:
		enter_farming_mode()
