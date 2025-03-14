extends Resource
class_name QuestRequirement

func is_complete():
	return true

func get_status()-> String:
	return "Override please"

func get_completed() -> String:
	return "This is finished"
