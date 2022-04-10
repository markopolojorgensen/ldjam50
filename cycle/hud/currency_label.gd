extends Label

func _process(_delta):
	text = "$%03.1f" % global.currency
