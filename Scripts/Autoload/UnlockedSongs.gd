extends Node2D

# This savefile contains only info about unlocked songs

var og_save: Dictionary = {
	"too-goofy": true,
	"too-goofy-cleared": false,
	"test": false,
	"tutorial": true,
	"bopeebo": true,
	"xagtheme": false
}

var save: Dictionary = {}
var save_file = File.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	var file_exists = false
	# Check if savefile exists first
	# If it does, load it into the local save
	if save_file.file_exists("user://UnlockedSongs.json"):
		load_data()
		file_exists = true
	
	# Ensure compatibility for future releases of the mod
	for key in og_save.keys():
		if !save.has(key): save[key] = og_save[key]
	
	if !file_exists:
		save_data()

# Change value in the local save
func set_data(key: String, value):
	save[key] = value

# Get value from the local save
func get_data(key):
	return save[key]

func save_data():
	# Save all the data that has been modified
	# (It will overwrite the savefile entirely)
	save_file.open("user://UnlockedSongs.json", File.WRITE)
	save_file.store_line(to_json(save))
	save_file.close()

func load_data():
	if save_file.file_exists("user://UnlockedSongs.json"):
		save_file.open("user://UnlockedSongs.json", File.READ)
		save = JSON.parse(save_file.get_as_text()).result
		save_file.close()

func reset_data():
	for key in og_save.keys():
		if save.has(key):
			save[key] = og_save[key]

func save_exists():
	if save_file.file_exists("user://UnlockedSongs.json"):
		return true
	else:
		return false
