extends Node2D

onready var anims = get_node("AnimationPlayer")
var entered = false

var state = "warning-specs"
# warning-specs
# warning-lights
# warning-parody
# exiting

export(Array, String, MULTILINE) var bbcode_texts = ["asd", "dsds"]

onready var text = get_node("Node2D/RichTextLabel")
onready var text_back = get_node("Node2D/back")

# Called when the node enters the scene tree for the first time.
func _ready():
	anims.play("enter")
	
	if(OS.get_name() == "Android"):
		change_state("warning-specs", false)
	else:
		change_state("warning-lights", false)

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_confirm")):
		match(state):
			"warning-specs":
				anims.play("push")
				change_state("warning-lights")
			"warning-lights":
				anims.play("exit")
				change_state("exiting")
			"warning-parody": # unused
				anims.play("exit")
				change_state("exiting")
			
	if(OS.is_debug_build() and Input.is_action_pressed("ui_up") and Input.is_action_just_pressed("ui_confirm")):
		gtfo()

func gtfo():
	Scenes.switch_scene("res://Scenes/Intro.tscn")

func change_state(var new_state, var playSFX = true):
	state = new_state
	
	var sfx_to_play = "Toggle"
	
	match(state):
		"warning-specs":
			text.parse_bbcode(bbcode_texts[0])
			text_back.parse_bbcode(bbcode_texts[0])
		"warning-lights":
			text.parse_bbcode(bbcode_texts[1])
			text_back.parse_bbcode(bbcode_texts[1])
		"warning-parody":
			text.parse_bbcode(bbcode_texts[2])
			text_back.parse_bbcode(bbcode_texts[2])
		"exiting":
			sfx_to_play = "Confirm Sound"
		_:
			pass
		
	if playSFX:
		AudioHandler.play_audio(sfx_to_play)

func _process(delta):
	#if OS.is_debug_build() and OS.get_name() == "Android":
	#	if Input.is_action_just_pressed("ui_up") and Input.is_action_pressed("ui_down"):
	#		UnlockedSongs.set_data("too-goofy-cleared", true)
	#		UnlockedSongs.set_data("xagtheme", true)
	pass
