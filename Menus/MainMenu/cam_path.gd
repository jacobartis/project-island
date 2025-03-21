extends PathFollow3D

@onready var env = preload("res://Menus/MainMenu/main_menu.tres")

@onready var camera_3d = $Camera3D
@export var speed: float = 1
@onready var lookat = %Lookat
var total:float = 0

func _process(delta):
	total += delta*speed
	progress = total
	$Camera3D.look_at(lookat.global_position)
	%Lookat.progress_ratio = pingpong(total/500,1)
	%Light.rotation_degrees.x += delta*(speed/10.0)
	var rot = pingpong(%Light.rotation_degrees.x-90,180)/180
	env.background_energy_multiplier = max(rot,.25)
	%CityLights.visible = bool(rot<= .5)
