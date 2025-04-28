extends Node


onready var gameplayNode = $"../../"

#Zoom array that holds all the values the zoom will have
#X is the beat where it gets applied
#Y is the zoom amount
export var arrayZooms = [Vector2(1.0, 1.0), Vector2(999, 1.0)]
var array_i = 0

# Olimac's Custom Camera Script
export var is_olimac_camera = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")



func beat_hit():
	# Olimac Camera
	if is_olimac_camera:
		# Read a beat ahead
		if get_parent().cam.predict_zoom_one_beat_ahead:
			if Conductor.curBeat >= arrayZooms[array_i].x - 1:
				change_zoom_on_olimac_camera()
		# Don't read a beat ahead
		else:
			if Conductor.curBeat >= arrayZooms[array_i].x:
				change_zoom_on_olimac_camera()
	else: # Default Camera
		#Set the zoom multiplier in Gameplay.gd to our current target zoom
		if Conductor.curBeat >= arrayZooms[array_i].x:
			gameplayNode.camera_zoom_multiplier = arrayZooms[array_i].y
			array_i += 1

func change_zoom_on_olimac_camera():
	# Changes target zoom
	get_parent().cam.target_zoom = Vector2(arrayZooms[array_i].y, arrayZooms[array_i].y)
	# Locks zoom tweens until that one is completed
	get_parent().cam.changing_target_zoom = true
	get_parent().cam.change_zoom(get_parent().cam.target_zoom)
	
	array_i += 1
