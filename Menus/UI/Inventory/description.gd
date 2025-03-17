extends Control

@export var name_label:Label
@export var description:Label

var curr_slot = null

func show_item(slot):
	curr_slot = slot
	update_display()

func hide_item(slot):
	if curr_slot != slot: return
	curr_slot = null
	update_display()

func update_display():
	if not curr_slot:
		name_label.set_text("")
		description.set_text("")
		hide()
	elif curr_slot.current_item:
		var info:Item = curr_slot.current_item.get_item_info()
		name_label.set_text(info.item_name)
		description.set_text(info.description)
		show()
	else:
		name_label.set_text("")
		description.set_text("")
		hide()
