extends Node

onready var hitsound = $Hitsound

# Music fadeout variables
onready var tween_out = get_node("Tween")
onready var tween_in = get_node("TweenIn")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var musicArray = [];
onready var overworld_music = get_node("Overworld")

func _ready():
	#hitsound.stream = load("res://Assets/Sounds/Hitsounds/" + Settings.get_data("hitsound") + ".ogg")
	musicArray.resize(99);
	musicArray[0] = preload("res://Assets/Sounds/Title Screen/freakyMenu.ogg");
	musicArray[1] = preload("res://Assets/Sounds/Title Screen/freakyNightMenu.ogg");
	#musicArray[X] = preload("res://Music/HD OST - Spawn_1.ogg");
	#musicArray[X].loop = false;
	musicArray[2] = preload("res://Assets/Sounds/Title Screen/title.ogg");
	musicArray[3] = preload("res://Assets/Sounds/xag_theme.ogg")

func play_audio(audioName, startTime = 0.0,speed = 1):
	if get_node(audioName) != null and audioName != "Hitsound":
		get_node(audioName).pitch_scale = speed
		get_node(audioName).play(startTime)
	
	if audioName == "Hitsound":
		get_node(audioName + "-" + Settings.get_data("hitsound")).pitch_scale = speed
		get_node(audioName + "-" + Settings.get_data("hitsound")).play(startTime)


func stop_audio(audioName):
	if get_node(audioName) != null:
		get_node(audioName).stop()


func get_audio_playback(audioName):
	if get_node(audioName) != null:
		return get_node(audioName).get_playback_position()


func stopCountdownBug():
	stop_audio("Countdown/3")
	stop_audio("Countdown/2")
	stop_audio("Countdown/1")
	stop_audio("Countdown/Go")


# Music Fadeout --------------------------------------
func fade_out(audioName, myTime = transition_duration):
		# tween music volume down to 0
	if get_node(audioName) != null:
		tween_out.interpolate_property(get_node(audioName), "volume_db", 0, -80, myTime, transition_type, Tween.EASE_IN, 0)
		tween_out.start()
		# when the tween ends, the music will be stopped

func fade_in(var audioName, var myTime = transition_duration, var end_volume = 0):
	if get_node(audioName) != null:
		get_node(audioName).volume_db = -80
		get_node(audioName).play()
		
		tween_in.stop_all()
		tween_in.interpolate_property(get_node(audioName), "volume_db", -80, end_volume, myTime, Tween.TRANS_SINE, Tween.EASE_IN) 
		tween_in.start()

func _on_Tween_tween_completed(object, key):
	# stop the music -- otherwise it continues to run at silent volume
	object.stop()
	object.volume_db = 0 # reset volume


func change_overworld_song(songToPlay):
	if(overworld_music.stream != musicArray[songToPlay]):
		overworld_music.stream = musicArray[songToPlay];
	play_overworld_song()

func play_overworld_song():
	if(!overworld_music.playing):
		overworld_music.play();
