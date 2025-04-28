extends Node


######################
# XAG'S THEME EVENTS #
######################

onready var gameplayNode = $"../"

var stage
#var anims
#var anims_environment
var cam

# Called when the node enters the scene tree for the first time.
func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")
	
	#anims = stage.get_node("anims")
	#anims_environment = stage.get_node("anims-environment")
	stage = gameplayNode.get_node("extrasong-stage")
	cam = stage.get_node("OlimacCamera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

	
func force_song_resync():
	AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000.0)
	AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000.0)
	Conductor.recalculate_values()
