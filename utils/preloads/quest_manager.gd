extends Node

signal quest_started(id)
signal quest_completed(id)

var quests: Dictionary = {
	0:preload("res://quests/quests/fishing.tres"),
	1:preload("res://quests/quests/talk.tres"),
}

var active_quests = []
var completed_quests = []

func is_quest(id):
	return id in quests

func is_active(quest_id):
	return quest_id in active_quests

func is_complete(quest_id):
	return quest_id in completed_quests

func get_quest(id):
	if not is_quest(id): return null
	return quests[id]

func _process(delta):
	for x in active_quests:
		check_complete(x)

func check_complete(quest_id):
	if get_quest(quest_id).is_complete():
		complete_quest(quest_id)

#Used to manage quests
func start_quest(quest_id):
	print(quest_id)
	if not is_quest(quest_id): return
	if is_active(quest_id) or is_complete(quest_id): return
	active_quests.append(quest_id)
	quest_started.emit(quest_id)

func complete_quest(quest_id):
	if not is_quest(quest_id): return
	if not is_active(quest_id): return
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	get_quest(quest_id).give_rewards()
	quest_completed.emit(quest_id)

func set_manual_req(quest_id:int,req_pos:int,status:bool):
	if not is_quest(quest_id): return
	if not is_active(quest_id): return
	get_quest(quest_id).set_manual_req(req_pos,status)
