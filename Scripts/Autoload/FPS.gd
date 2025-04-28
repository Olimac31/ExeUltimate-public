extends CanvasLayer

var vram: float = 0.0

var mem: float = 0.0
var mem_peak: float = 0.0

onready var debug: bool = OS.is_debug_build()

onready var fps_text = $fps

var delta_fps: float = 0

var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	
	timer.start(0.25)
	timer.connect("timeout", self, "_update")
	
	_update()
	
	update_visibility(Settings.get_data("fps_counter"))

#func _input(event):
#	if Input.is_action_just_pressed("ui_shift") and debug:
#		visible = !visible

func _update():
	vram = Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 104857.6
	
	fps_text.parse_bbcode(str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS")
	
	if debug:
		mem = Performance.get_monitor(Performance.MEMORY_STATIC) / 104857.6
		mem_peak = Performance.get_monitor(Performance.MEMORY_STATIC_MAX) / 104857.6
	
		fps_text.append_bbcode("\n" + str(round(mem) / 10) + "MB [color=gray]/ " + str(round(mem_peak) / 10) + "MB[/color]")
	
	fps_text.append_bbcode("\n" + str(round(vram) / 10) + "MB (VRAM)")
	#fps_text.append_bbcode("\nVs. Sonic.EXE ULTIMATE")

func update_visibility(var value):
	visible = value
