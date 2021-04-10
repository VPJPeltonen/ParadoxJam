extends Spatial

export(PackedScene) var level

func _ready():
	$MainUI/MainMenu/Button.grab_focus()

func Restart_Game():
	print("redo")
	var kids = $LevelHolder.get_children()
	for kid in kids:
		kid.queue_free()
	var new_level = level.instance()
	$LevelHolder.add_child(new_level)
	$MainUI.show()
	$MainUI/MainMenu/Button.grab_focus()

func _on_Button_pressed():
	$MainUI.hide()
	Game.running = true
