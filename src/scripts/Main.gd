extends Spatial

export(PackedScene) var level

func Restart_Game():
	print("redo")
	var kids = $LevelHolder.get_children()
	for kid in kids:
		kid.queue_free()
	var new_level = level.instance()
	$LevelHolder.add_child(new_level)
	$MainUI.show()

func _on_Button_pressed():
	$MainUI.hide()
	Game.running = true
