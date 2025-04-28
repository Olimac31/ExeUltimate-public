extends Node2D

var state = "choosing"
# choosing, leaving


# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.get_data("low_detail_mode"):
		get_node("bg-filter").queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_behavior()

func change_state(var new_state):
	state = new_state
	
	match(state):
		"choosing":
			pass
		"leaving":
			Scenes.switch_scene("res://Scenes/Credits.tscn")
	
func state_behavior():
	match(state):
		"choosing":
			if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_back"):
				change_state("leaving")
		"leaving":
			pass
