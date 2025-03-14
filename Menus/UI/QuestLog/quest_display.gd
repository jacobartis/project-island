extends Control

func display_quest(quest:Quest):
	$QName.set_text(quest.quest_name)
	$Desc.set_text(quest.description)
	for req in quest.get_status():
		var label = Label.new()
		label.set_text(req["Status"])
		if req["Complete"]:
			label.self_modulate = Color.GREEN
		$Status.add_child(label)
	print(quest.is_complete())
	$Complete.visible = quest.is_complete()
