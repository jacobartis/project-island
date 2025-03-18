extends Area3D

var objects = []

var closest: Interactable = null : set=set_closest
var build_mode: bool = false

func set_closest(new:Interactable):
	if new == closest: return
	if closest:
		closest.highlight = false
	if new:
		new.highlight = true
	closest = new

func _process(delta):
	if Input.is_action_just_pressed("enter_build_mode"):
		toggle_build_mode()
	check_closest()
	if Input.is_action_just_pressed("interact") and closest and !State.in_dialogue:
		closest.interacted.emit()

func check_closest():
	if objects.is_empty():
		closest = null
		return
	objects.sort_custom(sort_dist)
	closest = objects[0]

func sort_dist(a,b):
	return global_position.distance_to(a.global_position)>global_position.distance_to(b.global_position)

func _on_area_entered(area):
	if not area is Interactable: return
	objects.append(area)

func toggle_build_mode():
	build_mode = !build_mode
	if build_mode:
		collision_mask = 2
	else:
		collision_mask = 1
	check_closest()

func _on_area_exited(area):
	if objects.has(area):
		objects.erase(area)
