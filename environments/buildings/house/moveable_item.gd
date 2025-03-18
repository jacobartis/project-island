extends Node3D
class_name MoveableItem

signal move_start()
signal move_end()

signal is_valid()
signal is_invalid()

@export var move_highlight:Node3D = null
@export var move_validator:Area3D = null
@export var valid_node:Node3D = null 
@export var invalid_node:Node3D = null

var move_active: bool = false

var valid:bool = true

func _process(delta):
	var ray: RayCast3D = get_tree().get_first_node_in_group("move_ray")
	if move_active and Input.is_action_just_pressed("interact"):
		stop_move()
	if move_active and Input.is_action_just_pressed("rotate_cw"):
		rotate_item(1)
	if move_active and Input.is_action_just_pressed("rotate_ccw"):
		rotate_item(-1)
	if !move_active: return
	if not ray:
		stop_move()
		return
	var target_pos = Vector3.ZERO
	if ray.is_colliding():
		target_pos = ray.get_collision_point()
	else:
		target_pos = ray.global_position+ray.target_position
	move_highlight.global_position = lerp(move_highlight.global_position,target_pos,.5)
	
	if validate_move() != valid:
		if validate_move():
			is_valid.emit()
			valid_node.show()
			invalid_node.hide()
		else:
			is_invalid.emit()
			valid_node.hide()
			invalid_node.show()
	valid = validate_move()

func start_move():
	move_highlight.show()
	move_start.emit()
	move_active = true
	if validate_move():
		is_valid.emit()
		valid_node.show()
		invalid_node.hide()
	else:
		is_invalid.emit()
		valid_node.hide()
		invalid_node.show()

func validate_move():
	if not move_validator.get_overlapping_bodies().is_empty(): return false
	if move_validator.get_overlapping_areas().filter(func(area):return area.is_in_group("buildable")).is_empty(): return false
	return true

func stop_move():
	move_end.emit()
	if validate_move():
		global_transform = move_highlight.global_transform
	move_highlight.hide()
	move_active = false
	move_highlight.position = Vector3.ZERO

func rotate_item(dir):
	move_highlight.rotate(Vector3.UP,deg_to_rad(90*dir))
