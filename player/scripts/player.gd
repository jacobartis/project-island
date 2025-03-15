extends CharacterBody3D

@export var mesh: Node3D
@export var hand:Node3D 
@export var head:Node3D
@export var animation_player: AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var last_move_dir := Vector3.BACK
var rot_speed: float = 10

var in_water:bool = false
var water_height:float = 0

func _ready():
	Mouse.lock()
	Inventory.slot_updated.connect(check_slot)
	equip(current)

func _physics_process(delta):
	# Add the gravity.
	if in_water:
		velocity += get_gravity() * delta* (water_height-global_position.y)*0.1
	elif not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and State.can_act():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var raw_input = Input.get_vector("left", "right", "forward", "backward")
	if not State.can_act():
		raw_input = Vector2.ZERO
	var cam = get_viewport().get_camera_3d()
	var forward = cam.global_basis.z
	var right = cam.global_basis.x
	var direction = forward*raw_input.y + right*raw_input.x
	direction.y = 0
	direction = direction.normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if direction:
		animation_player.play("Walking")
	move_and_slide()
	if direction.length()>.2:
		last_move_dir = direction
	var target_angle = Vector3.BACK.signed_angle_to(last_move_dir,Vector3.UP)
	mesh.global_rotation.y = lerp_angle(mesh.global_rotation.y,target_angle,rot_speed*delta)

#Very temp
var current = 0

func _process(delta):
	if Input.is_action_just_pressed("next_item"):
		current = posmod(current+1,Inventory.inventory_size)
		equip(current)
	elif Input.is_action_just_pressed("prev_item"):
		current = posmod(current-1,Inventory.inventory_size)
		equip(current)

func check_slot(id):
	if id == current:
		equip(current)

func equip(slot):
	var item = Inventory.get_item(slot)
	if not item: 
		hand.unequip()
		return
	hand.equip(item.get_item_info().scene)

func give_hat(hat:Hat):
	head.top_hat().attach_hat(hat)
	hat.owner = self
