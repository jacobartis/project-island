extends Node3D

@export var source:Node3D
@export var bobber:Node3D
@onready var cable:MeshInstance3D = $cable

func _process(delta):
	global_position = (source.global_position+bobber.global_position)/2
	cable.mesh.height = source.global_position.distance_to(bobber.global_position)
	look_at(source.global_position)
