class_name IconBounce
extends Node

# stupid variables
var iconP1: Sprite
var iconP2: Sprite

var health: float = 1

var icon_beat_scale: float = 0.2

var runs_on_step: bool = false

func v(value_60, delta):
	return delta * (value_60 / (1.0 / 60.0))

# the shit you modify :D
func on_process(delta: float) -> void:
	iconP1.scale.x = lerp(iconP1.scale.x, 0.5, v(0.09, delta))
	iconP2.scale.x = lerp(iconP2.scale.x, 1.0, v(0.09, delta))
	
	iconP1.scale.y = lerp(iconP1.scale.y, 0.5, v(0.09, delta))
	iconP2.scale.y = lerp(iconP2.scale.y, 1, v(0.09, delta))
	
	iconP1.offset.x = lerp(iconP1.offset.x, 0, v(0.09, delta))
	iconP1.offset.y = lerp(iconP1.offset.y, 0, v(0.09, delta))
	
	iconP2.offset.x = lerp(iconP2.offset.x, 0, v(0.09, delta))
	iconP2.offset.y = lerp(iconP2.offset.y, 0, v(0.09, delta))

func beat_hit() -> void:
	iconP1.scale.x += icon_beat_scale
	iconP2.scale.x += icon_beat_scale
	
	if iconP1.scale.x > 1 + icon_beat_scale:
		iconP1.scale.x = 1 + icon_beat_scale
	if iconP2.scale.x > 1 + icon_beat_scale:
		iconP2.scale.x = 1 + icon_beat_scale
	
	iconP1.scale.y += icon_beat_scale
	iconP2.scale.y += icon_beat_scale
	
	if iconP1.scale.y > 1 + icon_beat_scale:
		iconP1.scale.y = 1 + icon_beat_scale
	if iconP2.scale.y > 1 + icon_beat_scale:
		iconP2.scale.y = 1 + icon_beat_scale
	
	iconP1.offset.x = 10
	iconP1.offset.y = 10
	
	iconP2.offset.x = -10
	iconP2.offset.y = 10
