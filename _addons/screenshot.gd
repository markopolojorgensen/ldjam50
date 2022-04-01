extends Node

func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		get_tree().set_input_as_handled()
		screenshot()

func screenshot():
	# get screen capture
	var capture = get_viewport().get_texture().get_data()
	capture.flip_y()
	
	# get unused screenshot number
	var file_checker = File.new()
	var i = 0
	var file_name = "user://screenshot_%03d.png" % i
	# only supports 1000 screenshots?
	while file_checker.file_exists(file_name):
		i += 1
		file_name = "user://screenshot_%03d.png" % i
	
	# save to a file
	capture.save_png(file_name)
	
	print("screenshot saved in %s  (%s)" % [str(OS.get_user_data_dir()), file_name])
