extends Camera3D
class_name FixedCamera

@export var follow_player: bool = true

var enabled: bool = true

func _ready():
	current = true
	enabled = true

func _process(delta):
	if !enabled: return
	var player = get_tree().get_first_node_in_group("player")
	if !player: return
	get_tree().get_first_node_in_group("player_cam").disable()
	if follow_player:
		look_at(player.global_position)

func enable():
	current = true
	enabled = true

func disable():
	current = false
	enabled = false
