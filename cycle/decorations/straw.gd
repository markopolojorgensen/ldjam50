extends Sprite


export(bool) var dark = false

func _ready():
	if dark:
		frame = 1
		$line_2d.default_color = Color("000c05")
	else:
		frame = 0
		$line_2d.default_color = Color("095d07")
	
	if $position_2d != null:
		$line_2d.add_point($line_start.position)
		$line_2d.add_point($position_2d.position)

