extends Resource
class_name Quest

@export var quest_name:String = "Placeholder"
@export_multiline var description:String = "Placeholder description"
@export var requirements:Dictionary[int,QuestRequirement] = {}
@export var rewards:Array[QuestReward] = []

func get_status():
	var status = []
	for x in requirements.values():
		status.append({"Status":x.get_status(),"Complete":x.is_complete()})
	return status

func is_complete():
	return requirements.values().all(func (x): return x.is_complete())

func set_manual_req(req_id,val):
	if not req_id in requirements: 
		push_warning("No such requirement {id} in {self}".format({"id":req_id,"self":self}))
		return 
	if not requirements[req_id] is ManualRequirement:
		push_warning("Requirement is not manual {id} in {self}".format({"id":req_id,"self":self}))
		return 
	requirements[req_id].set_complete(val)

func give_rewards():
	rewards.all(func (x):x.give())
