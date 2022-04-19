extends LinkButton


func _ready():
	connect("pressed", self, "do_link")

func do_link():
	OS.shell_open("https://managore.itch.io/m3x6")






