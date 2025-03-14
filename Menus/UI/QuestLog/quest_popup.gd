extends Control


func _on_quest_listener_quest_completed(id):
	$QName.set_text(QuestManager.get_quest(id).quest_name)
	$QName.self_modulate = Color.GREEN
	$AnimationPlayer.play("fade")
	$Completed.play()

func _on_quest_listener_quest_started(id):
	$QName.set_text(QuestManager.get_quest(id).quest_name)
	$AnimationPlayer.play("fade")
	$Started.play()
