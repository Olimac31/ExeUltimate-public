extends Node2D


var state = "selecting"
# selecting, exiting, deleting
var id = 0

var delete_confirmations_max = 3
var delete_confirmations = delete_confirmations_max

onready var select_square = get_node("UI-back/select")
onready var options = get_node("options")
onready var tween = get_node("Tween")
onready var txt_delete = get_node("UI-back/txt-delete")

onready var anims = get_node("AnimationPlayer")

var cooldown = 0
var cooldown_max = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	anims.play("enter")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	
	if cooldown <= 0:
		match(state):
			"selecting":
				if Input.is_action_just_pressed("ui_down"):
					if id < options.get_child_count() - 1:
						scroll_option(1)
				if Input.is_action_just_pressed("ui_up"):
					if id > 0:
						scroll_option(-1)
				
				if Input.is_action_just_pressed("ui_confirm") or Input.is_action_just_pressed("ui_accept"):
					choose_an_option()
						
			"exiting":
				pass
			"deleting":
				# Check confirmations
				if delete_confirmations > 0:
					txt_delete.parse_bbcode("[color=red]PRESS " + str(delete_confirmations) + " TIMES TO CONFIRM DELETION.")
				else:
					txt_delete.parse_bbcode("[color=red]DELETE ALL SAVE DATA")
					scroll_option(999) # Reset option chooser
					
					# Reset data
					Settings.reset_save_data()
					UnlockedSongs.save_data()
					
					change_state("selecting")
					
					get_node("UI-back/deleted/delet-anims").stop()
					get_node("UI-back/deleted/delet-anims").play("deleted")
					AudioHandler.play_audio("Confirm Sound")
				
				# Press button again
				if Input.is_action_just_pressed("ui_confirm") or Input.is_action_just_pressed("ui_accept"):
					delete_confirmations -= 1
					AudioHandler.play_audio("Toggle")
				
				if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_back"):
					txt_delete.parse_bbcode("[color=red]DELETE ALL SAVE DATA")
					change_state("selecting")
					scroll_option(999)
					
					AudioHandler.play_audio("Cancel")

func change_state(var new_state):
	match(new_state):
		"selecting":
			pass
		"exiting":
			pass
		"deleting":
			delete_confirmations = delete_confirmations_max
	
	cooldown = cooldown_max
	state = new_state

func move_selection():
	tween.interpolate_property(select_square, "position", select_square.position, options.get_child(id).position, 0.3, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()

func scroll_option(var amount):
	if amount != 999:
		id += amount
	else:
		id = 0
	
	move_selection()
	AudioHandler.play_audio("Scroll Menu")

func choose_an_option():
	match(options.get_child(id).name):
		"open":
			AudioHandler.play_audio("Confirm Sound")
			OS.shell_open(OS.get_user_data_dir())
		"delete":
			AudioHandler.play_audio("Toggle")
			change_state("deleting")
		"exit":
			Scenes.switch_scene("res://Scenes/exe_title.tscn")
			change_state("exiting")
