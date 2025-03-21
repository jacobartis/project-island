extends Control

func _on_music_slider_value_changed(value):
	Options.music_volume = value/100.0

func _on_master_slider_value_changed(value):
	Options.master_volume = value/100.0

func _on_sfx_slider_value_changed(value):
	Options.sfx_volume = value/100.0

func _on_sensitivity_slider_value_changed(value):
	Options.sensitivity = Options.MAX_SENSITIVITY*(value/100)
