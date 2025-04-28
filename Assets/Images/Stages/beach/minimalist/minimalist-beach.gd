extends CanvasLayer

# Palettes
export var palette_day = [Color(1, 1, 1, 1)]
export var palette_sunset = [Color(1, 1, 1, 1)]
export var palette_night = [Color(1, 1, 1, 1)]
# Palette order: Front, Back, Mountains, Clouds, Base Color, Gradient

# Objects
onready var front_layer = get_node("ParallaxBackground/front-layer")
onready var back_layer = get_node("ParallaxBackground/back-layer")
onready var mountains_layer = get_node("ParallaxBackground/mountains-layer")
onready var clouds_layer = get_node("ParallaxBackground/clouds-layer")
onready var solid_bg = get_node("ParallaxBackground/solid")
onready var gradient_bg = get_node("ParallaxBackground/gradient")
onready var characters = get_node("characters-point")


onready var tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	change_colors(palette_day)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_colors(var palette = []):
	front_layer.modulate = palette[0]
	back_layer.modulate = palette[1]
	mountains_layer.modulate = palette[2]
	clouds_layer.modulate = palette[3]
	solid_bg.modulate = palette[4]
	gradient_bg.modulate = palette[5]


func tween_colors(var palette_start = [], var palette_end = [], var time = 1.0):
	var i = 0
	var layers = [front_layer, back_layer, mountains_layer, clouds_layer, solid_bg, gradient_bg]
	
	for each_layer in layers:
		tween.interpolate_property(each_layer, "modulate", palette_start[i], palette_end[i], time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		i += 1
		tween.start()

func set_visibility(var value = false):
	get_node("ParallaxBackground").visible = value
	get_node("characters-point").visible = value

func enter_chars():
	characters.get_node("characterpoint-anims").play("enter")

func exit_chars():
	characters.get_node("characterpoint-anims").play("exit")
