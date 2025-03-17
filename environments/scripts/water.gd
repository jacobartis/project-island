extends Area3D
class_name Water

@export var fish_table:FishingTable

func can_fish():
	return fish_table != null

func get_fish(bonus):
	return fish_table.get_fish(bonus)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.in_water = true
		body.water_height = global_position.y


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.in_water = false
