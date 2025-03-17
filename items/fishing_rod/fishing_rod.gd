extends Node3D

signal cast()
signal pull_back()
signal catch()

@onready var anim_t = $AnimationTree
@onready var bobber = $CastHolder/Bobber

var casted: bool = false
var can_cast: bool = true

@export_category("Charge")
@export var max_charge: float = 10
@export var charge_speed: float = 5
@export var charge_power: float = 1
@export var power_ratio: Vector2 = Vector2(2,1)
var hold_delay: float = 0
var charge: float = 0
var raw: float = 0

@export_category("Fish")
@export var nibble_delay:float = 5
@export var nibble_window:float = 1
@export var fishing_bonus:float = 0
var nibble_avalible: float = 0

func _process(delta):
	
	
	if not State.can_act():
		return
	
	if !casted and can_cast and !State.in_dialogue:
		handle_charge(delta)
	
	if casted and Input.is_action_just_pressed("use") and nibble_avalible != 0:
		start_catch()
		nibble_avalible = 0
	elif casted and Input.is_action_just_pressed("use"):
		return_cast()
		nibble_avalible = 0 
	
	if casted:
		nibble_avalible = max(nibble_avalible-delta,0)
		if !bobber.water_bodies():
			$Nibble.stop()
		elif $Nibble.is_stopped() and bobber.water_bodies():
			$Nibble.start(randf_range(nibble_delay,nibble_delay*1.25))

func handle_charge(delta):
	hold_delay = max(hold_delay-delta,0)
	if Input.is_action_pressed("use"):
		hold_delay = .1
	if hold_delay>0:
		raw = raw+delta*charge_speed
		charge = pingpong(raw,max_charge)
	elif hold_delay == 0 and raw!=0:
		throw_cast(charge*charge_power)
		raw = 0
		charge = 0
	anim_t.set("parameters/blend_position",charge/max_charge)

func throw_cast(power):
	cast.emit()
	casted = true
	bobber.freeze = false
	bobber.linear_velocity = Vector3.ZERO
	bobber.global_position = global_position
	#Distribution of virtical and horizontal power
	var pow_dist = power_ratio.normalized()
	var h_pow = -global_basis.z*pow_dist.x*power
	var v_pow = global_basis.y*pow_dist.y*power
	bobber.apply_impulse(h_pow+v_pow)

func start_catch():
	catch.emit()
	return_cast()

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

func _on_nibble_timeout():
	nibble_avalible = nibble_window
	if bobber.water_bodies():
		$Nibble.start(randf_range(nibble_delay,nibble_delay*1.25))

#TEMP TODO
func _on_catch():
	State.fish = "Caught"
	var water = bobber.get_water()
	var fish_data:FishData = water.get_fish(fishing_bonus)
	var fish = fish_data.fish_scene.instantiate()
	get_tree().get_current_scene().add_child(fish)
	fish.global_position = global_position
