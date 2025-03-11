extends Area3D


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.in_water = true
		body.water_height = global_position.y


func _on_body_exited(body):
	if body.is_in_group("player"):
		body.in_water = false
