extends CanvasLayer


# Declare member variables here. Examples:
var open = false
onready var blurCanvas = get_node("blurCanvas")
signal options_closed

onready var animplayer = get_node("AnimationPlayer")

var cooldown = 0
var cooldownMAX = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	blurCanvas.visible = false
	if Settings.get_data("low_detail_mode"):
		get_node("blurCanvas/BGBlur").queue_free()
	#openMenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(cooldown > 0):
		cooldown -= 1

func openMenu():
	open = true
	#visible = true
	blurCanvas.visible = true
	animplayer.play("open")
	cooldown = cooldownMAX

func closeMenu():
	open = false
	#visible = false
	emit_signal("options_closed")
	#get_parent().get_node("Options").on_options_closed()
	blurCanvas.visible = false
	animplayer.play("close")
