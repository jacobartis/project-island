extends Control
@onready var msg_storage = $MsgStorage

const QUEST_DISPLAY = preload("res://Menus/UI/QuestLog/quest_display.tscn")

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
	msg_storage.get_children().all(func (x):x.queue_free())
	for id in QuestManager.active_quests:
		var disp = QUEST_DISPLAY.instantiate()
		var quest = QuestManager.get_quest(id)
		disp.display_quest(quest)
		msg_storage.add_child(disp)
