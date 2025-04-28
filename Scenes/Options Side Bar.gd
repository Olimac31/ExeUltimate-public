extends Node2D

# Check if menu is open
onready var open = get_parent().open

# selecting stuff
var selected: int = 0
var is_selecting: bool = true

# cool options
onready var options: Node2D = $"../Options"
onready var desc = get_node("Option Description")
onready var escape_desc = get_node("Esc Description")

# tabs shit
onready var tabs_obj: Node2D = $Tabs

onready var tabs: Array = tabs_obj.get_children()
onready var tab_count: int = tabs_obj.get_child_count()

onready var cooldownMAX = 0.1
onready var cooldown = 0

onready var select_square = get_node("selectSquare")


# other shit
var tween = Tween.new()

func _ready():
	# setup stuff
	add_child(tween)
	
	
	change_item(0)
	options.can_move = false

func _process(delta):
	open = get_parent().open
	if(open and get_parent().cooldown <= 0):
		if is_selecting:
				
			# Close options menu
			if Input.is_action_just_pressed("ui_back") and cooldown <= 0:
				get_parent().closeMenu()
				AudioHandler.play_audio("Cancel")
			
			if Input.is_action_just_pressed("ui_right"):
				change_item(1)
			if Input.is_action_just_pressed("ui_left"):
				change_item(-1)
			if (Input.is_action_just_pressed("ui_accept")):
				is_selecting = false
				
				tabs_obj.get_child(selected).modulate.a = 1
				tabs_obj.get_child(selected).modulate = Color(0.1, 0, 0.1)
				#AudioHandler.play_audio("Toggle")
				
				options.can_move = true
				options.update_options()
			if(options.can_move == false):
				desc.text = "Choose a category."
				
				# Check for controller use
				if(!TouchControls.usingController):
					escape_desc.text = "Press [ESC] to close this menu."
				else:
					escape_desc.text = "Press [L2] to close this menu."
		else:
			if (Input.is_action_just_pressed("ui_back")) and options.can_move and cooldown <= 0:
				is_selecting = true
				AudioHandler.play_audio("Cancel")
				#print("Options Side Bar: ui cancel")
				
				tabs_obj.get_child(selected).modulate.a = 1
				tabs_obj.get_child(selected).modulate = Color(1, 1, 1)
				
				options.can_move = false
			if(!TouchControls.usingController):
				escape_desc.text = "Press [ESC] to return."
			else:
				escape_desc.text = "Press [B] to return."
	
	if cooldown > 0:
		cooldown -= delta

func change_item(amount: int = 0):
	selected += amount
	
	if selected < 0:
		selected = tab_count - 1
	if selected > tab_count - 1:
		selected = 0
	
	if(open):
		AudioHandler.play_audio("Scroll Menu")
	
	var selected_tab = tabs_obj.get_child(selected)
	
	for tab in tabs:
		if tab != selected_tab:
			tab.modulate.a = 0.6
			#tween.interpolate_property(tab, "rect_position:x", tab.rect_position.x, 10, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		else:
			tab.modulate.a = 1
			#tab.rect_position.x = 10
	
	#tween.interpolate_property(selected_tab, "rect_position:x", selected_tab.rect_position.x, selected_tab.rect_position.x + 15, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(select_square, "position", select_square.position, selected_tab.rect_position, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	
	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()
	
	for option in selected_tab.get_children():
		var new_option = option.duplicate()
		new_option.visible = true
		new_option.position = Vector2(0,0)
		
		options.add_child(new_option)
	
	options.selected = 0
	options.update_options()
	
	Discord.update_presence("In the Options Menu", "Tab: " + selected_tab.name)
