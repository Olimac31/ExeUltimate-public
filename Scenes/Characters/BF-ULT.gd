extends Character


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.get_data("simpleShaders") == false:
		deactivate_rim_lights()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func deactivate_rim_lights():
	get_node("AnimatedSprite").material.set_shader_param("shader_param/rim_light", false)
