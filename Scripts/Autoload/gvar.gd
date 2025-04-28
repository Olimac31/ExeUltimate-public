extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_song_from_overworld(var songName, var difficulty = "hard"):
		Globals.songName = songName
		Globals.songDifficulty = difficulty
		
		Globals.freeplay = true
		
		var file = File.new()
		file.open(Paths.song_path(Globals.songName, Globals.songDifficulty), File.READ)

		Globals.song = JSON.parse(file.get_as_text()).result["song"]
		Scenes.switch_scene("Gameplay")
		
		file.close()

func load_song_metadata(var song_name = ""):
	# Info holder local to this function
	var song_to_load
	
	if song_name == null or song_name == "":
		song_to_load = load("res://Assets/Songs/test/test.tres") as SongMetadata
	else:
		song_to_load = load("res://Assets/Songs/" + str(song_name) + "/" + str(song_name)+ ".tres")
		print("gvar: res://Assets/Songs/" + str(song_name) + "/" + str(song_name)+ ".tres")
	
	return song_to_load

