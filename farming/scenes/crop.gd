extends Node3D
class_name Crop

@export var crop_data: CropData

@export var days_grown: int = 0
## Dictionary of stage no. to stage node
@export var stage_nodes:Dictionary[int,CropStage] = {}

func get_stage():
	var total: int = 0
	var stage: int = 0
	for day in crop_data.stages:
		total += day
		if total > days_grown:
			return stage
		stage += 1
	#Stop overflow
	return stage-1

func _ready():
	DayManager.day_ended.connect(new_day)
	update_visuals()

func new_day():
	days_grown += 1
	update_visuals()

func update_visuals():
	for x in stage_nodes.keys():
		if x == get_stage(): continue
		stage_nodes[x].hide()
	stage_nodes[get_stage()].show()
