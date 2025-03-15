extends Camera3D

@export var follow_player: bool = true

func _ready():
	current = true

func _process(delta):
	var player = get_tree().get_first_node_in_group("player")
	if !player: return
	get_tree().get_first_node_in_group("player_cam").disable()
	if follow_player:
		look_at(player.global_position)
