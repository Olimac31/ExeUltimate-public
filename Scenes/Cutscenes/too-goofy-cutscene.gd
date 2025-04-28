extends "res://Scripts/overworld_cutscene.gd"


onready var anims = get_node("anims")

onready var actor_xag = get_node("xag")
onready var actor_bf = get_node("bf")
onready var render = get_node("render")

var play_talk_anims = false
var char_that_talks = actor_xag

var was_xagtheme_unlocked = false


# Called when the node enters the scene tree for the first time.
func custom_ready():
	was_xagtheme_unlocked = UnlockedSongs.get_data("xagtheme")
	
	get_node("anims").play("cover")
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	AudioHandler.stop_audio("Overworld")
	
	text_writer.visible = false
	
	# Unlock secret song
	UnlockedSongs.set_data("xagtheme", true)
	UnlockedSongs.save_data()

func _process(delta):
	identify_talker()
	if play_talk_anims:
		if text_writer.textfinished == false:
			char_that_talks.animation = "talk"
			char_that_talks.playing = true
		else:
			char_that_talks.animation = "talk"
			char_that_talks.frame = 1
			char_that_talks.playing = false


func updateStep():
	step += 1
	match(step):
		0:
			timer.set_wait_time(1)
			timer.start()
		1:
			anims.play("fade-in")
			timer.set_wait_time(1)
			timer.start()
		2:
			anims.play("phase1")
			AudioHandler.change_overworld_song(3)
		3:
			show_message(0)
		4:
			show_message(1)
		5:
			timer.set_wait_time(1)
			timer.start()
		6:
			show_message(2)
		7:
			play_talk_anims = true
			show_message(3)
			actor_xag.animation = "idle"
		8:
			show_message(4)
		9:
			show_message(5)
		10:
			show_message(6)
		11:
			play_talk_anims = false
			
			anims.play("phase2")
		12:
			play_talk_anims = true
			
			show_message(7)
		13:
			play_talk_anims = false
			
			anims.play("phase3")
		14:
			render.visible = true
			show_message(8)
		15:
			show_message(9)
		16:
			render.visible = false
			anims.play("phase4")
		17:
			show_message(10)
		18:
			anims.play("fade-out")
			timer.set_wait_time(3.0)
			timer.start()
			
			AudioHandler.fade_out("Overworld", 2.5)
		19:
			if was_xagtheme_unlocked == false:
				anims.play("unlock")
			else:
				anims.play("no-unlock")
		20:
			show_message(11)
		21:
			timer.set_wait_time(2.4)
			timer.start()
		22:
			Scenes.switch_scene("res://Scenes/Intro.tscn")
		23:
			show_message(12)
		24:
			jump_to_step(22)

func identify_talker():
	if text_writer.raw_charname == DialogueCharactersTable.get_node("xag").charname:
		char_that_talks = actor_xag
	
	if text_writer.raw_charname == DialogueCharactersTable.get_node("bf").charname:
		char_that_talks = actor_bf

func already_unlocked():
	jump_to_step(23)
