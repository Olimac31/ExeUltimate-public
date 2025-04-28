extends CanvasLayer

var textwriter_script = TextWriter.get_node("UI")
onready var canvas_modulate = get_node("CanvasModulate")

onready var txt_front = get_node("text-front")
onready var txt_back = get_node("text-back")
onready var name_front = get_node("name-front")
onready var name_back = get_node("name-back")
onready var continue_button = get_node("continue")

# Called when the node enters the scene tree for the first time.
func _ready():
	textwriter_script.connect("started_textbox", self, "on_textbox_start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	canvas_modulate.color = textwriter_script.modulate
	
	txt_front.percent_visible = textwriter_script.message_label.percent_visible
	txt_back.percent_visible = txt_front.percent_visible
	
	continue_button.visible = textwriter_script.press_to_continue.visible


func on_textbox_start():
	txt_front.parse_bbcode(textwriter_script.raw_message)
	txt_back.parse_bbcode(textwriter_script.raw_message)
	name_front.parse_bbcode(textwriter_script.raw_charname + ":[/color]")
	name_back.parse_bbcode(textwriter_script.raw_charname + ":[/color]")
