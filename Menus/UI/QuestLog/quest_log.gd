extends Control

const QUEST_DISPLAY = preload("res://Menus/UI/QuestLog/quest_display.tscn")

@export var active_storage:VBoxContainer
@export var complete_storage:VBoxContainer

func _process(delta):
	if State.in_dialogue: return
	if State.in_menu and !visible: return
	if Input.is_action_just_pressed("toggle_quest_log"):
		visible = !visible
		if visible:
			Mouse.unlock()
		else:
			Mouse.lock()
		State.in_menu = visible
		update()

func update():
	display_quest(active_storage,QuestManager.active_quests)
	display_quest(complete_storage,QuestManager.completed_quests)

func display_quest(con:VBoxContainer,quests:Array):
	con.get_children().all(func (x):x.queue_free())
	for id in quests:
		var disp = QUEST_DISPLAY.instantiate()
		var quest = QuestManager.get_quest(id)
		disp.display_quest(quest)
		con.add_child(disp)
