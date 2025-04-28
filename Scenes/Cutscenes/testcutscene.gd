extends "res://Scripts/overworld_cutscene.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateStep():
	step += 1
	match(step):
		0:
			show_message(0)
		1:
			show_message(1)
		2:
			show_message(2)
		3:
			show_message(3)
		4:
			show_message(4)
		5:
			show_message(5)
		6:
			timer.set_wait_time(2)
			timer.start()
		7:
			show_message(6)
