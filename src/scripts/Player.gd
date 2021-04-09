extends KinematicBody

var speed: int = 100
var velocity: Vector3 = Vector3(0,0,0)
var jump_power :Vector3= Vector3(0,0,0)
var fall_power :Vector3= Vector3(0,0,0)
var jump_ready :bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var dir :Vector3 = velocity*0.9
	if Input.is_action_pressed("left"):
		dir += Vector3(0,0,1)*speed
	elif Input.is_action_pressed("right"):
		dir -= Vector3(0,0,1)*speed
	if Input.is_action_pressed("jump") and $Feet.get_overlapping_bodies().size() > 1 and jump_ready:
		jump_power += Vector3(0,300,0)
		$CPUParticles.emitting = true
		jump_ready = false
		$JumpCooldown.start()
	elif Input.is_action_pressed("jump") and $WallJumpRange.get_overlapping_bodies().size() > 1 and jump_ready:
		jump_power += Vector3(0,300,0)
		jump_ready = false
		$JumpCooldown.start()
		fall_power = fall_power/2
	if $Feet.get_overlapping_bodies().size() <= 1:
		fall_power -= Game.gravity
	else:
		print("grounded")
		dir = Vector3(dir.x,0,dir.z)
		fall_power = Vector3(0,0,0)
	dir += jump_power
	dir += fall_power
	jump_power = jump_power*0.95
	#print(jump_power)
	velocity = dir
	move_and_slide(dir*delta)
	print($Feet.get_overlapping_bodies().size())


func _on_JumpCooldown_timeout():
	jump_ready = true
