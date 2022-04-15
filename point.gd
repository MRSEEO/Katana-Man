extends Node2D


signal player_is_here

var im_next : bool
func _process(delta):
	if position.distance_to(get_parent().get_node("player").position) < 30 and im_next:
		emit_signal("player_is_here")


func _on_point_player_is_here():
	get_parent().get_node("player").emit_signal("im_here")
