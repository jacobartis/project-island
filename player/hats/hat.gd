extends Node3D
class_name Hat

@onready var base = $Base
@onready var top = $Top

var next_hat: Hat

func offset():
	return base.global_position-global_position

func top_hat():
	if next_hat:
		return next_hat.top_hat()
	else:
		return self

func attach_hat(hat:Hat):
	add_child(hat)
	next_hat = hat
	hat.global_position = top.global_position-hat.offset()
