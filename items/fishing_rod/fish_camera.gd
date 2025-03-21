extends Node3D

@onready var cam = $SpringArm3D/FishCamera
@export var bobber:RigidBody3D

var limit = deg_to_rad(75)

func _physics_process(delta):
	global_position = bobber.global_position

func disable():
	cam.current = false

func enable():
	cam.current = true

func _input(event):
	move_cam(event as InputEventMouseMotion)

func move_cam(event:InputEventMouseMotion):
	if !event or not State.can_act(): return
	var y = event.relative.y
	var x = event.relative.x
	rotation.x -= y*Options.sensitivity
	rotation.x = clampf(rotation.x,-limit, limit)
	rotation.y  -= x*Options.sensitivity


func _on_fishing_rod_cast():
	get_tree().get_first_node_in_group("player_cam").disable()
	enable()


func _on_fishing_rod_pull_back():
	get_tree().get_first_node_in_group("player_cam").enable()
	disable()
