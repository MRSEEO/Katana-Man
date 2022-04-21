extends CanvasLayer


func _input(event):
	if event.is_action_pressed("left_click") and get_tree().paused == true:
		get_tree().paused = false
		get_tree().reload_current_scene()
