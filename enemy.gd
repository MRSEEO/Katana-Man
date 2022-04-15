extends KinematicBody2D


var hp = 100
var speed = 60

var dead = false


var slowmo = false
func _process(delta):
	slowmo = get_parent().slowmo
	if slowmo:
		delta = delta / 3
	else:
		pass
	
	
	
	var player = get_parent().get_node("player").position
	
	var velocity = position.direction_to(player)
	move_and_collide(velocity * speed * delta)
	
	if velocity != Vector2(0,0):
		$Sprite.play("walk")
	else:
		$Sprite.play("idle")
		
	if hp < 0:
		dead = true
		
	if dead:
		rotate(0.1)
		
	if $anim.is_playing():
		speed /= 2
	else:
		speed = 60


func _on_hitbox_area_entered(area):
	if area.is_in_group("player"):
		var player = get_parent().get_node("player")
		
		if player.on_way:
			$anim.play("hitted")
			AudioControl.play_sound("res://sounds/sword_1.wav")
			
			hp -= rand_range(15, 20)
			
			var blood = load("res://blood.tscn").instance()
			get_tree().current_scene.add_child(blood)
			blood.global_position = global_position
			blood.rotation = global_position.angle_to_point(get_parent().get_node("player").position) * -1
