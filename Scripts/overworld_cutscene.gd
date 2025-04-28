extends Node2D

export(Resource) var dialogues
var step = -1
onready var timer = get_node("Timer")

var last_character = "godoticon"
var last_emotion = "default"

onready var text_writer = TextWriter.get_node("UI")

signal finished_a_dialog

# Called when the node enters the scene tree for the first time.
func _ready():
	# Automatic steps
	timer.connect("timeout", self, "updateStep")
	timer.set_wait_time(1)
	timer.start()
	
	# Steps that require the player to close
	# the textbox
	text_writer.connect("finished_textbox", self, "updateStep")
	
	custom_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func custom_ready():
	pass

func updateStep():
	step += 1
	match(step):
		0:
			#play animation or something that doesn't
			#depend on the textwriter
			timer.set_wait_time(1)
			timer.start()
		1:
			pass
		2:
			pass

func show_message(var id):
	#text_writer.make_message(dialogues.message[id], dialogues.is_YN_question[id], multiple_choice, my_character, emotion)
	text_writer.make_message(dialogues.messages[id], dialogues.is_YN_question[id], dialogues.is_multiple_choice[id], dialogues.characters[id], dialogues.emotions[id])
	
	# Keep track of the characters that talk
	#last_character = my_character
	#last_emotion = emotion

func jump_to_step(var value, var wait_for_timer = false):
	step = value - 1
	if(!wait_for_timer):
		updateStep()
