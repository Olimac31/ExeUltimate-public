extends Node2D


var step = 0
onready var anims = get_node("AnimationPlayer")
onready var timer = get_node("Timer")

var loading_text_is_on = false
var skipped = false

func _ready():
	timer.connect("timeout", self, "timeout")
	change_step(0)
	
	if Settings.get_data("first_use") and OS.get_name() != "Android":
		Scenes.switch_scene("res://Scenes/Options Menus/Binds Menu.tscn", true)

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and !skipped:
		skipped = true
		loading_text()


func change_step(var amount = 1):
	step += amount
	
	match(step):
		0:
			anims.play("godot-enter")
			
			timer.set_wait_time(2.8)
			timer.start()
		1:
			anims.play("godot-exit")
			
			timer.set_wait_time(1.1)
			timer.start()
		2:
			anims.play("ta-enter")
			
			timer.set_wait_time(4.2)
			timer.start()
		3:
			anims.play("ta-exit")
			
			timer.set_wait_time(1.3)
			timer.start()
		4:
			Scenes.switch_scene("res://Scenes/exe_title.tscn")


func jump_to_step(var target = 0):
	step = target
	change_step(0)

func timeout():
	change_step()

func loading_text():
	if !loading_text_is_on:
		$"CanvasLayer2/txt-loading/loadinganim".play("enter")

func gtfo():
	if skipped:
		Scenes.switch_scene("res://Scenes/exe_title.tscn")
