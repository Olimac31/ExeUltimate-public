extends Node2D

var value:float = 0

var is_bool = false

var waiting_for_input = false

onready var text = $Text
onready var parent = $"../"

export(String) var description = "Brightness amount."
export(String) var save_name = "brightness"
export(String) var display_text = "BRIGHTNESS: "
export(bool) var has_image = false
export var image_id = 1
export var min_val = 0.5
export var max_val = 3.0

var cooldownMAX = 0.1
var cooldown = 0

export(NodePath) var side_bar
export(NodePath) var options_script

func _ready():
	var value = Settings.get_data(save_name)
	text.text = display_text + str(value)

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	
	if waiting_for_input:
		modulate = Color(0, 1 ,1, 1)
		
		var value = Settings.get_data(save_name)
		
		if Input.is_action_just_pressed("ui_back") and cooldown <= 0:
			open_option()
		if Input.is_action_just_pressed("ui_left") and !Input.is_action_pressed("ui_shift"):
			if value > min_val:
				value -= 0.1
		if Input.is_action_just_pressed("ui_right") and !Input.is_action_pressed("ui_shift"):
			if value < max_val:
				value += 0.1
		
		#if Input.is_action_just_pressed("ui_left") and Input.is_action_pressed("ui_shift"):
		#	value -= 1
		#if Input.is_action_just_pressed("ui_right") and Input.is_action_pressed("ui_shift"):
		#	value += 1
			
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
			# Prevent underflow and overflow
			if value < min_val:
				value = min_val
			if value > max_val:
				value = max_val
			
			# Save data and update text
			Settings.set_data(save_name, value)
			text.text = display_text + str(value)
			
			# Apply values on specific cases
			match(save_name):
				"brightness":
					GlobalShaders.set_brightness(value)
				"contrast":
					GlobalShaders.set_contrast(value)
			
			AudioHandler.play_audio("Toggle")


func open_option():
	# Side Bar cooldown
#	get_node(side_bar).cooldown = get_node(side_bar).cooldownMAX
	
	waiting_for_input = !waiting_for_input
	parent.can_move = !waiting_for_input
	
	if save_name == "brightness" or save_name == "contrast":
		if has_image:
			parent.get_parent().get_node("Side Bar/menubox/preview-img").visible = waiting_for_input
