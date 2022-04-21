extends KinematicBody2D

var health = 3
var speed = 150




var slice_mode = false
var on_way = true
var can_walk = true
var can_attack = true

var invisibility = false
var dead = false
signal dead

var existing_points = []
var points_pos = []


signal im_here

var end_pos : Vector2
var velocity_to : Vector2
var target : Vector2

var slice_speed : float


var trail = false


var slowmo_timeout = false
func _ready():
	on_way = false
	slice_mode = false
	can_walk = true
	can_attack = true
	
	$points_line.set_as_toplevel(true)


func _process(delta):
	if $points_line.get_point_count() > 0:
		$points_line.set_point_position(0, self.position)












func _physics_process(delta):
	var velocity = Vector2(0,0)
	
	if !slice_mode and !on_way and can_walk:
		
		if Input.is_action_pressed("up"):
			velocity.y -= speed
		if Input.is_action_pressed("down"):
			velocity.y += speed
		if Input.is_action_pressed("left"):
			velocity.x -= speed
		if Input.is_action_pressed("right"):
			velocity.x += speed
			
		velocity = velocity.normalized()
		move_and_collide(velocity * speed * 2 * delta)
		
		if velocity != Vector2(0,0) and !slice_mode:
			$sprite.play("run")
		elif velocity == Vector2(0,0) or slice_mode:
			$sprite.play("idle")
			
		trail = false
	
	
	elif on_way:
		velocity_to = (end_pos - self.position).clamped(1)
		move_and_collide(velocity_to * slice_speed * delta)
		
		trail = true
	
	
	
	if Input.is_action_pressed("right_click") and !on_way and can_attack and !slowmo_timeout:
		get_parent().get_node("point_cursor").visible = true; slice_mode = true
		
		if Input.is_action_just_pressed("left_click") and existing_points.size() < 5 and get_parent().get_node("point_cursor").can_place_point:
			
			var point = load("res://point.tscn").instance()
			point.position = get_parent().get_node("point_cursor").position
			
			
			if $points_line.get_point_count() == 0:
				$points_line.add_point(self.position)
			$points_line.add_point(point.position)
			
			
			get_tree().get_root().get_node("main").add_child(point, true)
			existing_points.append(str(point.get_name()))
			
			
			AudioControl.play_sound("res://sounds/place_sound_1.wav")
			get_parent().get_node("point_cursor/Sprite/anim").play("placed")

	else:
		if Input.is_action_just_released("right_click") and !on_way and can_attack or slowmo_timeout:
			if existing_points.size() != 0:
				go_to_point(existing_points)
				
			if get_parent().get_node("invertion/invert/anim").assigned_animation == "show":
				get_parent().get_node("invertion/invert/anim").play("hide")
				
				if $time_sound.is_playing() and $time_sound.get_playback_position() < 3.92:
					$time_sound.play(3.92)
			
			
			$slowmo_timer.stop()
			
			
			slowmo_timeout = false
			can_attack = false
			
			
			$recoil_timer.start(5)
			
			
		get_parent().get_node("point_cursor").visible = false; slice_mode = false
		
		
		
	
	if Input.is_action_just_pressed("right_click") and !can_attack:
		AudioControl.play_sound("res://sounds/no_1.wav")
		
	if Input.is_action_just_pressed("right_click") and can_attack:
		if !$time_sound.is_playing():
			$time_sound.play()
			
		$slowmo_timer.start(4)


	if Input.is_action_just_pressed("right_click") and can_attack:
		get_parent().get_node("invertion/invert/anim").play("show")




	if velocity.x < 0 or on_way and velocity_to.x < 0:
		$sprite.flip_h = true
	if velocity.x > 0 or on_way and velocity_to.x > 0:
		$sprite.flip_h = false

	if slice_mode:
		$sprite.play("run")




###invisibility
	if invisibility and $sprite/anim.current_animation == "invisibility":
		if !$sprite/anim/Tween.is_active():
			$sprite/anim/Tween.interpolate_property($sprite/anim, "playback_speed", 0.1, 1, $invisibility_timer.wait_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$sprite/anim/Tween.start()
		
	elif !invisibility:
		if $sprite/anim.current_animation == "invisibility":
			$sprite/anim.play("normal")
			
			$sprite/anim.playback_speed = 1







func go_to_point(points):
	var current_point = get_tree().get_root().get_node("main/" + str(points[0]))
	
	end_pos = current_point.position
	current_point.im_next = true
	
	on_way = true
	

	$Tween.interpolate_property(self, "slice_speed", 800, 3400, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	$sprite/anim.play("hide")
	
	AudioControl.play_sound("res://sounds/whoosh_1.wav")
	


func _on_player_im_here():
	if existing_points.size() > 1:
		get_parent().remove_child(get_tree().get_root().find_node(str(existing_points[0]), true, false))
		existing_points.remove(0)
		
		$points_line.remove_point(1)
		
	elif existing_points.size() == 1:
		get_parent().remove_child(get_tree().get_root().find_node(str(existing_points[0]), true, false))
		existing_points.remove(0)
		
		$points_line.remove_point(1)
		$points_line.remove_point(0)
		
		after_attack()
	
	
	
	on_way = false
	yield(get_tree().create_timer(0.1), "timeout")
	
	
	
	if existing_points.size() != 0:
		go_to_point(existing_points)
		
	else:
		on_way = false
		
		$sprite/anim.play("show")
		
		
		
		
func after_attack():
		#print("i was here")
	
		can_walk = false
		$sprite.play("stop")
		yield(get_tree().create_timer(1.5), "timeout")
		
		can_walk = true
		$sprite.play("idle")
		
		
		can_attack = false
		$recoil_timer.start(5)
		#print("recoil taimer started")


func _on_recoil_timer_timeout():
	#print("recoil is done")
	can_attack = true
	slowmo_timeout = false
	
	AudioControl.play_sound("res://sounds/harp_1.wav")


func _on_slowmo_timer_timeout():
	slowmo_timeout = true
	after_attack()





func _on_hitbox_area_entered(area):
	if area.is_in_group("enemy") and !invisibility and !on_way:
		if health == 1:
			emit_signal("dead")
			dead = true
			
			self.scale.x = 20
			
			health -= 1
			
		elif health > 1:
			health -= 1; invisibility = true
			$invisibility_timer.start()
			
			$sprite/anim.animation_set_next("hitted", "invisibility")
			$sprite/anim.play("hitted")



func _on_invisibility_timer_timeout():
	invisibility = false
