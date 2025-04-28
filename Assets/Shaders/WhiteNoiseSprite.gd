extends TextureRect


# Declare member variables here. Examples:
# var a = 2
var timer = 0;
export var timerMAX = 0.07;
var phase = 0;
export var activated = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated:
		timer += 1 * delta;
		 #If timer goes off
		if(timer >= timerMAX):
			#Change phase
			if(phase < 3):
				phase += 1
			else:
				phase = 0
			
			phaseChanges(); #Apply phase changes
			timer = 0; #reset timer

func phaseChanges():
	match(phase):
		0:
			flip_h = false
			flip_v = false
		1:
			flip_h = true
			flip_v = false
		2:
			flip_h = false
			flip_v = true
		3:
			flip_h = true
			flip_v = true
