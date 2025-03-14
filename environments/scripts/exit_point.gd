extends Marker3D
class_name ExitPoint

@export var id: int = 0

func _ready():
	add_to_group("ExitPoint")
