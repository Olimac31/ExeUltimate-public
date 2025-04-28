extends Node2D

export(String) var direction: String = 'left'
export(int) var note_data: int = 0

export(float) var strum_time: float = 0.0

var strum_y: float = 0.0
var is_player: bool = false

var being_pressed: bool = false
var been_hit: bool = false
var is_sustain: bool = false
var sustain_length: float = 0.0
var og_sustain_length: float = 0.0

var time_held: float = 0.0

onready var game = $"../../../"

onready var line = $Line2D

var held_sprites: Dictionary = Globals.held_sprites

var character: int = 0

var strum: Node2D

onready var opponent_note_glow = Settings.get_data("opponent_note_glow")
onready var downscroll = Settings.get_data("downscroll")

onready var hitsounds = Settings.get_data("hitsounds")

onready var new_sustain_animations = Settings.get_data("new_sustain_animations")

onready var animated_sprite = $AnimatedSprite

var is_alt: bool = false

# use if multiple textures
export(String) var custom_sus_path

# use if only one texture lmao
export(Texture) var single_held_texture: Texture
export(Texture) var single_end_held_texture: Texture

# custom properties
export(float) var hit_damage: float = 0.0
export(float) var hit_sustain_damage: float = 0.0

export(float) var miss_damage: float = 0.07

export(bool) var should_hit: bool = true
export(bool) var cant_miss: bool = false

export(float, 0.01, 1.0, 0.01) var hitbox_multiplier: float = 1.0

# other shit

onready var player_strums = get_node("../../Player Strums")
onready var enemy_strums = get_node("../../Enemy Strums")

onready var voices = AudioHandler.get_node("Voices")

var dad_anim_player: AnimationPlayer
var bf_anim_player: AnimationPlayer

var note_frames: SpriteFrames

onready var note_render_style: String = Settings.get_data("note_render_style")

onready var line_2d: Line2D = $Line2D

func _ready():
	play_animation("")
	
	if game.dad:
		dad_anim_player = game.dad.get_node("AnimationPlayer")
	if game.bf:
		bf_anim_player = game.bf.get_node("AnimationPlayer")
	
	if note_render_style == "manual" and animated_sprite is AnimatedSprite:
		note_frames = animated_sprite.frames
		animated_sprite.queue_free()
		animated_sprite = null
	
	if game.is_pixel_song:
		line.default_color = Color(1, 1, 1, 1)

func set_held_note_sprites():
	if custom_sus_path:
		held_sprites = {}
		
		for texture in Globals.held_sprites:
			if not texture in held_sprites:
				held_sprites[texture] = []
			
			held_sprites[texture][0] = load(custom_sus_path + texture + " hold0000.png")
			held_sprites[texture][1] = load(custom_sus_path + texture + " hold end0000.png")
	elif single_held_texture and single_end_held_texture:
		held_sprites = {}
		
		for texture in Globals.held_sprites:
			if not texture in held_sprites:
				held_sprites[texture] = []
			
			held_sprites[texture].push_back(single_held_texture)
			held_sprites[texture].push_back(single_end_held_texture)

func play_animation(anim, force = true):
	if animated_sprite is AnimatedSprite:
		if force or animated_sprite.frame == animated_sprite.animation.length():
			animated_sprite.play(direction + anim)

func _process(delta):
	if is_sustain:
		if og_sustain_length == 0:
			og_sustain_length = sustain_length
	
	if strum == null:
		if is_player:
			strum = player_strums.get_child(note_data)
		else:
			strum = enemy_strums.get_child(note_data)
	
	var multiplier:float = 1
	
	if downscroll:
		multiplier = -1
	
	if is_sustain:
		if being_pressed:
			if animated_sprite:
				animated_sprite.visible = false
			
			sustain_length -= (delta * 1000.0) * Globals.song_multiplier
			
			var anim_val = 0.15
			
			if game.dad:
				if new_sustain_animations:
					if !is_player:
						if not "is_group_char" in game.dad:
							if dad_anim_player.current_animation_length < 0.15:
								anim_val = dad_anim_player.current_animation_length
					else:
						if not "is_group_char" in game.bf:
							if bf_anim_player.current_animation_length < 0.15:
								anim_val = bf_anim_player.current_animation_length
			
			if !is_player:
				if opponent_note_glow:
					strum.play_animation("confirm", true)
				
				var good: bool = false
				
				if game.dad:
					if "is_group_char" in game.dad:
						if character <= len(game.dad.get_children()) - 3:
							good = game.dad.get_children()[character].get_node("AnimationPlayer").get_current_animation_position() >= anim_val
					else:
						good = dad_anim_player.get_current_animation_position() >= anim_val
				else:
					good = true
				
				if !new_sustain_animations:
					good = true
				
				if good:
					if game.dad:
						if character != 0:
							game.dad.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper(), true, character)
						else:
							game.dad.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper(), true)
						
						if is_alt:
							if character != 0:
								game.dad.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper() + "-alt", true, character)
							else:
								game.dad.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper() + "-alt", true)
						
						game.dad.timer = 0
					
					voices.volume_db = 0
			else:
				var good: bool = false
				
				if time_held >= 0.15:
					good = true
					time_held = 0
				
				if game.bf:
					if good or not new_sustain_animations:
						if character != 0:
							game.bf.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper(), true, character)
						else:
							game.bf.play_animation("sing" + Globals.dir_to_animstr(direction).to_upper(), true)
					
						game.bf.timer = 0
				
				if good:
					strum.play_animation("static", true)
					
					if should_hit:
						strum.play_animation("confirm", true)
					else:
						strum.play_animation("press", true)
					
					voices.volume_db = 0
					
					if should_hit:
						game.health += 0.02
					else:
						game.health -= hit_sustain_damage
		
		var y_pos = ((sustain_length / 1.5) * Globals.scroll_speed) / scale.y
		if game.is_pixel_song:
			y_pos = ((sustain_length * 1) * Globals.scroll_speed) / scale.y
			
		y_pos -= held_sprites[direction][1].get_height()
		
		line.points[1].y = y_pos * multiplier
		
		if sustain_length <= 0:
			queue_free()
		else:
			time_held += delta * Globals.song_multiplier
			update()
	 
	strum_y = strum.global_position.y
	modulate.a = strum.modulate.a
	global_position.x = strum.global_position.x
	
	if !being_pressed:
		global_position.y = strum_y - ((0.45 * (Conductor.songPosition - strum_time) * Globals.scroll_speed) * multiplier)
	else:
		global_position.y = strum_y
	
	if global_position.y > -100 and global_position.y < 820:
		visible = true
	else:
		visible = false

func _draw():
	if !being_pressed and note_render_style == "manual" and note_frames:
		var texture = note_frames.get_frame(direction, 0)
		
		if !game.is_pixel_song:
			draw_texture_rect(texture, Rect2(Vector2(texture.get_width() * -1, texture.get_height() * -1), texture.get_size()), false)
		else:
			draw_texture_rect(texture, Rect2(Vector2(texture.get_width() * -1, texture.get_height() * -1), texture.get_size()), false)
	
	if is_sustain:
		var end_texture = held_sprites[direction][1]
		
		# the funny thing that controls end note position (and size)
		var rect = Rect2(Vector2(-25,0), Vector2(50,0))

		rect.size.y = end_texture.get_height()
		rect.size.x *= line.scale.x
		rect.position.x *= line.scale.x
		rect.position.y = line.points[1].y
		
		var multiplier = 1
		
		if downscroll:
			multiplier = -1
			rect.size.y *= -1
			rect.position.y -= -rect.size.y
		
		if line.points[1].y * multiplier < 0:
			rect.size.y -= abs(line.points[1].y) * multiplier
			
			if multiplier == 1:
				rect.position.y += abs(line.points[1].y)
		
		if !game.is_pixel_song:
			draw_texture_rect(end_texture, rect, true, line.default_color)
		
		if line.points[1].y * multiplier < 0:
			line.points[1].y = 0

func note_hit():
	if is_player and hitsounds:
		AudioHandler.play_audio("Hitsound")
	
	pass

func note_miss():
	pass
