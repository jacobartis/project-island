extends Node3D

signal  enter_first()
signal  exit_first()

@export var cam: Camera3D
@onready var spring_arm_3d = $SpringArm3D

@export var transition_speed: float = 1
@export var third_person_dist: float = 5
var third: bool = true
var sens: float = 0.01
var limit = deg_to_rad(75)

func _ready():
	enable()

func _input(event):
	move_cam(event as InputEventMouseMotion)

func disable():
	cam.current = false

func enable():
	cam.current = true

func _process(delta):
	if Input.is_action_just_pressed("first_person"):
		third = false
		enter_first.emit()
	elif Input.is_action_just_released("first_person"):
		third = true
		exit_first.emit()
	if not third:
		spring_arm_3d.spring_length = lerpf(spring_arm_3d.spring_length,.01,transition_speed)
	else:
		spring_arm_3d.spring_length = lerpf(spring_arm_3d.spring_length,third_person_dist,transition_speed)

func move_cam(event:InputEventMouseMotion):
	if !event or not State.can_act(): return
	var y = event.relative.y
	var x = event.relative.x
	rotation.x -= y*sens
	rotation.x = clampf(rotation.x,-limit, limit)
	rotation.y  -= x*sens

func set_third_person(val:bool):
	third = val
