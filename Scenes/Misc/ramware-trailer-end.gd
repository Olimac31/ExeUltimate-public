extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anims = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		anims.play("anim")
	
	if Input.is_action_just_pressed("ui_cancel"):
		Scenes.switch_scene("res://Scenes/Tools Menu.tscn")
