extends Area

var path = []
var start_pos
var t = 0.0
var point = 0
var speed = 2
var started = false
var spawn_pos

func _process(delta):
	if !Game.running:
		return
	if path.empty():
		return
	if !started:
		return
	if point >= path.size():
		return
	t += delta * 20
	global_transform.origin = start_pos.linear_interpolate(path[point], t)
	print(t)
	if global_transform.origin.distance_to(path[point]) < 0.1 or t > 1:
		start_pos = global_transform.origin
		point += 1
		print("next point" + str(point))
		t = 0.0
	#print(str(global_transform.origin) + "/" + str(path[point]))

func init(data):
	path = data
	global_transform.origin = path[0]
	start_pos = path[0]
	point = 1
	spawn_pos = global_transform.origin

func reset():
	started = false
	global_transform.origin = spawn_pos
	point = 1
	t = 0.0

func _on_Area_body_entered(body):
	#print("stuff")
	if body.is_in_group("Player"):
		body.start_recording()
		started = true

func _on_Ghost_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
