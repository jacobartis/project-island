extends Node
class_name RequirementSetter

@export var quest_id:String
@export var req_id:String = ""
@export var status:bool = true

func set_manual_req():
	QuestManager.set_manual_req(quest_id,req_id,status)
