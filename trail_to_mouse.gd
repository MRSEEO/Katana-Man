extends Line2D

	
	
func _ready():
	set_as_toplevel(true)
	
	
func _process(delta):
	if get_parent().slice_mode:
		self.visible = true
		
		global_rotation = 0
		set_point_position(0, get_parent().position)
		set_point_position(1, get_parent().get_parent().get_node("point_cursor").position)
		
	else:
		self.visible = false
