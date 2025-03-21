@tool
extends PathFollow3D

@onready var camera_3d = $Camera3D
@export var speed: float = 1
@onready var lookat = %Lookat

var total:float = 0

func _process(delta):
	total += delta*speed
	progress = total
	$Camera3D.look_at(lookat.global_position)
	%Lookat.progress_ratio = pingpong(total/500,1)
