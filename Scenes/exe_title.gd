extends Node2D


var state = "entering"
# entering, press_enter, choosing, waiting, exiting, goto_room

var chosen_option = 0

onready var options = get_node("bottom_menu/options")
onready var options_menu = get_node("Options Menu")
onready var select_square = get_node("bottom_menu/select_square")
onready var tween = get_node("Tween")

var cooldownMAX = 0.1
var cooldown = 0

onready var anims = get_node("AnimationPlayer")

var room_to_go = "res://Scenes/Freeplay.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state("entering")
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
	
	options_menu.connect("options_closed", self, "options_menu_closed")
	
	$Camera2D.current = true
	
	if Settings.get_data("low_detail_mode") == true:
		get_node("skybox").queue_free()
		get_node("vignette").queue_free()
		get_node("particles").queue_free()
		get_node("filter").queue_free()
		

func _process(delta):
	match(state):
		"entering":
			pass
		"press_enter":
			if Input.is_action_just_pressed("ui_accept") and cooldown <= 0:
				AudioHandler.play_audio("Confirm Sound")
				anims.play("start_choosing")
				
				change_state("choosing")
		"choosing":
			if Input.is_action_just_pressed("ui_right"):
				change_option(1)
			if Input.is_action_just_pressed("ui_left"):
				change_option(-1)
			
			if Input.is_action_just_pressed("ui_accept") and cooldown <= 0:
				choose_an_option()
	
	if cooldown > 0:
		cooldown -= delta

func change_state(var new_state):
	state = new_state
	
	match(state):
		"entering":
			anims.play("enter")
		"choosing":
			cooldown = cooldownMAX
			
			Discord.update_presence("On Title Screen", "")
		"waiting":
			pass
		"exiting":
			anims.play("exiting")
		"goto_room":
			Scenes.switch_scene(room_to_go)
		_:
			pass

func goto_press_enter():
	change_state("press_enter")

func change_option(var amount):
	# chosen_option stuff
	chosen_option += amount
	
	if chosen_option < 0:
		chosen_option = 5
	if chosen_option > 5:
		chosen_option = 0
	
	#chosen_option = clamp(chosen_option, 0, 3)
	
	# select square stuff
	tween.interpolate_property(select_square, "position", select_square.position, options.get_child(chosen_option).position, 0.32, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	
	AudioHandler.play_audio("Scroll Menu")

func choose_an_option():
	match(options.get_child(chosen_option).name.to_lower()):
		"start":
			AudioHandler.play_audio("Cancel")
		"freeplay":
			room_to_go = "res://Scenes/main-week-menu.tscn"
			change_state("exiting")
			
			AudioHandler.play_audio("Confirm Sound")
		"options":
			options_menu.openMenu()
			change_state("waiting")
			
			AudioHandler.play_audio("Confirm Sound")
		"credits":
			room_to_go = "res://Scenes/Credits.tscn"
			change_state("exiting")
			
			AudioHandler.play_audio("Confirm Sound")
			AudioHandler.fade_out("Title Music", 2.3)
		"exit":
			get_tree().quit()
		"report":
			OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSftPvHBjXT3R8VXqDRpDjmxGlkIlG98fxzYP6f7oQBN2eTbYA/viewform?usp=dialog")
		_:
			print(options.get_child(chosen_option).name.to_lower())
			pass
func options_menu_closed():
	change_state("choosing")

func actually_exit():
	change_state("goto_room")
