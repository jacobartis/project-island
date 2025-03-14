extends Camera3D

func _ready():
	current = true

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if !player: return
	get_tree().get_first_node_in_group("player_cam").disable()
	
	look_at(player.global_position)
