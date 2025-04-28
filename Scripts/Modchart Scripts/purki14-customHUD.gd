extends Node


onready var gameplay = $"../../"

onready var info = get_node("CanvasLayer/info")
onready var progress_bar = get_node("CanvasLayer/progressbar/bar")
onready var progress_text = get_node("CanvasLayer/info2")


# Called when the node enters the scene tree for the first time.
func _ready():
	gameplay.get_node("UI/Progress Bar").visible = false
	gameplay.get_node("UI/Health Bar").visible = false
	gameplay.get_node("UI/Gameplay Text").visible = false
	
	# Make UI pixel perfect
	gameplay.is_pixel_song = true
	
	var strum_separation = 96
	var i = 1
	
	# Move around and resize player strums
	gameplay.player_strums.scale = Vector2(1, 1)
	for strum in gameplay.player_strums.get_children():
		strum.scale = Vector2(2, 2)
		strum.position.x = 0 + strum_separation * i
		i += 1
	gameplay.player_notes.scale = Vector2(1, 1)
	if !Settings.get_data("middlescroll"):
		gameplay.player_strums.position -= Vector2(150, -8)
	else:
		gameplay.player_strums.position -= Vector2(75, -8)
	
	# Move around and resize enemy strums
	gameplay.enemy_strums.scale = Vector2(1, 1)
	i = 1
	for strum in gameplay.enemy_strums.get_children():
		strum.scale = Vector2(2, 2)
		strum.position.x = 0 + strum_separation * i
		i += 1
	gameplay.enemy_notes.scale = Vector2(1, 1)
	gameplay.enemy_strums.position -= Vector2(0, -8)
	
	# Force scale to 1
	gameplay.ui.scale = Vector2(1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var gameplay_progress_bar = gameplay.get_node("UI/Progress Bar/ProgressBar")
	var inst = AudioHandler.get_node("Inst")
	
	info.parse_bbcode("[center] " + gameplay.get_node("UI/Gameplay Text/Gameplay Text").text)
	
	progress_bar.value = gameplay_progress_bar.value
	progress_bar.modulate = gameplay_progress_bar.get("custom_styles/fg").bg_color
	
	progress_text.parse_bbcode("[center] " + Globals.format_time((inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / Globals.song_multiplier) + " / " + Globals.format_time(inst.stream.get_length() / Globals.song_multiplier))
