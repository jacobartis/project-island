extends Node3D

signal clicked()

@export var glass_volume:float = 100
@onready var liquid = $Glass/Liquid
var glass_height: float = .4
var fill: float = 0
var dirty: bool = false: set=set_dirty

func set_dirty(val:bool):
	dirty = val
	$Dirt.visible = dirty

func _ready():
	liquid.mesh = liquid.mesh.duplicate()
	$Dirt.visible = dirty

func is_selectable():
	return not $SelectBox/SelectBoxShape.disabled

func set_selectable(val:bool):
	$SelectBox/SelectBoxShape.disabled = !val

func get_score():
	return (fill/glass_volume)*100

func add_liquid(quant):
	if fill>0: liquid.show()
	fill = min(fill+quant,glass_volume)
	liquid.mesh.height = (fill/glass_volume)*glass_height
	liquid.position.y = (liquid.mesh.height-glass_height)/2


func _on_select_box_input_event(camera, event, event_position, normal, shape_idx):
	if not BarMinigame._is_click(event as InputEventMouseButton): return
	clicked.emit()
