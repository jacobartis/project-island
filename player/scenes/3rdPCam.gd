extends Node3D

@export var cam: Camera3D

var sens: float = 0.01
var limit = deg_to_rad(75)

func _input(event):
	move_cam(event as InputEventMouseMotion)

func move_cam(event:InputEventMouseMotion):
	if !event or not State.can_act(): return
	var y = event.relative.y
	var x = event.relative.x
	rotation.x -= y*sens
	rotation.x = clampf(rotation.x,-limit, limit)
	rotation.y  -= x*sens
