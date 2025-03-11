extends Area3D

var objects = []

var closest: Interactable = null : set=set_closest

func set_closest(new:Interactable):
	if new == closest: return
	if closest:
		closest.highlight = false
	if new:
		new.highlight = true
	closest = new

func _process(delta):
	check_closest()

func check_closest():
	if objects.is_empty():
		closest = null
		return
	objects.sort_custom(sort_dist)
	closest = objects[0]

func sort_dist(a,b):
	return global_position.distance_to(a.global_position)>global_position.distance_to(b.global_position)

func _on_area_entered(area):
	print(area)
	if not area is Interactable: return
	objects.append(area)


func _on_area_exited(area):
	if objects.has(area):
		objects.erase(area)
