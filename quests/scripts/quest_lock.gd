extends Node
class_name QuestLock

signal passes()
signal fails()

@export var quest_id:int = 0
@export_enum("Requirement","Active","Complete","Active or Complete") var type: int = 0
@export var req_id:int = 0

func trigger():
	match type:
		0:
			check_req()
		1:
			check_active()
		2:
			check_complete()
		3:
			check_active_or_complete()

func check_req():
	if QuestManager.is_req_complete(quest_id,req_id):
		passes.emit()
		return
	fails.emit()

func check_active():
	if QuestManager.is_active(quest_id):
		passes.emit()
		return
	fails.emit()

func check_complete():
	if QuestManager.is_complete(quest_id):
		passes.emit()
		return
	fails.emit()

func check_active_or_complete():
	if QuestManager.is_complete(quest_id) or QuestManager.is_active(quest_id):
		passes.emit()
		return
	fails.emit()
