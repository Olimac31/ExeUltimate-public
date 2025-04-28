extends Node


onready var gameplayNode = $"../../"


# READY --------------------------------------
func _ready():
	pass

# PROCESS ---------------------------------------
#func _process(delta):
#	pass


# FLIP STRUMS -------------------------------------------
# Swaps the position of player strums with enemy strums
# Optionally can flip the characters
func flipStrums(var flipchars):
	var ogPosition #Placeholder position
	ogPosition = gameplayNode.player_strums.position.x
	
	#Swap them
	gameplayNode.player_strums.position.x = gameplayNode.enemy_strums.position.x
	gameplayNode.enemy_strums.position.x = ogPosition
	
	if(flipchars):
		# Flip characters and inform Character.gd that
		# the character has been flipped
		gameplayNode.bf.scale.x = -gameplayNode.bf.scale.x
		gameplayNode.bf.flipped = true
		
		gameplayNode.dad.scale.x = -gameplayNode.dad.scale.x
		gameplayNode.dad.flipped = true
