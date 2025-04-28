extends Node2D


var state = "choosing"
# choosing, exiting

onready var tween = get_node("Tween")
onready var square = get_node("square")
onready var options = get_node("options")

var chosen_option = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state("choosing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_behavior()

func change_state(var new_state = ""):
	state = new_state
	match(state):
		"choosing":
			move_square()
		"exiting":
			match(chosen_option):
				0:
					Scenes.switch_scene("res://Scenes/Cutscenes/too-goofy-cutscene.tscn")
				1:
					Scenes.switch_scene("res://Scenes/main-week-menu.tscn")

func state_behavior():
	match(state):
		"choosing":
			if Input.is_action_just_pressed("ui_left"):
				chosen_option = 0
				move_square()
			if Input.is_action_just_pressed("ui_right"):
				chosen_option = 1
				move_square()
			
			if Input.is_action_just_pressed("ui_confirm"):
				change_state("exiting")
				AudioHandler.play_audio("Confirm Sound")
		"exiting":
			pass

func move_square():
	tween.interpolate_property(square, "position", square.position, options.get_child(chosen_option).position, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	AudioHandler.play_audio("Toggle")
