extends Node2D

var selected = 0

var can_move = true

onready var side_bar = $"../Side Bar"
onready var desc = side_bar.get_node("Option Description")

onready var open = get_parent().open

# Horizontal rows
var max_objects_per_row = 7

export var unselected_color = Color(1, 1, 1, 1)
export var unselected_color_darker = Color(1, 1, 1, 1)

var cooldownMAX = 0.1
var cooldown = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	for child in get_children():
		child.position = Vector2(0, 0)
	
	update_options()

func _process(delta):
	if cooldown > 0:
		cooldown -= delta
	
	
	open = get_parent().open
	if(open):
		if can_move:
			if Input.is_action_just_pressed("ui_up"):
				selected -= 1
			if Input.is_action_just_pressed("ui_down"):
				selected += 1
			
			# Horizontally select options from the other row
			if(len(get_children()) >= max_objects_per_row): # Check if there's more than one row
				# This code below allows you to jump back
				# and forth between rows
				if(Input.is_action_just_pressed("ui_right")):
					if selected + max_objects_per_row < len(get_children()):
						selected += max_objects_per_row
						update_options()
				if(Input.is_action_just_pressed("ui_left")):
					if selected - max_objects_per_row >= 0:
						selected -= max_objects_per_row
						update_options()
			
			if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
				if selected > len(get_children()) - 1:
					selected = 0
				if selected < 0:
					selected = len(get_children()) - 1
				
				update_options()
			
			if Input.is_action_just_pressed("ui_accept") and cooldown >= 0:
				var selected_option = get_children()[selected]
				selected_option.open_option()
				
				if selected_option.is_bool:
					selected_option.update_checkbox()
					Settings.set_data(selected_option.save_name, selected_option.value)
					
		else:
			for option in get_children():
				option.modulate = unselected_color_darker
		
		for i in get_child_count():
			set_pos_text(get_child(i), i - selected, delta)

func update_options():
	var starting_vertical_separation = 192
	var vertical_separation = starting_vertical_separation # Starting position
	var separation_amount = 45 # Added separation per object
	
	# Add another row if too many options
	var object_count = 0
	var horizontal_separation = 0
	var horizontal_separation_amount = 440
	
	for option in get_children():
		if option == get_child(selected) and can_move:
			option.modulate = Color(1, 1, 1, 1)
			
			if desc and can_move:
				desc.text = option.description
		else:
			option.modulate = unselected_color
		
		# Set the position of the objects, applying the
		# offsets and separation
		option.position.y = 72 + vertical_separation
		option.position.x = 86 + horizontal_separation
		vertical_separation += separation_amount
		
		# Adding extra horizontal rows
		object_count += 1
		if(object_count >= max_objects_per_row):
			horizontal_separation += horizontal_separation_amount
			object_count = 0
			vertical_separation = starting_vertical_separation
	
	if(open):
		AudioHandler.play_audio("Scroll Menu")

func set_pos_text(text, targetY, elapsed):
	var scaledY = range_lerp(targetY, 0.0, 1.0, 0.0, 1.3)
	
	var lerpVal = clamp(elapsed * 9.6, 0.0, 1.0)
	
	# 120 = yMult, 720 = FlxG.height
	#text.position.y = lerp(text.position.y, (scaledY * 40.0) + (720.0 * 0.48), lerpVal);
	#text.position.y = lerp(text.position.y, (scaledY * 40.0) + (720.0 * 0.48), lerpVal);

	#text.position.x = lerp(text.position.x, (targetY * 20.0) + 90.0, lerpVal)
	#text.position.x = 120
