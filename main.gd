extends Node2D

var mouse : Vector2

var slowmo = false
func _ready():
	$Camera2D/dead_screen/pos.visible = false


func _process(delta):
	mouse = get_global_mouse_position()
	
	if $player.slice_mode:
		slowmo = true
	else:
		slowmo = false
		
	


func _on_player_dead():
	$Camera2D/dead_screen/pos.visible = true
	get_tree().paused = true
