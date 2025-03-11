extends Node

func _ready():
	State.start_dialogue.connect(unlock)
	State.end_dialogue.connect(lock)

func is_locked():
	return Input.mouse_mode != Input.MOUSE_MODE_VISIBLE

func lock():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func unlock():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
