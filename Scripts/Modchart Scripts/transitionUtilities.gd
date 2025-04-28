extends Node


onready var flash = get_node("CanvasLayer/flash")
onready var anims = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func change_flash_color(var the_color):
	flash.color = the_color

func make_flash(var flash_type = "out", var speed = 1, var the_color = Color(1,1,1), var opacity = 1):
	change_flash_color(the_color)
	anims.playback_speed = speed
	flash.self_modulate.a = opacity
	
	match(flash_type):
		"out":
			anims.play("flash")
		"in":
			anims.play("flash_in")
		_:
			anims.play("flash")
