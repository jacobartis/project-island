extends Node3D

signal cast()
signal pull_back()

@onready var bobber = $CastHolder/Bobber

var casted: bool = false
var can_cast: bool = true

var hold_delay: float = 0
@export var max_charge: float = 100
@export var charge_speed: float = 50
var charge: float = 0
var raw: float = 0

func _process(delta):
	
	if !casted and can_cast:
		handle_charge(delta)
	if casted and Input.is_action_just_pressed("use"):
		return_cast()

func handle_charge(delta):
	hold_delay = max(hold_delay-delta,0)
	if Input.is_action_pressed("use"):
		hold_delay = .1
	if hold_delay>0:
		raw = raw+delta*charge_speed
		charge = pingpong(raw,max_charge)
		print(charge)
	elif hold_delay == 0 and raw!=0:
		throw_cast(charge)
		raw = 0
		charge = 0

func throw_cast(power):
	cast.emit()
	casted = true
	bobber.freeze = false
	bobber.linear_velocity = Vector3.ZERO
	bobber.global_position = global_position
	#Distribution of virtical and horizontal power
	var pow_dist = Vector2(2,1).normalized()
	var h_pow = -global_basis.z*pow_dist.x*power
	var v_pow = global_basis.y*pow_dist.y*power
	bobber.apply_impulse(h_pow+v_pow)

func return_cast():
	casted = false
	can_cast = false
	bobber.freeze = true
	bobber.global_position = global_position
	bobber.linear_velocity = Vector3.ZERO
	pull_back.emit()
	$CastDelay.start()


func _on_cast_delay_timeout():
	can_cast = true
