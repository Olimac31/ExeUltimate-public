extends "res://Scripts/Stage.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.get_data("low_detail_mode"):
		get_node("vignette").queue_free()
		get_node("bg").queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
