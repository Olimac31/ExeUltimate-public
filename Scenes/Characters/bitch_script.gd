extends Character


onready var anims = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func commit_die():
	anims.play("die")
