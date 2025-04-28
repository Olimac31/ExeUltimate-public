extends Node2D


onready var selectSquare = get_node("selectSquare")
onready var options = get_node("Options")
onready var tween = get_node("Tween")

signal chose_option
var choosing_option = false
var selected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	change_item(0, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(choosing_option):
		if(Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")):
			change_item(ceil(Input.get_axis("ui_up", "ui_down")))
		
		if(Input.is_action_just_pressed("ui_confirm")):
			answer_question()

func change_item(amount, var playsfx = true):
	selected += amount
	
	if selected < 0: selected = options.get_child_count() - 1
	if selected > options.get_child_count() - 1: selected = 0
	
	# Tween position of selectSquare
	tween.interpolate_property(selectSquare, "position", selectSquare.position, options.get_child(selected).position + options.position, 0.4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	
	if(playsfx):
		AudioHandler.play_audio("Scroll Menu")

func ask_question():
	visible = true
	choosing_option = true
	selected = 0
	change_item(0, false)

func answer_question():
	# Set visibility to false and stop choosing options
	visible = false
	choosing_option = false
	
	# Save answer and close the entire textbox
	get_parent().YN_answer = options.get_child(selected).get_node("label").text
	get_parent().close_textbox()

func is_choosing():
	if choosing_option:
		return true
	else:
		return false
