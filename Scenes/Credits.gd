extends Node2D

# STATE MACHINE
var state = "spawning"
# spawning, choosing, waiting, exiting
var chosen_name = 0
var chosen # holds object itself

# Credits
export var credits_list = [
	"olimac31",
	"totallynotdumb",
	"trainsgod",
	"jukoduko",
	"forfurthernotice",
	"purblebun",
	"astromaxitox",
	"borupen",
	"therealchoccy",
	"fieroso",
	"indeednotfunny",
	"leather128",
	"godotcredits",
	"specialthanks",
	"moremods"
	]

export(PackedScene) var credit_name_template

# UI Objects
onready var person_name = get_node("info/name")
onready var person_roles = get_node("info/roles")
onready var description = get_node("info/desc")
onready var icon = get_node("info/icon")

onready var names = get_node("names")
onready var square = get_node("square")
onready var tween = get_node("Tween")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	spawn_names()
	if !AudioHandler.get_node("Credits").is_playing():
		AudioHandler.play_audio("Credits")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	Discord.update_presence("On the Credits Menu", "Thanks for playing!")
	
	if Settings.get_data("low_detail_mode"):
		get_node("bg-filter").queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_behavior()



func spawn_names():
	var separation = 70
	var starting_point = Vector2(0, 0)
	
	var i = 0
	for person in credits_list:
		var new_person = credit_name_template.instance()
		
		new_person.credit_data = load("res://Scenes/Credits/people/" + person + ".tres")
		
		new_person.position.x = starting_point.x
		new_person.position.y = starting_point.y + (separation * i)
		
		names.add_child(new_person)
		i += 1
		
		new_person.update_data()
		
		change_state("choosing")
		#print("Credits: Added " + person + " to the scene!")


func change_state(var new_state):
	state = new_state
	
	match(state):
		"choosing":
			update_credit_data()
		"waiting":
			pass
		"exiting":
			AudioHandler.fade_out("Credits")
			Scenes.switch_scene("res://Scenes/exe_title.tscn")
		"moremods":
			Scenes.switch_scene("res://Scenes/Credits/more-mods.tscn")

func state_behavior():
	match(state):
		"choosing":
			# Scroll through names
			if Input.is_action_just_pressed("ui_down"):
				if chosen_name < names.get_child_count() - 1:
					chosen_name += 1
				else:
					chosen_name = 0
				update_credit_data()

			if Input.is_action_just_pressed("ui_up"):
				if chosen_name > 0:
					chosen_name -= 1
				else:
					chosen_name = names.get_child_count() - 1
				update_credit_data()
			
			# Interact with names
			if Input.is_action_just_pressed("ui_accept"):
				var random_dumb_chance = rng.randi_range(1, 10)
				
				# Open link
				if chosen.credit_data.open_link_on_interact:
					# Normal
					if chosen.credit_data.person_name != "TotallyNotDumb":
						OS.shell_open(chosen.credit_data.interact_link)
					# Dumb random chance thingy
					else:
						if random_dumb_chance == 10:
							OS.shell_open("https://youtu.be/dQw4w9WgXcQ")
						else:
							OS.shell_open(chosen.credit_data.interact_link)
					
					AudioHandler.play_audio("Confirm Sound")
				else:
					custom_credit_interactions()
			
			# Exit
			if Input.is_action_just_pressed("ui_back") or Input.is_action_just_pressed("ui_cancel"):
				change_state("exiting")
		"waiting":
			pass
		"exiting":
			pass
		"spawning":
			pass
		"moremods":
			pass

func update_credit_data():
	chosen = names.get_child(chosen_name)
	var chosen_creditdata = chosen.credit_data
	
	
	for person in names.get_children():
		person.make_unchosen()
	
	chosen.make_chosen()
	
	person_name.parse_bbcode(chosen_creditdata.person_name)
	person_name.modulate = chosen_creditdata.user_color
	person_roles.parse_bbcode("[color=gray]" + chosen_creditdata.roles)
	description.parse_bbcode(chosen_creditdata.description)
	icon.animation = chosen_creditdata.icon_name
	
	tween.interpolate_property(square, "position", square.position, chosen.position + names.position, 0.2, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	
	AudioHandler.play_audio("Toggle")


func _on_desc_meta_clicked(meta):
	# `meta` is not guaranteed to be a String, so convert it to a String
	# to avoid script errors at run-time.
	OS.shell_open(str(meta))


func custom_credit_interactions():
	if chosen.credit_data.person_name == "MORE GAMES":
		change_state("moremods")
