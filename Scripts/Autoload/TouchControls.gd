extends Node2D

## TOUCH CONTROLS AND JOYSTICK SUPPORT

var forceTouchControls = false

var menuButtons
var gameplayButtons
var canvas

var usingController = false

var hidden = false


# Called when the node enters the scene tree for the first time.
func _ready():
	canvas = get_node("CanvasLayer")
	
	#Check if this is a mobile platform
	if !(forceTouchControls):
		if(OS.get_name() != "Android"):
			canvas.visible = false
	else:
		canvas.visible = true
	
	menuButtons = get_node("CanvasLayer/menu_buttons")
	gameplayButtons = get_node("CanvasLayer/gameplay_buttons")

func _input(event):
	
	# Check if the input comes from the keyboard, screen
	# or the controller
	# (Very useful for UI Menus)
	if(event is InputEventKey):
		usingController = false
	elif(event is InputEventJoypadButton):
		usingController = true
	elif(event is InputEventScreenTouch):
		usingController = false

func _process(delta):
	#print(event.as_text())
	
	# This could be refactored with a for but eh it works lol
	if(Input.is_action_pressed("joystick_0")):
		press_gameplay_button("0")
	if(Input.is_action_just_released("joystick_0")):
		release_gameplay_button("0")
		
	if(Input.is_action_pressed("joystick_1")):
		press_gameplay_button("1")
	if(Input.is_action_just_released("joystick_1")):
		release_gameplay_button("1")

	if(Input.is_action_pressed("joystick_2")):
		press_gameplay_button("2")
	if(Input.is_action_just_released("joystick_2")):
		release_gameplay_button("2")

	if(Input.is_action_pressed("joystick_3")):
		press_gameplay_button("3")
	if(Input.is_action_just_released("joystick_3")):
		release_gameplay_button("3")

func press_gameplay_button(number):
	var joy = InputEventAction.new()
	joy.action = "gameplay_" + number
	joy.pressed = true
	Input.parse_input_event(joy)
	
func release_gameplay_button(number):
	var joy = InputEventAction.new()
	joy.action = "gameplay_" + number
	joy.pressed = false
	Input.parse_input_event(joy)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func swap_button_set():
	if !hidden:
		menuButtons.visible = !menuButtons.visible
		gameplayButtons.visible = !gameplayButtons.visible


func _on_touchSettings_pressed():
	swap_button_set()

func forceTouch():
	canvas.visible = true


func _on_touchConfirm_pressed():
	Input.action_press("ui_confirm")

func _on_touchConfirm_released():
	Input.action_release("ui_confirm")


func _on_touchCancel_pressed():
	Input.action_press("ui_cancel")

func _on_touchCancel_released():
	Input.action_release("ui_cancel")


func _on_touchHide_pressed():
	if !hidden:
		menuButtons.visible = false
		gameplayButtons.visible = false

		hidden = true
		get_node("CanvasLayer/global_buttons/touchHide/Label").text = "(-)"
	else:
		menuButtons.visible = true
		gameplayButtons.visible = false

		hidden = false
		get_node("CanvasLayer/global_buttons/touchHide/Label").text = "(O)"
