extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var crt = get_node("crt")
onready var crt_overlay = get_node("overlay")
onready var scanlines = get_node("scanlines")

export(PackedScene) var reboot_message
var instanced_reboot_message = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_intensive_shader_toggles(Settings.get_data("intensiveShaders"))
	set_simple_shader_toggles(Settings.get_data("simpleShaders"))
	set_brightness(Settings.get_data("brightness"))
	set_contrast(Settings.get_data("contrast"))
	set_scanlines(Settings.get_data("scanlines"))
	
	# Test
	if Settings.get_data("low_detail_mode"):
		delete_all_shaders()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_intensive_shader_toggles(var value = true):
	#crt.visible = value
	if get_node("overlay") != null:
		crt_overlay.visible = value
		crt.get_node("ColorRect").material.set_shader_param("activated", value)

func set_simple_shader_toggles(var value = true):
	set_noise(value)

func set_brightness(var value = 1.0):
	if get_node("brightness_contrast") != null:
		get_node("brightness_contrast/ColorRect").material.set_shader_param("brightness", value)

func set_contrast(var value = 1.0):
	if get_node("brightness_contrast") != null:
		get_node("brightness_contrast/ColorRect").material.set_shader_param("contrast", value)

func set_scanlines(var value = true):
	if get_node("scanlines") != null:
		get_node("scanlines").visible = value

func set_noise(var value = true):
	if get_node("noise/texture") != null:
		get_node("noise/texture").visible = value
	
func delete_all_shaders():
	for child in get_children():
		child.queue_free()

func queue_reboot():
	if !instanced_reboot_message:
		var new_reboot_message = reboot_message.instance()
		add_child(new_reboot_message)
		
		instanced_reboot_message = true
