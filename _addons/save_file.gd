extends Node

var save_file_path = "user://savegame.save"

# game_state is all the game state wrapped up in one object
# i.e. a dictionary or custom class, w/e
func save_to_file(game_state):
	var file = File.new()
	file.open(save_file_path, File.WRITE)
	file.store_var(game_state, true)
	file.close()

func load_from_file():
	var file = File.new()
	if file.file_exists(save_file_path):
		file.open(save_file_path, File.READ)
		var game_state = file.get_var(true)
		file.close()
		return game_state
