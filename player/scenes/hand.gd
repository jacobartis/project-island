extends Node3D

var current

func equip(packed:PackedScene):
	if current:
		unequip()
	var scene = packed.instantiate()
	add_child(scene)
	scene.global_transform = global_transform
	current = scene

func unequip():
	if not current: return
	current.queue_free()
	current = null
