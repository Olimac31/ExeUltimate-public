extends Node2D

var death_character:Node2D

var pressed_enter:bool = false

onready var camera = $Camera2D

onready var line: AudioStreamPlayer = $"Gameover Line"

onready var anims = get_node("anims")

func _ready() -> void:
	randomize()
	
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	
	AudioHandler.play_audio("Gameover Death")
	
	var death_loaded = load(Paths.char_path(Globals.death_character_name))
	
	if death_loaded == null:
		death_loaded = load(Paths.char_path("bf-dead"))
	
	death_character = death_loaded.instance()
	death_character.position = Globals.death_character_pos
	death_character.play_animation("firstDeath")
	add_child(death_character)
	
	camera.position = Globals.death_character_cam
	
	get_tree().create_timer(1.5).connect("timeout", self, "start_death_stuff")

	
	match(Globals.songName.to_lower()):
		"ugh", "guns", "stress":
			var random_line: int = round(rand_range(1, 25))
			
			line.stream = load("res://Assets/Sounds/Gameover Lines/jeffGameover-" + str(random_line) + ".ogg")

func start_death_stuff():
	if !pressed_enter:
		anims.play("enter")
		death_character.play_animation("deathLoop")
		AudioHandler.play_audio("Gameover Music")

func _process(_delta):
	if Input.is_action_just_pressed("ui_back"):
		if Globals.freeplay:
			AudioHandler.fade_out("Gameover Music", 1.0)
			AudioHandler.stop_audio("Gameover Death")
			AudioHandler.stop_audio("Gameover Retry")
			
			Scenes.switch_scene("res://Scenes/main-week-menu.tscn")
		else:
			Scenes.switch_scene("Story Mode")
	
	if Input.is_action_just_pressed("ui_accept") and !pressed_enter:
		pressed_enter = true
		
		AudioHandler.stop_audio("Gameover Music")
		AudioHandler.play_audio("Gameover Retry")
		
		death_character.play_animation("retry")
		
		anims.play("exit")
		var continue_text = "[center][color=lime]Loading..."
		get_node("CanvasLayer2/bottom-text/txt").parse_bbcode(continue_text)
		get_node("CanvasLayer2/bottom-text/txt-back").parse_bbcode(continue_text)
		
		yield(get_tree().create_timer(2.0), "timeout")
		
		Scenes.switch_scene("Gameplay")
		Globals.do_cutscenes = false
	
	#if death_character.anim_sprite:
	#	if (death_character.anim_sprite.frame >= death_character.anim_sprite.frames.get_frame_count(death_character.anim_sprite.animation) - 1 or death_character.anim_sprite.frame >= 12) and death_character.anim_sprite.animation == "firstDeath":
	#		camera.position = death_character.position + death_character.camOffset
	#		line.play()
	#		AudioHandler.get_node("Gameover Music").volume_db = -8
	
	#if !line.playing:
	#	AudioHandler.get_node("Gameover Music").volume_db = -4
