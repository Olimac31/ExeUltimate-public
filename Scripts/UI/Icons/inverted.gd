extends IconBounce

# the shit you modify :D
func on_process(delta: float) -> void:
	iconP1.scale.x = lerp(iconP1.scale.x, -1, v(0.15, delta))
	iconP2.scale.x = lerp(iconP2.scale.x, -1, v(0.15, delta))
	
	iconP1.scale.y = lerp(iconP1.scale.y, -1, v(0.15, delta))
	iconP2.scale.y = lerp(iconP2.scale.y, -1, v(0.15, delta))
	
	iconP1.offset.x = lerp(iconP1.offset.x, 0, v(0.15, delta))
	iconP1.offset.y = lerp(iconP1.offset.y, 0, v(0.15, delta))
	
	iconP2.offset.x = lerp(iconP2.offset.x, 0, v(0.15, delta))
	iconP2.offset.y = lerp(iconP2.offset.y, 0, v(0.15, delta))

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
	
	if iconP1.scale.x > 0:
		iconP1.scale -= Vector2(icon_beat_scale, icon_beat_scale)
		iconP2.scale -= Vector2(icon_beat_scale, icon_beat_scale)
