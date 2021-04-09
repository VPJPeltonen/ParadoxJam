extends Area

var player 

func _on_Teleporter_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		$Timer.start()
		get_tree().call_group("UI","teleport")

func _on_Timer_timeout():
	player.global_transform.origin = Vector3(player.global_transform.origin.x,
										player.global_transform.origin.y,
										$Position3D.global_transform.origin.z)
