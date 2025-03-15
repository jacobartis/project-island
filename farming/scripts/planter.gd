extends StaticBody3D

@export var seed_holder:Node3D

var farming: bool = false

func enter_farming_mode():
	get_tree().get_first_node_in_group("player_cam").disable()
	if get_tree().get_first_node_in_group("room_cam"):
		get_tree().get_first_node_in_group("room_cam").disable()
	get_tree().get_first_node_in_group("planter_ui").show()
	get_tree().get_first_node_in_group("planter_ui").current_planter = self
	$Camera3D.current = true
	State.in_menu = true
	$Highlight.hide()
	farming = true

func exit_farming_mode():
	get_tree().get_first_node_in_group("player_cam").enable()
	if get_tree().get_first_node_in_group("room_cam"):
		get_tree().get_first_node_in_group("room_cam").enable()
	get_tree().get_first_node_in_group("planter_ui").hide()
	State.in_menu = false
	$Highlight.show()
	farming = false

func plant_seed(seed:Crop):
	pass

func toggle_farming_mode():
	print(farming)
	if farming:
		exit_farming_mode()
	else:
		enter_farming_mode()
