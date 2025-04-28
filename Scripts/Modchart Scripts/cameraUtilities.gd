extends Node

# CAMERA UTILITIES
# This script has a lot of camera functions that will
# make it easier for you to add cool effects in your
# songs, such as camera bumps, zooms, etc.
# Moreover, you can change the offsets
onready var gameplay = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# CHANGE CAMERA POSITION ------------------------------
func changePosition(var X, var Y):
	gameplay.camera.position = Vector2(X, Y)

# CHANGE CAMERA OFFSETS -------------------------------
# This function lets you alter the camOffsets at
# any given time
# You can set, add, subsctract, multiply or divide it
func changeCameraOffsets(var mode, var character, var X, var Y):
	var camToChange
	match character:
		"dad":
			camToChange = gameplay.dad
		"bf":
			camToChange = gameplay.bf
		"gf":
			camToChange = gameplay.gf
	
	# Check for the mode
	match mode:
		"set":
			camToChange.camOffset = Vector2(X, Y)
		"add":
			camToChange.camOffset += Vector2(X, Y)
		"substract":
			camToChange.camOffset -= Vector2(X, Y)
		"multiply":
			camToChange.camOffset *= Vector2(X, Y)
		"divide":
			camToChange.camOffset /= Vector2(X, Y)


# CAMERA --------------------------------------------
# These functions let you add a short bump to the camera
#
# You can maybe call them on loop with a timer
# on the intense part of a song to spice things up a bit.

# Default bump (plays whenever called, no condition provided)
func default_bump(var amount):
	gameplay.force_little_bump(amount)

# Kick bump (plays on 1st and 3rd beats)
func kick_bump(var amount):
	if (Conductor.curBeat % 2 == 0):
		gameplay.force_little_bump(amount)

# Snare bump (plays on the 2nd and 4th beats)
func snare_bump(var amount):
	if !(Conductor.curBeat % 2 == 0):
		gameplay.force_little_bump(amount)

