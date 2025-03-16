extends Node3D

func _on_interactable_interacted():
	DayManager.end_day()
	print("new day")
