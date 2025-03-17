extends Control

@export var q_name:Label
@export var description:Label
@export var status_con:VBoxContainer

func display_quest(id:String):
	var quest = QuestManager.get_quest(id)
	q_name.set_text(quest.quest_name)
	description.set_text(quest.description)
	if not QuestManager.is_complete(id):
		for req in quest.get_status():
			var label = Label.new()
			label.set_text(req["Status"])
			if req["Complete"]:
				label.self_modulate = Color.GREEN
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.label_settings = preload("res://Menus/UI/QuestLog/description_label.tres")
			status_con.add_child(label)
	else:
		q_name.self_modulate = Color.GREEN
		description.self_modulate = Color.GREEN
		for msg in quest.get_completed_text():
			var label = Label.new()
			label.set_text(msg)
			label.self_modulate = Color.GREEN
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.label_settings = preload("res://Menus/UI/QuestLog/description_label.tres")
			status_con.add_child(label)
