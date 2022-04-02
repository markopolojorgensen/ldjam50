extends Path2D

export(Texture) var triangle_texture

func _ready():
	var baked_points = curve.get_baked_points()
	for i in range(baked_points.size()):
		var point : Vector2 = baked_points[i]
		$line_2d.add_point(point)
		var sprite = Sprite.new()
		sprite.texture = triangle_texture
		sprite.hframes = 10
		sprite.frame = randi() % 10
		sprite.offset.y = 3
		add_child(sprite)
		sprite.position = point
		
		if (0 < i) and (i < (baked_points.size() - 1)):
			var perp = baked_points[i+1] - baked_points[i-1]
			# var normal = perp.rotated(PI/2)
			sprite.rotation = perp.angle()
		
		
		
		





