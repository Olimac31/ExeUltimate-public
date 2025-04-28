extends Node2D

export(String) var save_name = "downscroll"
export(bool) var value = false

export(String) var description = ""

var is_bool = true

onready var checkbox = $Checkbox

func _ready():
	value = Settings.get_data(save_name)
	update_checkbox()
	
func update_checkbox():
	checkbox.stop()
	
	if value:
		checkbox.play("Checked")
	else:
		checkbox.play("Unchecked")

func open_option():
	value = !value
	
	if save_name == "vsync":
		OS.set_use_vsync(value)
	
	if save_name == "memory_leaks":
		if value:
			Globals.leak_memory()
		else:
			Globals.unleak_memory()
	
	if save_name == "intensiveShaders":
		GlobalShaders.set_intensive_shader_toggles(value)
	if save_name == "simpleShaders":
		GlobalShaders.set_simple_shader_toggles(value)
	if save_name == "scanlines":
		GlobalShaders.set_scanlines(value)
	
	if save_name == "fps_counter":
		Fps.update_visibility(value)
	
	if save_name == "low_detail_mode":
		GlobalShaders.queue_reboot()
	
	AudioHandler.play_audio("Toggle")
