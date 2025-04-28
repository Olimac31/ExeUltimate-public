extends Node2D


export(Resource) var moremods_metadata

onready var thumb = get_node("thumb")
onready var game_title = get_node("title")
onready var game_desc = get_node("desc")
onready var back = get_node("ColorRect")

export(Array, Color) var back_colors = [Color(1, 1, 1, 1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	thumb.animation = moremods_metadata.icon_name
	game_title.parse_bbcode(moremods_metadata.game_name)
	game_title.modulate = moremods_metadata.game_color
	game_desc.parse_bbcode(moremods_metadata.description)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_TextureButton_mouse_entered():
	back.color = back_colors[1]
	AudioHandler.play_audio("Toggle")


func _on_TextureButton_mouse_exited():
	back.color = back_colors[0]


func _on_TextureButton_pressed():
	OS.shell_open(moremods_metadata.interact_link)
