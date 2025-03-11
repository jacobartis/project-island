extends RigidBody3D

@onready var water_detector: Area3D = $WaterDetector

@export var float_force:= 1


func _process(delta):
	var water = water_bodies()
	if !water: return

func _physics_process(delta):
	if !water_bodies(): return
	var wat = water_bodies()[0]
	var depth = wat.global_position.y - global_position.y
	var force = Vector3.DOWN*float_force*get_gravity()*depth*.9-get_gravity()
	print(force)
	apply_central_force(force)

func _integrate_forces(state):
	if !water_bodies(): return
	state.linear_velocity *= 1-0.05
	state.angular_velocity *= 1-0.05

#Replace this with get avalible fish later (dont need the area specificaly)
func water_bodies():
	return water_detector.get_overlapping_areas().filter(func(x): return x.is_in_group("fishable"))
