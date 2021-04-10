extends Control

func _process(delta):
	var player = get_parent().get_node("Player")
	$ActionUI/Label.text = format_time(30-player.time)

func show_game_over():
	$GameOverScreen/RestartButton.grab_focus()
	$GameOverScreen/GameOverTimer.start()

func teleport():
	$AnimationPlayer.play("Teleport")

func format_time(elapsed):
	var minutes = elapsed / 60.0
	var seconds = int(elapsed) % 60
	var milliseconds = (elapsed - int(elapsed))*1000 
	var str_elapsed = "%02d : %02d : %03d" % [minutes, seconds, milliseconds]
	return str_elapsed

func _on_GameOverTimer_timeout():
	$GameOverScreen.show()

func _on_RestartButton_pressed():
	get_tree().call_group("Main","Restart_Game")
