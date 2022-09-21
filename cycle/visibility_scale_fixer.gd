tool
extends VisibilityNotifier2D

export(bool) var fix_it setget set_fix_it

func _ready():
	if Engine.editor_hint:
		return
	
	if scale != Vector2(1,1):
		print("yikes! visibility notifier borked: %s" % get_parent().name)

func set_fix_it(new_value):
	fix_it = new_value
	if fix_it:
		rect.size *= scale
		rect.position = -0.5 * rect.size
		scale = Vector2(1, 1)



