extends Node


onready var gameplay = $"../../"


# Called when the node enters the scene tree for the first time.
func _ready():
	#gameplay.get_node("UI/Progress Bar").visible = false
	#gameplay.get_node("UI/Health Bar").visible = false
	#gameplay.get_node("UI/Gameplay Text").visible = false
	
	var strum_separation = 150
	var i = 1
	
	# Move around and resize player strums
	for strum in gameplay.player_strums.get_children():
		strum.position.x = 0 + strum_separation * i
		i += 1
	if !Settings.get_data("middlescroll"):
		gameplay.player_strums.position -= Vector2(60, 0)
	else:
		gameplay.player_strums.position -= Vector2(100, 0)
	
	# Move around and resize enemy strums
	i = 1
	for strum in gameplay.enemy_strums.get_children():
		strum.position.x = 0 + strum_separation * i
		i += 1
	gameplay.enemy_strums.position -= Vector2(140, 0)
	
	# Force scale to 1
	#gameplay.ui.scale = Vector2(1, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
