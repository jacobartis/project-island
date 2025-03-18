extends HeldItem

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

func primary_use():
	if casted and nibble_avalible != 0:
		start_catch()
		nibble_avalible = 0
	elif casted:
		return_cast()
		nibble_avalible = 0 
	elif can_cast:
		hold_delay = .1

func _process(delta):
	handle_charge(delta)
	if casted:
		nibble_avalible = max(nibble_avalible-delta,0)
		if !bobber.water_bodies():
			$Nibble.stop()
		elif $Nibble.is_stopped() and bobber.water_bodies():
			$Nibble.start(randf_range(nibble_delay,nibble_delay*1.25))

func handle_charge(delta):
	hold_delay = max(hold_delay-delta,0)
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
	var item:InventoryItem = InventoryItem.new().create(fish_data.item_id)
	Inventory.add_to_best(item)
