extends Control

func show_game_over():
	$GameOverScreen/GameOverTimer.start()

func teleport():
	$AnimationPlayer.play("Teleport")

func _on_GameOverTimer_timeout():
	$GameOverScreen.show()

func _on_RestartButton_pressed():
	get_tree().call_group("Main","Restart_Game")
