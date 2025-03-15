extends Node
class_name RequirementSetter

@export var quest_id:int
@export var req_pos:int = 0
@export var status:bool = true

func set_manual_req():
	QuestManager.set_manual_req(quest_id,req_pos,status)
