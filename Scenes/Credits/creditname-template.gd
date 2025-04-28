extends Node2D


export(Resource) var credit_data


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func make_chosen():
	modulate = credit_data.user_color

func make_unchosen():
	modulate = Color(0, 0, 0, 0.5)
	
func update_data():
	get_node("text").parse_bbcode(credit_data.person_name)


