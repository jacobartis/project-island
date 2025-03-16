extends Node

signal day_ended()

var day_number: int = 0

func end_day():
	day_number += 1
	day_ended.emit()
