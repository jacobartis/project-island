extends Node3D

var current:HeldItem

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

func _process(delta):
	if not State.can_act():
		return
	if !current: return
	if Input.is_action_pressed("use_primary"):
		current.primary_use()
	elif Input.is_action_pressed("use_secondary"):
		current.secondary_use()
