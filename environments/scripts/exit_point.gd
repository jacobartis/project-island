extends Marker3D
class_name ExitPoint

signal used()

@export var id: int = 0

func _ready():
	add_to_group("ExitPoint")
