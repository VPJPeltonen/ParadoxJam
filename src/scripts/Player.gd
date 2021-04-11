extends KinematicBody

export(AudioStream) var grunt1
export(AudioStream) var grunt2
export(AudioStream) var grunt3
export(AudioStream) var grunt4
export(AudioStream) var grunt5
export(AudioStream) var grunt6

var speed: int = 100
var velocity: Vector3 = Vector3(0,0,0)
var jump_power :Vector3= Vector3(0,0,0)
var fall_power :Vector3= Vector3(0,0,0)
var jump_ready :bool = true
var recorder_class = load("res://src/scripts/recorder.gd")
var recorder
var time = 0.0
var time_running = true
var rotation_target = Vector3(0,0,0)
var slide_target = 0.0
var slide = 0.0

onready var grunts = [grunt1,grunt2,grunt3,grunt4,grunt5,grunt6]
onready var rng = RandomNumberGenerator.new()

func _ready():
	recorder = recorder_class.new()
	$RecordTimer.start()

func _process(delta):
	if !Game.running:
		$RecordTimer.stop()
		return
	elif $RecordTimer.is_stopped() and time_running:
		$RecordTimer.start()
	if Input.is_action_just_pressed("taunt"):
		$Ohmygod.play()
	if time_running:
		time += delta
		if time > 30:
			time_running = false
			die()
	
func _physics_process(delta):
	#Makes sure character stays on the 2d plane
	global_transform.origin = Vector3(0,
										global_transform.origin.y,
										global_transform.origin.z)
	if !Game.running:
		return
	$spaceguy.rotation_degrees = $spaceguy.rotation_degrees.linear_interpolate(rotation_target,0.1)
	slide = (slide+slide_target)/2.0
	print(slide)
	$spaceguy/AnimationPlayer/AnimationTree.set("parameters/SLIDE/blend_amount",slide)
	if $WallJumpRange.get_overlapping_bodies().size() > 1:
		slide_target = 1.0
	else:
		slide_target = 0.0
	var dir :Vector3 = velocity*0.9
	if Input.is_action_pressed("left"):
		dir += Vector3(0,0,1)*speed
		rotation_target = Vector3(0,180,0)
	elif Input.is_action_pressed("right"):
		dir -= Vector3(0,0,1)*speed
		rotation_target = Vector3(0,0,0)
	if Input.is_action_pressed("jump") and $Feet.get_overlapping_bodies().size() > 1 and jump_ready:
		jump_power += Vector3(0,300,0)
		$CPUParticles.emitting = true
		jump_ready = false
		$JumpCooldown.start()
		$AudioStreamPlayer.set_stream(grunts[rng.randi_range(0,grunts.size()-1)])
		$AudioStreamPlayer.play()
	elif Input.is_action_pressed("jump") and $WallJumpRange.get_overlapping_bodies().size() > 1 and jump_ready:
		jump_power += Vector3(0,300,0)
		jump_ready = false
		$CPUParticles.emitting = true
		$JumpCooldown.start()
		fall_power = fall_power/2
		$AudioStreamPlayer.set_stream(grunts[rng.randi_range(0,grunts.size()-1)])
		$AudioStreamPlayer.play()
	if $Feet.get_overlapping_bodies().size() <= 1:
		fall_power -= Game.gravity
	else:
		if fall_power != Vector3(0,0,0) and !$Impact.playing:
			$Impact.play()
		dir = Vector3(dir.x,0,dir.z)
		fall_power = Vector3(0,0,0)
	dir += jump_power
	dir += fall_power
	jump_power = jump_power*0.95
	#print(jump_power)
	velocity = dir
	var move = move_and_slide(dir*delta)
	
	$spaceguy/AnimationPlayer/AnimationTree.set("parameters/MOVE/blend_position",Vector2(abs(move.z)/16.0,move.y/22.0))
	#$AnimationTree.set("parameters/"+move_par+"/blend_position",value)

func stop_recording():
	$RecordTimer.stop()
	time_running = false
	time = 0

func start_recording():
	$RecordTimer.start()
	time_running = true

func die():
	$AnimationPlayer.play("Explode")
	get_tree().call_group("UI","show_game_over")
	Game.running = false

func _on_JumpCooldown_timeout():
	jump_ready = true

func _on_RecordTimer_timeout():
	recorder.record(self)
