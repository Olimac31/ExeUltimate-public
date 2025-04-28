extends Node2D


var state = "selecting"
# selecting, options, exiting, returning_to_menu

var local_song_metadata
var song_id = 0
var option_id = 0
var chosen_dif = "normal"

export(Array, String) var song_list = [
	"too-goofy",
	"xagtheme"
]

onready var thumbnails = get_node("thumbnails")

onready var txt_name = get_node("menus/menu/txt-name")
onready var txt_author = get_node("menus/menu/txt-author")
onready var txt_dif = get_node("menus/txt-dif")
onready var txt_name_big = get_node("menus/txt-name-big")

var cooldown = 0
var cooldown_max = 0.1

onready var options = get_node("menus/menu/options")
onready var select_square = get_node("menus/menu/select_square")
onready var anims = get_node("anims")

onready var cam = get_node("Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	chosen_dif = Settings.get_data("difficulty")
	
	spawn_song_thumbs()
	update_song_metadata()
	move_selection_square()
	anims.play("options-hide")
	
	if !AudioHandler.get_node("Title Music").playing:
		AudioHandler.play_audio("Title Music")
	
	if Settings.get_data("low_detail_mode"):
		get_node("vignette").queue_free()
		get_node("CanvasLayer").queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	
	if cooldown <= 0:
		match(state):
			"selecting":
				# Choose between songs
				if Input.is_action_just_pressed("ui_right"):
					if song_id < song_list.size() - 1:
						song_id += 1
						AudioHandler.play_audio("Scroll Menu")
						
						update_song_metadata()
				
				if Input.is_action_just_pressed("ui_left"):
					if song_id > 0:
						song_id -= 1
						AudioHandler.play_audio("Scroll Menu")
						
						update_song_metadata()
				
				if Input.is_action_just_pressed("ui_confirm"):
					# Check song unlock state
					if UnlockedSongs.get_data(local_song_metadata.song_filename):
						change_state("options")
						AudioHandler.play_audio("Confirm Sound")
					else:
						AudioHandler.play_audio("Cancel")
				
				if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_back"):
					change_state("returning_to_menu")
			"options":
				# Choose between song options
				if Input.is_action_just_pressed("ui_down"):
					if option_id < options.get_child_count() - 1:
						option_id += 1
						AudioHandler.play_audio("Toggle")
						
						move_selection_square()
				
				if Input.is_action_just_pressed("ui_up"):
					if option_id > 0:
						option_id -= 1
						AudioHandler.play_audio("Toggle")
						
						move_selection_square()
				
				if Input.is_action_just_pressed("ui_confirm"):
					match(options.get_child(option_id).name):
						"start":
							change_state("exiting")
							AudioHandler.play_audio("Confirm Sound")
							AudioHandler.fade_out("Title Music", 1.5)
						"changedif":
							match(chosen_dif):
								"normal":
									chosen_dif = "hard"
								"hard":
									chosen_dif = "normal"
							
							Settings.set_data("difficulty", chosen_dif)
							AudioHandler.play_audio("Toggle")
							update_song_values()
						"listen":
							OS.shell_open(local_song_metadata.song_link)
							AudioHandler.play_audio("Confirm Sound")
						
				if Input.is_action_just_pressed("ui_back"):
					change_state("selecting")
					anims.play("options-exit")
					
					AudioHandler.play_audio("Cancel")

func change_state(var new_state):
	match(new_state):
		"selecting":
			Discord.update_presence("On Freeplay Menu", "Choosing a song to play")
		"options":
			anims.play("options-enter")
		"exiting":
			anims.play("exit")
		"returning_to_menu":
			AudioHandler.play_audio("Cancel")
			Scenes.switch_scene("res://Scenes/exe_title.tscn")
		_:
			pass
	
	cooldown = cooldown_max
	state = new_state

func update_song_values():
	# Update texts
	txt_name.parse_bbcode("[right]" + local_song_metadata.song_name)
	txt_author.parse_bbcode("[right]" + local_song_metadata.song_author)
	
	txt_name.modulate = local_song_metadata.song_color
	
	# Show song name depending on metadata
	update_big_text()
	
	# Change difficulty text
	match chosen_dif:
		"normal":
			txt_dif.parse_bbcode("[right]Difficulty: [color=lime]NORMAL")
		"hard":
			txt_dif.parse_bbcode("[right]Difficulty: [color=red]HARD")
	
	# Camera position
	cam.position.x = thumbnails.get_child(song_id).position.x
	
	# Update thumbnails opacity
	var i = 0
	for thumb in thumbnails.get_children():
		# Set all to invisible first
		# Then iterate and set the chosen one as fully opaque
		# and the previous and next as transparent
		thumb.tween_opacity(0.0)
		thumb.tween_size(Vector2(0.5, 0.5))
		if i == song_id - 1 or i == song_id + 1:
			thumb.tween_opacity(0.5)
		if i == song_id:
			thumb.tween_opacity(1.0)
			thumb.tween_size(Vector2(1.0, 1.0))
		i += 1
	
	update_arrows_opacity()

func update_song_metadata():
	local_song_metadata = gvar.load_song_metadata(song_list[song_id]) as SongMetadata
	update_song_values()

func move_selection_square():
	select_square.position = options.get_child(option_id).position

func spawn_song_thumbs():
	var thumb_template = load("res://Scenes/freeplay-song.tscn")
	var startpos = 640
	var thumb_separation = 240
	
	var i = 0
	for song in song_list:
		# Spawn thumbnail
		var new_song = thumb_template.instance()
		thumbnails.add_child(new_song)
		new_song.position = Vector2(startpos + thumb_separation * i, 320)
		
		# Check unlock state to figure out what thumb
		# to use
		if UnlockedSongs.get_data(song):
			new_song.get_node("thumb").animation = song_list[i]
		else:
			new_song.get_node("thumb").animation = "unknown"
		
		i += 1
	
	# Coming Soon text
	var comingsoon_song = thumb_template.instance()
	thumbnails.add_child(comingsoon_song)
	comingsoon_song.position = Vector2(startpos + thumb_separation * i, 320)
	comingsoon_song.get_node("thumb").animation = "comingsoon"
	comingsoon_song.hide_cover()

func update_arrows_opacity():
	var right = get_node("arrows/arrow")
	var left = get_node("arrows/arrow2")
	
	right.modulate.a = 1
	left.modulate.a = 1
	
	if song_id <= 0:
		right.modulate.a = 1
		left.modulate.a = 0.5
	if song_id >= song_list.size() - 1:
		right.modulate.a = 0.5
		left.modulate.a = 1

func update_big_text():
	if UnlockedSongs.get_data(local_song_metadata.song_filename):
		txt_name_big.parse_bbcode("[center]" + local_song_metadata.song_name)
		
		# Naming events and exceptions
		match(local_song_metadata.song_filename):
			"too-goofy":
				if !UnlockedSongs.get_data("too-goofy-cleared"):
					txt_name.parse_bbcode("[right]Too Slow")
					txt_name_big.parse_bbcode("[center]Too Slow")
	else:
		txt_name_big.parse_bbcode("[center][shake][color=silver]LOCKED")

func goto_song():
	gvar.load_song_from_overworld(local_song_metadata.song_filename, chosen_dif)
