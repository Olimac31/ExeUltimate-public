extends Node2D


onready var message_label = get_node("message")
var message = ""
onready var charname_label = get_node("charname")
onready var voice_beep = get_parent().get_node("voice_beep")
onready var charportrait_sprite = get_node("charPortrait")

onready var raw_message = ""
onready var raw_charname = ""

onready var continue_sfx = get_parent().get_node("continue")

onready var press_to_continue = get_node("pressToContinue")

var textfinished = true
var closed = true
onready var message_tween = get_node("message/Tween")

onready var anims = get_parent().get_node("AnimationPlayer")

# SIGNALS
signal started_textbox
signal finished_textbox

# Yes or No questions
var is_question = false
onready var yn_question_object = get_node("YN")
var YN_answer = "Yes"


func _ready():
	press_to_continue.visible = false
	modulate.a = 0
	closed = true
	textfinished = true
	yn_question_object.visible = false

func _process(delta):
	# DEBUG MESSAGE
	#if(Input.is_action_just_pressed("ui_left")):
		#make_message("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud.", true)
		#make_message("Testing short messages")
	
	# Text is not finished, typewrite it
	if(!textfinished):
		# Start the tween
		# Text finishes writing when percent_visible is 1
		if(message_label.percent_visible == 0):
			var duration = delta * 1.2 * message_label.text.length()
			message_tween.interpolate_property(message_label, "percent_visible", 0, 1, duration, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
			message_tween.start()
		elif(message_label.percent_visible == 1):
			press_to_continue.visible = true
			textfinished = true
		
		# Play voice sound effect if playback position is
		# more than half its length
		if(voice_beep.get_playback_position() >= voice_beep.stream.get_length() * 0.5):
			voice_beep.play()
		
		# Fast forward (WIP)
		#if(Input.is_action_pressed("keyS")):
		#	message_tween.playback_speed = 3
		#else:
		#	message_tween.playback_speed = 1
		
		if(Input.is_action_just_pressed("ui_cancel")):
			message_tween.stop_all()
			message_label.percent_visible = 1 # Force end
			textfinished = true
			
	# Text is finished, await for user input
	elif(textfinished):
		# Press enter to close message if it's not a question
		if(!is_question):
			if(pressed_confirm_button() and !closed):
				close_textbox()
		else:
			if(!yn_question_object.is_choosing()):
				yn_question_object.ask_question()

func pressed_confirm_button():
	if Input.is_action_just_pressed("ui_confirm") or Input.is_action_just_pressed("ui_accept"):
		return true
	else:
		return false

# Called by cutscenes and NPCs
func make_message(var messageToShow = "sample text", var askQuestion = false, var multipleChoice = false, var my_character = "godoticon", var emotion = "default"):
	anims.stop()
	press_to_continue.visible = false
	
	# Open animation if alpha is 0
	if(modulate.a <= 0.1):
		anims.play("open")
	else:
		anims.play("opened")
	#anims.play("opened")
	
	# Load message
	message_label.parse_bbcode(messageToShow)
	message_label.percent_visible = 0
	textfinished = false
	closed = false
	
	# Change character data (name, portrait, emotion)
	var fetched_character = DialogueCharactersTable.get_node(my_character)
	set_charname(fetched_character.charname)
	set_charportrait(fetched_character, emotion)
	set_charvoice(fetched_character)
	
	voice_beep.play()
	
	if(askQuestion):
		is_question = true
	
	# Save variables for reference
	raw_message = messageToShow
	raw_charname = fetched_character.charname
	
	emit_signal("started_textbox")

# Close the textbox, ending the dialogue
func close_textbox():
	anims.play("close")
	continue_sfx.play()
	closed = true
	is_question = false
	press_to_continue.visible = false
	
	emit_signal("finished_textbox")

# Returns the value of the user's last answer
func get_user_YN_answer():
	return YN_answer

# Change character name
func set_charname(var new_charname):
	charname_label.parse_bbcode(new_charname)

# Change character portrait
func set_charportrait(var character, var emotion = "default"):
	# Only execute if frames resource is NOT the same
	if (charportrait_sprite.frames != character.get_node("charPortrait").frames):
		charportrait_sprite.frames = character.get_node("charPortrait").frames
	
	# Change character's emotion
	charportrait_sprite.animation = emotion
	
	# Offset
	charportrait_sprite.offset = character.portrait_offset

# Change character voice
func set_charvoice(var character):
	if(voice_beep.stream != character.get_node("voice").stream):
		voice_beep.stream = character.get_node("voice").stream
