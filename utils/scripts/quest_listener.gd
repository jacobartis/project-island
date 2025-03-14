extends Node
class_name QuestListener
#Allows the quest manager to be listerned to within a scene

signal quest_started(id)
signal quest_completed(id)

func _ready():
	QuestManager.quest_started.connect(start)
	QuestManager.quest_completed.connect(comp)

func start(id):
	quest_started.emit(id)

func comp(id):
	quest_completed.emit(id)
