extends Node

const MASTER_ABUS = 0
const SFX_ABUS = 1
const MUSIC_ABUS = 2

const MAX_SENSITIVITY = .01

var sensitivity:float = 0.01
var master_volume: float = 1: 
	set(val):
		master_volume = val
		AudioServer.set_bus_volume_linear(MASTER_ABUS,val)
var music_volume: float = 1:
	set(val):
		music_volume = val
		AudioServer.set_bus_volume_linear(MUSIC_ABUS,val)
var sfx_volume: float = 1:
	set(val):
		sfx_volume = val
		AudioServer.set_bus_volume_linear(SFX_ABUS,val)
