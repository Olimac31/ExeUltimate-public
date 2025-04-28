extends Resource
class_name SongMetadata

export var song_filename = "song"
export var song_name = "Song"
export var song_author = "Olimac31"
export var is_unlocked = false # means unlocked by default
export(Color) var song_color = Color(1, 1, 1)
export(String, "Normal", "Extra", "Remix") var song_type = "Normal"
export var song_link = "https://www.youtube.com/watch?v=0OL2D9SM7Os"
