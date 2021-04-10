extends Area

export(PackedScene) var ghost
var player 

func make_ghost(data):
	var new_ghost = ghost.instance()
	get_parent().get_node("Ghosts").add_child(new_ghost)
	new_ghost.global_transform.origin = $StartPos.global_transform.origin
	new_ghost.init(data)
	
func _on_Teleporter_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		$Timer.start()
		get_tree().call_group("UI","teleport")
	#elif body.is_in_group("Ghost"):
		#body.reset($StartPos.global_transform.origin)

func _on_Timer_timeout():
	player.global_transform.origin = Vector3(player.global_transform.origin.x,
										player.global_transform.origin.y,
										$PortPos.global_transform.origin.z)
	get_tree().call_group("Ghost","reset")
	make_ghost(player.recorder.get_record())
	player.stop_recording()
