extends Marker2D
class_name ExitPoint2D

@export var id: int = 0

func _ready():
	add_to_group("ExitPoint")
