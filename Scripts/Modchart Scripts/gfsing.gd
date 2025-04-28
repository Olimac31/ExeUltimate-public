extends Node


onready var gameplayNode = $"../../"
export var arrayToggleBeats = [4, 12, 20, 28, 36, 52, 68, 84, 999]
var array_i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")

#func _process(delta):
#	pass

func beat_hit():
	if Conductor.curBeat >= arrayToggleBeats[array_i]-1 and Conductor.curBeat < arrayToggleBeats[array_i + 1]:
		toggle_gf_sing()
		array_i += 1

func toggle_gf_sing():
	#Swap dad and gf in gameplay
	#so that the gameplay node makes gf sing instead
	var nodeHolder = gameplayNode.dad
	gameplayNode.dad = gameplayNode.gf
	gameplayNode.gf = nodeHolder
