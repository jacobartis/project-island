extends QuestRequirement
class_name ManualRequirement
#Type of requirement toggled by a flag, explicit somewhere else (eg in dialogue)
@export var description: String = "Description here"
var complete: bool = false

func is_complete():
	return complete

func get_status()-> String:
	return description

func get_completed() -> String:
	return description

func set_complete(val:bool):
	complete = val
