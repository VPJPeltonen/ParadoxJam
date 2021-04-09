extends Camera

var speed :int = 10
onready var player = get_tree().get_nodes_in_group("Player")[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = Vector3(global_transform.origin.x,
						player.global_transform.origin.y+2,
						player.global_transform.origin.z)
	global_transform.origin = global_transform.origin.linear_interpolate(target,delta*speed)
