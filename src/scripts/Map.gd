extends Spatial

export (PackedScene) var Tile

var generated = false

func generate():
	var positions = $Positions.get_children()
	for pos in positions:
		var clone = Tile.instance()
		$Tiles.add_child(clone)
		clone.global_transform.origin = pos.global_transform.origin
		
func _process(delta):
	if !generated:
		generate()
		generated = true
