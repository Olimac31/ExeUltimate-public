extends "res://Scripts/Stage.gd"


onready var cinematic_bars = get_node("bars/bar-anims")
onready var anims = get_node("anims")
onready var anims_environment = get_node("anims-environment")

onready var minimalist_bg = get_node("minimalist-beach")

export var use_rim_lights = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("parallax-back/clouds/cloudanims").play("loop")
	
	if !use_rim_lights:
		get_node("lightsource").visible = false
		
	if Settings.get_data("low_detail_mode"):
		# Light sources
		#get_node("creepylight").visible = false
		#get_node("lightsource").visible = false
		get_node("creepylight").queue_free()
		get_node("lightsource").queue_free()
		
		# Filters
		get_node("filter-creepy").queue_free()
		get_node("filter-normal").queue_free()
		get_node("filter-sunset").queue_free()
		get_node("filter-night").queue_free()
		get_node("WorldEnvironment").queue_free()
		#get_node("filter-creepy/shine").queue_free()
		#get_node("filter-normal/TextureRect").queue_free()
		#get_node("filter-sunset/TextureRect").queue_free()
		#get_node("filter-night/TextureRect").queue_free()
		
		# Clouds and other props
		#get_node("creepyclouds-canvas/creepyclouds").visible = false
		#get_node("parallax-back/ParallaxLayer/Particles2D").visible = false
		#get_node("parallax-back/ParallaxLayer/smallfire").visible = false
		#get_node("parallax-back/water/Beach-water-mountains/mountains-reflection").queue_free()
		get_node("creepyclouds-canvas").queue_free()
		get_node("parallax-back/clouds").queue_free()
		get_node("parallax-back/ParallaxLayer").queue_free()
		get_node("parallax-back/water/Beach-water-mountains/mountains-reflection").queue_free()
		get_node("bg/ParallaxLayer3/Particles2D").queue_free()
		get_node("parallax-front").queue_free()
		#get_node("parallax-back/water/Beach-water-mountains/mountains-reflection").queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("OlimacCamera").mode == "Debug" and OS.is_debug_build():
		if Input.is_key_pressed(KEY_1):
			anims_environment.play("normalbg")
			minimalist_bg.set_visibility(false)
		
		if Input.is_key_pressed(KEY_2):
			anims_environment.play("sunset")
			minimalist_bg.set_visibility(false)
		
		if Input.is_key_pressed(KEY_3):
			anims_environment.play("night")
			minimalist_bg.set_visibility(false)
		
		if Input.is_key_pressed(KEY_4):
			anims_environment.play("nofilters")
			minimalist_bg.set_visibility(true)
			get_node("OlimacCamera").zoom = Vector2(1, 1)
			

func update_titlecard_text():
	var text_top = get_node("titlecard/text-top").bbcode_text
	var text_bottom = get_node("titlecard/text-bottom").bbcode_text
	
	# Top Text
	get_node("titlecard/text-top/text-top2").parse_bbcode(text_top)
	
	# Bottom Text
	get_node("titlecard/text-bottom/text-bottom2").parse_bbcode(text_bottom)

func tween_minimalist_bg(var palette_start, var palette_end, var time = 1.0):
	minimalist_bg.tween_colors(palette_start, palette_end, time)

func minimalist_bg_state(var value):
	if value:
		minimalist_bg.set_visibility(value)
		get_node("OlimacCamera").zoom = Vector2(1, 1)
		anims_environment.play("nofilters")
	else:
		minimalist_bg.set_visibility(false)
