extends Node
class_name DialogueSFXPlayer

##Speaking character.
@export var  character:String = ""
##Default audio player used.
@export var default_aud: AudioStreamPlayer3D
##For playing special audio based on tags
##Key is tag string, player is stream player used.
@export var tag_audio:Dictionary[String,AudioStreamPlayer3D] = {}

func _ready():
	DialogueManager.got_dialogue.connect(check_line)

func check_line(line:DialogueLine):
	print(line.character)
	print(line.tags)
	if line.character != character: return
	
	for x in line.tags:
		if x in tag_audio.keys():
			tag_audio[x].play()
			return
	default_aud.play()
