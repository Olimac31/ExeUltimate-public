extends Node


onready var gameplay = $"../../"

var character_to_kill
var hp = 3
var max_hp = 5
var died = false
onready var health_bar = get_node("CanvasLayer/healthbar")
onready var health_utilities = get_parent().get_node("healthUtilities")

var invincibility_frames = 0
var invincibility_frames_MAX = 1.8

onready var miss_sfx = get_node("missSFX")


# Called when the node enters the scene tree for the first time.
func _ready():
	gameplay.connect("missed_a_note", self, "on_miss")
	gameplay.miss_sounds = false
	
	character_to_kill = gameplay.get_node("bf")
	
	health_utilities.connect("died", self, "on_death")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("keyShift"):
		on_miss()
	
	if invincibility_frames > 0:
		invincibility_frames -= delta
	
	health_bar.value = hp

func on_miss():
	if !died:
		gameplay.health = 1

		if invincibility_frames <= 0:
			miss_sfx.play()
			invincibility_frames = invincibility_frames_MAX
			hp -= 1
			
			if hp > 0:
				character_to_kill.get_hurt(invincibility_frames_MAX)
	
	if hp <= 0:
		commit_die()

func regain_health():
	if hp + 1 <= max_hp:
		hp += 1

# kill
func commit_die():
	died = true
	gameplay.health = 0

# actually die
func on_death():
	character_to_kill.die()
	AudioHandler.stop_audio("Voices")
	AudioHandler.fade_out("Inst", 2.5)
	gameplay.player_strums.position.x = 9999
	gameplay.miss_sounds = false
