extends Node


onready var gameplayNode = $"../../"

onready var ratings_text = get_node("ratings/text")
onready var health_bar = get_node("ratings/ProgressBar")

onready var tween = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_gameplay_ui_visibility(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ratings_text.parse_bbcode(gameplayNode.get_node("UI/Gameplay Text/Ratings").text)

func set_gameplay_ui_visibility(var value = false):
	gameplayNode.player_strums.visible = true
	gameplayNode.player_strums.position.x = 468
	
	gameplayNode.enemy_strums.visible = value
	gameplayNode.enemy_strums.position.x -= 1280
	
	gameplayNode.gameplay_text.visible = value
	gameplayNode.health_bar.visible = value
	gameplayNode.progress_bar.visible = value
	gameplayNode.get_node("UI/backdrop").visible = false
	gameplayNode.get_node("UI/Ratings").visible = false
	gameplayNode.get_node("UI/Ratings").position.x += 2000
	
	ratings_text.parse_bbcode(gameplayNode.get_node("UI/Gameplay Text/Ratings").text)


func _on_Timer_timeout():
	tween.interpolate_property(health_bar, "value", health_bar.value, gameplayNode.health, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
