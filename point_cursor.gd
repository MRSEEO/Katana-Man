extends Node2D

var can_place_point = true
func _process(delta):
	self.position = get_global_mouse_position()


func _on_Area2D_area_entered(area):
	if area.is_in_group("wall"):
		can_place_point = false
		
	$Sprite/anim.play("!can_place")


func _on_Area2D_area_exited(area):
	can_place_point = true
	
	$Sprite/anim.play("can_place")
