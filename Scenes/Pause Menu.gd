extends Control

var selected = 0
var showing = false

onready var tween = $Tween

onready var bg = $BG

onready var restartTimer = 0
onready var restartTimerMAX = 0.7
onready var restarting = false
onready var exiting_song = false

onready var cooldown = 0
onready var cooldownMAX = 1

onready var resume = $Resume
onready var restart_song = $"Restart Song"
onready var exit_menu = $"Exit Menu"

onready var song_name = $"Song Name"
onready var song_difficulty = $"Song Difficulty"

var local_song_metadata = SongMetadata.new()

func _ready():
	hide()
	restartTimer = restartTimerMAX

func _process(delta):
	# Menu opening cooldown
	if(cooldown > 0):
		cooldown -= delta
	if (Input.is_action_just_pressed("ui_confirm") or Input.is_action_just_pressed("ui_back")) and Scenes.current_scene == "Gameplay" and !showing and !restarting and (cooldown <= 0):
		get_tree().paused = true
		
		tween.stop_all()
		
		#resume.rect_position = Vector2(70, 200)
		#restart_song.rect_position = Vector2(70, 200)
		#exit_menu.rect_position = Vector2(70, 200)
		
		bg.modulate.a = 0
		tween.interpolate_property(bg, "modulate", Color(1,1,1,0), Color(1,1,1,0.9), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT)
		tween.interpolate_property(get_node("scrolling-bar"), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 0.85), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
		
		song_name.modulate.a = 0
		song_difficulty.modulate.a = 0
		
		song_name.rect_position.y = 10
		song_difficulty.rect_position.y = 40 # 10 + 30
		
		tween.interpolate_property(song_name, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.3)
		tween.interpolate_property(song_name, "rect_position:y", 10, 15, 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.3)
		
		tween.interpolate_property(song_difficulty, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.5)
		tween.interpolate_property(song_difficulty, "rect_position:y", 40, 45, 0.4, Tween.TRANS_QUART, Tween.EASE_IN_OUT, 0.5)
		
		tween.start()
		
		selected = 0
		show()
		on_show()
		showing = true
		refresh_bullshit()
		
		song_name.rect_position.x = 1280 - (song_name.rect_size.x + 20)
		song_difficulty.rect_position.x = 1280 - (song_difficulty.rect_size.x + 20)
		
		AudioHandler.get_node("Inst").stream_paused = true
		AudioHandler.get_node("Voices").stream_paused = true
		AudioHandler.stopCountdownBug()
		AudioHandler.play_audio("Cancel")
		AudioHandler.fade_in("Pause", 14.0, -16.0)
		
	elif Input.is_action_just_pressed("ui_confirm") and showing:
		hide()
		showing = false
		
		match(selected):
			0:
				AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000.0)
				AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000.0)
				
				get_tree().paused = false # Unpause game
			1:
				#Reload scene and stop audio from playing
				AudioHandler.stop_audio("Inst")
				AudioHandler.stop_audio("Voices")
				
				restarting = true
				Transition.trans_in()
				Globals.do_cutscenes = false
			2:
				#Exit to Menu and stop audio from playing
				AudioHandler.stop_audio("Inst")
				AudioHandler.stop_audio("Voices")
				
				if !restarting:
					Transition.trans_in()
				restarting = true
				exiting_song = true
				#get_tree().paused = false # Unpause game
				cooldown = cooldownMAX # To avoid glitches such as
				#                        pausing while exiting
		
		#Attempt to fix song playing after restart bug
		AudioHandler.get_node("Inst").stream_paused = false
		AudioHandler.get_node("Voices").stream_paused = false
		AudioHandler.stop_audio("Pause")
	
	# Restart (or change) scene with delay
	elif restarting:
		if(restartTimer > 0):
			restartTimer -= delta
		
		# When the timer is over
		if(restartTimer <= 0):
			if exiting_song:
				Scenes.switch_scene("res://Scenes/main-week-menu.tscn", true)
				#Scenes.switch_scene("res://Scenes/Credits.tscn", true)
				AudioHandler.stop_audio("Pause")
			else:
				get_tree().reload_current_scene()
				
			Transition.trans_out()
			restartTimer = restartTimerMAX
			restarting = false
			exiting_song = false
			get_tree().paused = false # Unpause game --------
			hide()
			showing = false
	
	if showing:
		# Prevent bug where this can be opened in the menu
		if(Scenes.current_scene != "Gameplay"):
			hide()
			showing = false
			get_tree().paused = false
		#set_pos_text(resume, 0 - selected, delta)
		#set_pos_text(restart_song, 1 - selected, delta)
		#set_pos_text(exit_menu, 2 - selected, delta)
		
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
			if Input.is_action_just_pressed("ui_down"):
				selected += 1
			if Input.is_action_just_pressed("ui_up"):
				selected -= 1
			
			if selected > 2:
				selected = 0
			if selected < 0:
				selected = 2
			
			AudioHandler.play_audio("Scroll Menu")
			
			refresh_bullshit()

func on_show():
	local_song_metadata = gvar.load_song_metadata(Globals.song.song) as SongMetadata
	
	song_name.text = local_song_metadata.song_name + " - " + local_song_metadata.song_author
	song_difficulty.text = Globals.songDifficulty.to_upper()

func refresh_bullshit():
	resume.modulate.a = 0.5
	restart_song.modulate.a = 0.5
	exit_menu.modulate.a = 0.5
	
	resume.bbcode_text = "[right]RESUME"
	restart_song.bbcode_text = "[right]RESTART SONG"
	exit_menu.bbcode_text = "[right]GO BACK"
	#"[shake rate=20.0 level=5 connected=1] AAAAAA [/shake]"
	
	match(selected):
		0:
			resume.modulate.a = 1
		1:
			restart_song.modulate.a = 1
		2:
			exit_menu.modulate.a = 1

func set_pos_text(text, targetY, elapsed):
	var scaledY = range_lerp(targetY, 0, 1, 0, 1.3)
	
	var lerpVal = clamp(elapsed * 9.6, 0.0, 1.0)
	
	# 120 = yMult, 720 = FlxG.height
	text.rect_position.y = lerp(text.rect_position.y, (scaledY * 120) + (720 * 0.48), lerpVal);

	text.rect_position.x = lerp(text.rect_position.x, (targetY * 20) + 90, lerpVal)
