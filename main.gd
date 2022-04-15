extends Node2D

var mouse : Vector2

var slowmo = false
func _process(delta):
	mouse = get_global_mouse_position()
	
	if $player.slice_mode:
		slowmo = true
	else:
		slowmo = false
