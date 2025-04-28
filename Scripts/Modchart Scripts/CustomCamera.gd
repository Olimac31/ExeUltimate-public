extends Camera2D

export(String, "Normal", "FollowChars", "Free", "Debug") var mode

export(NodePath) var bf_point
export(NodePath) var dad_point
export(NodePath) var middle_point

onready var gameplay = $"../../"

export(String, "Constant", "OnBeat") var tracking_mode

var debug_speed = 250

# Tweens
onready var tween = get_node("Tween")
var target_zoom = zoom
var changing_target_zoom = false
export var zooming_speed = 0.9
export(String, "Ease Out", "Ease In Out", "Ease Out In", "Ease In") var zoom_ease_type = "Ease Out"
export(bool) var predict_zoom_one_beat_ahead = true

# Smooth Position Tween
onready var position_tween = get_node("position_tween")
export var smooth_position_tweening = false

# Camera Bump Variables
export(bool) var camera_bumps = true
export var bump_amount = Vector2(0.015, 0.015)
export(String, "Kick", "Snare", "Kick and Snare", "Custom") var bump_mode = "Kick"
export var custom_bump_divisor = 1 # DO NOT SET TO 0


func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")



func _process(delta):
	if tracking_mode == "Constant":
		reposition_camera()
	
	if mode == "Debug":
		if Input.is_action_pressed("ui_left"):
			position.x -= debug_speed * delta
		if Input.is_action_pressed("ui_right"):
			position.x += debug_speed * delta
		if Input.is_action_pressed("ui_up"):
			position.y -= debug_speed * delta
		if Input.is_action_pressed("ui_down"):
			position.y += debug_speed * delta
		
		if Input.is_action_pressed("ui_space"):
			zoom += Vector2(0.5, 0.5) * delta
		if Input.is_action_pressed("ui_shift"):
			zoom -= Vector2(0.5, 0.5) * delta
		
		if Input.is_action_just_pressed("ui_escape"):
			print(str(position))

func beat_hit():
	if tracking_mode == "OnBeat":
		reposition_camera()
	
	# Camera Bumps
	var bump_divisor = 1
	var invert_division = false
	
	# Check the Bump Mode
	match(bump_mode):
		"Kick":
			bump_divisor = 2
		"Snare":
			bump_divisor = 2
			invert_division = true
		"Kick and Snare":
			bump_divisor = 1
		"Custom":
			if custom_bump_divisor > 0:
				bump_divisor = custom_bump_divisor
	
	# Bump the camera
	if camera_bumps and Settings.get_data("cameraZooms"):
		if !invert_division:
			if Conductor.curBeat % bump_divisor == 0:
				bump_camera()
		else:
			if !(Conductor.curBeat % bump_divisor == 0):
				bump_camera()
	
	# Set Zoom to Target Zoom
	#if zoom != target_zoom:
		#change_zoom(target_zoom, zooming_speed)

func bump_camera():
	if !changing_target_zoom:
		var value = target_zoom.x - bump_amount.x
		set_zoom(Vector2(value, value))
		restore_zoom_after_bump()

func reposition_camera():
	match(mode):
		"FollowChars":
			var target_pos = Vector2(0, 0)
			
			# Check if section is must hit
			if gameplay.must_hit_section:
				if bf_point is NodePath:
					target_pos = get_node(bf_point).position
				else:
					target_pos = bf_point.position
			else:
				if dad_point is NodePath:
					target_pos = get_node(dad_point).position
				else:
					target_pos = dad_point.position
			
			# Go to target pos
			if !smooth_position_tweening:
				position = target_pos
			else:
				position_tween.interpolate_property(self, "position", position, target_pos, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				position_tween.start()
		"Normal":
			# Crappy temporary fix
			if middle_point is NodePath:
				position = get_node(middle_point).position
			else:
				position = middle_point.position
		"Free":
			pass

func change_zoom(var new_zoom = 1.0, var time = zooming_speed, var trans_type = Tween.TRANS_QUAD, var ease_type = Tween.EASE_OUT, var ignore_ease_type = false):
	if !ignore_ease_type: # Useful for camera bumps
		match(zoom_ease_type):
			"Ease Out":
				pass
			"Ease In Out":
				ease_type = Tween.EASE_IN_OUT
				trans_type = Tween.TRANS_QUAD
			"Ease Out In":
				ease_type = Tween.EASE_OUT_IN
			"Ease In":
				ease_type = Tween.EASE_IN
	
	tween.stop_all()
	tween.interpolate_property(self, "zoom", zoom, new_zoom, time, trans_type, ease_type)
	tween.start()

func restore_zoom_after_bump():
	change_zoom(target_zoom, zooming_speed * 0.75, Tween.TRANS_QUINT, Tween.EASE_OUT, true)

func _on_Tween_tween_completed(object, key):
	changing_target_zoom = false
