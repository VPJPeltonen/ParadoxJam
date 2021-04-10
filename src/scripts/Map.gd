extends Spatial

export (PackedScene) var Tile
export (PackedScene) var Tile2
export (PackedScene) var Tile3

var generated = false

onready var rng = RandomNumberGenerator.new()
onready var tiles = [Tile,Tile2,Tile3]

func _ready():
	rng.randomize()

func generate():
	var positions = $Positions.get_children()
	for pos in positions:
		var clone = tiles[rng.randi_range(0,tiles.size()-1)].instance()
		$Tiles.add_child(clone)
		clone.global_transform.origin = pos.global_transform.origin
		
func _process(delta):
	if !generated:
		generate()
		generated = true
