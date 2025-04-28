extends Node

####################
# TOO GOOFY EVENTS #
####################


# Copied from cameraZooms
onready var gameplayNode = $"../"
onready var transition_tools = get_node("transitionTools")
onready var health_utilities = get_node("healthUtilities")
#onready var tween = get_node("Tween")

var stage
var anims
var anims_environment
var cam

var xag
var cardboard

export var flash_colors = [Color(1, 1, 1)]

var first_time_playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")
	
	stage = gameplayNode.get_node("beach")
	anims = stage.get_node("anims")
	anims_environment = stage.get_node("anims-environment")
	cam = stage.get_node("OlimacCamera")
	
	stage.cinematic_bars.play("show")
	
	anims.play("start")
	
	set_gameplay_ui_visibility(false)
	
	xag = gameplayNode.dad
	cardboard = stage.get_node("bitch")
	
	# Hide Xag, replace him with cardboard sonic
	gameplayNode.dad.visible = false
	gameplayNode.dad = cardboard
	
	gameplayNode.update_healthbar_icons()
	
	if UnlockedSongs.get_data("too-goofy-cleared") == true:
		first_time_playing = false

func beat_hit():
	# Events by category
	events_minbg()
	events_flashes()
	
	# General Events
	match(Conductor.curBeat):
		-1:
			cam.mode = "Normal"
			cam.smoothing_enabled = false
		0:
			force_song_resync()
			cam.smoothing_enabled = true
			
			anims.play("intro")
		48:
			gameplayNode.anims.play("ui_enter")
			yield(get_tree().create_timer(0.1), "timeout")
			set_gameplay_ui_visibility(true)
			
			force_song_resync()
			
		64:
			cam.mode = "FollowChars"
		128:
			xag.play_enter_animation()
			anims.play("intro-end")
		129:
			xag.visible = true
		130:
			gameplayNode.anims.play("ui_exit")
		148:
			health_utilities.health_drain = true
			gameplayNode.anims.play("ui_enter")
		# Drop 1
		152:
			gameplayNode.dad.visible = false
			gameplayNode.dad = xag
			gameplayNode.dad.visible = true
			
			cam.camera_bumps = true
			cam.bump_mode = "Snare"
			cam.mode = "FollowChars"
			
			gameplayNode.update_healthbar_icons()
			health_utilities.health_drain = false
		# First Verse
		216:
			cam.camera_bumps = false
		248:
			cam.camera_bumps = true
		# Bridge
		280:
			cam.bump_mode = "Custom"
			cam.custom_bump_divisor = 4
			gameplayNode.anims.play("ui_exit")
		296:
			cam.mode = "Normal"
			anims.play("event-titlecard")
		304:
			cam.camera_bumps = false
			
			stage.cinematic_bars.play("exit")
		# Chorus
		312:
			cam.camera_bumps = false
			cam.mode = "Free"
			cam.zoom = Vector2(1, 1)
			cam.target_zoom = Vector2(1, 1)
			
			gameplayNode.anims.play("ui_enter")
		368:
			cam.camera_bumps = false
			anims.play("event-titlecard-act2")
		# Drop 2
		376:
			cam.camera_bumps = true
			cam.bump_mode = "Snare"
			cam.bump_amount = Vector2(0.015, 0.015)
			cam.mode = "FollowChars"
			
			anims_environment.play("sunset")
			stage.cinematic_bars.play("enter")
		# First Verse (reprise)
		440:
			cam.camera_bumps = false
		472:
			cam.camera_bumps = true
		# Bridge 2
		504:
			cam.camera_bumps = false
			cam.mode = "Normal"
			
			gameplayNode.anims.play("ui_exit")
			stage.cinematic_bars.play("exit")
			anims.play("event-voiceline")
		508:
			# evil dialogue thing
			pass
		# Chorus (reprise)
		556:
			cam.camera_bumps = false
			cam.mode = "Free"
			
			gameplayNode.anims.play("ui_enter")
		650:
			transition_tools.make_flash("in", 2, flash_colors[1], 1)
		# Ending
		652:
			cam.camera_bumps = true
			cam.bump_mode = "Kick"
			cam.bump_amount = Vector2(0.015, 0.015)
			cam.mode = "FollowChars"
			
			anims_environment.play("night")
			stage.cinematic_bars.play("enter")
			
			transition_tools.make_flash("out", 1.5, flash_colors[1], 1.0)
		684:
			cam.camera_bumps = false
			cam.mode = "Normal"
			gameplayNode.anims.play("ui_exit")
			transition_tools.make_flash("in", 0.7, flash_colors[1], 1)
		700:
			UnlockedSongs.set_data("too-goofy-cleared", true)
			UnlockedSongs.save_data()
		710:
			# Go to the Too Goofy cutscene
			if first_time_playing:
				gameplayNode.exit_song("res://Scenes/Cutscenes/too-goofy-cutscene.tscn", false)
			else:
				gameplayNode.exit_song("res://Scenes/Cutscenes/too-goofy-cutscene-repeat.tscn", false)


func set_gameplay_ui_visibility(var value = false):
	gameplayNode.player_strums.visible = value
	gameplayNode.enemy_strums.visible = value
	gameplayNode.gameplay_text.visible = value
	gameplayNode.health_bar.visible = value
	gameplayNode.progress_bar.visible = value
	gameplayNode.get_node("UI/backdrop").visible = value


func events_minbg():
	match(Conductor.curBeat):
		304:
			cam.zoom = Vector2(1, 1)
			cam.target_zoom = Vector2(1, 1)
			stage.minimalist_bg_state(true)
		312:
			stage.minimalist_bg.enter_chars()
		360:
			var minbg = stage.minimalist_bg
			stage.tween_minimalist_bg(minbg.palette_day, minbg.palette_sunset, 1.5)
		364:
			stage.minimalist_bg.exit_chars()
		372:
			stage.minimalist_bg_state(false)
		548:
			cam.zoom = Vector2(1, 1)
			cam.target_zoom = Vector2(1, 1)
			
			stage.minimalist_bg_state(true)
		556:
			stage.minimalist_bg.enter_chars()
		636:
			var minbg = stage.minimalist_bg
			stage.tween_minimalist_bg(minbg.palette_sunset, minbg.palette_night, 1.5)
		646:
			stage.minimalist_bg.exit_chars()
		652:
			stage.minimalist_bg_state(false)

func events_flashes():
	match(Conductor.curBeat):
		152:
			if Settings.get_data("flashingLights"):
				transition_tools.make_flash("out", 2, flash_colors[0], 0.5)

func _process(delta):
	if OS.is_debug_build():
		if Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("ui_up"):
			Conductor.songPosition = 64.0 * 1000
			AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000.0)
			AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000.0)
			get_node("cameraZooms").array_i = 6
			
			Conductor.recalculate_values()
		
		# Press R to instanly fucking die
		if Input.is_action_just_pressed("ui_reset"):
			gameplayNode.health = 0

func force_song_resync():
	AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000.0)
	AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000.0)
	Conductor.recalculate_values()
