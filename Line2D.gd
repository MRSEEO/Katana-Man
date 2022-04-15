extends Line2D


var point
export var trailLength = 0
	
	
func _ready():
	set_as_toplevel(true)
	
func _process(delta):
	if get_parent().trail:
		global_rotation = 0
		add_point(get_parent().global_position)
		
	while get_point_count() > trailLength and get_parent().trail:
		remove_point(0)
		



func _on_Timer_timeout():
	if get_point_count() != 0 and get_parent().trail == false:
		remove_point(0)
