extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = get_node("Tween")
onready var thumb = get_node("thumb")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cover_exceptions()

func tween_opacity(var target_opacity = 1.0):
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, target_opacity), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func tween_size(var target_size = Vector2(1, 1)):
	tween.interpolate_property(self, "scale", scale, target_size, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func hide_cover():
	$cover.visible = false


func cover_exceptions():
	# Too Goofy thumbnail before clearing it
	if !UnlockedSongs.get_data("too-goofy-cleared") and thumb.animation == "too-goofy":
		thumb.animation = "too-slow"
