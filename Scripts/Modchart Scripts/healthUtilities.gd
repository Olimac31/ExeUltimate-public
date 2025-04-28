extends Node


onready var gameplay = $"../../"

# HEALTH DRAIN ------------------------------------
export var health_drain = false

export var health_drain_has_minimum = true
export var health_drain_minimum = 0.2

export var health_drain_damage = 0.01
export var health_drain_type = "on_note_hit"
# Types: "on_note_hit", "poison"

# CUSTOM DEATH HANDLING --------------------------
export var prevent_instant_death = false
signal died


func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")
	Globals.connect("enemy_note_hit", self, "on_enemy_note_hit")
	
	gameplay.prevent_instant_death = prevent_instant_death
	if prevent_instant_death:
		gameplay.connect("reached_zero_hp", self, "on_zero_hp")


func _process(delta):
	if(health_drain and health_drain_type == "poison"):
		drain_health()


func on_enemy_note_hit(var note, var dir, var type, var character):
	if(health_drain and health_drain_type == "on_note_hit"):
		drain_health()


func beat_hit():
	pass


func drain_health():
	# Check if there's a minimum health limiter
	if !health_drain_has_minimum:
		gameplay.health -= health_drain_damage
	else:
		if gameplay.health > health_drain_minimum:
			gameplay.health -= health_drain_damage

func on_zero_hp():
	emit_signal("died")

#func on_death():
#	Scenes.switch_scene("Gameplay")
