extends KinematicBody2D


var hp = 100
var speed = 60

var dead = false
var can_attack = false
var on_attack = false
var last_player_pos = Vector2(0,0)


var slowmo = false


var one_shot = false

func _ready():
	$hp.value = hp

func _process(delta):
###SLOWMO
	slowmo = get_parent().slowmo
	if slowmo:
		delta = delta / 3
	
###SPEED-HP
	if hp < 100:
		speed += speed * (hp / 100)
	
	
	
	var player = get_parent().get_node("player").position
	
	var velocity = position.direction_to(player)
	if !on_attack and position.distance_to(last_player_pos) > 100:
		can_attack = false
		move_and_collide(velocity * speed * delta)
		
	elif !on_attack and position.distance_to(last_player_pos) <= 100:
		if !$anim.is_playing() and $anim.current_animation != "attack":
			last_player_pos = player
			$anim.play("attack")
		
	if on_attack and position.distance_to(last_player_pos) > 10:
		move_and_collide(position.direction_to(last_player_pos) * speed * 10 * delta)
		
	
	if hp < 0:
		dead = true
		
	if dead:
			var death_particles = load("res://red_mob_death_particles.tscn").instance()
			get_tree().current_scene.add_child(death_particles)
			death_particles.global_position = global_position
			death_particles.scale = self.scale
			
			AudioControl.play_death("res://sounds/death_1.wav")
			
			queue_free()

		
		
	if $anim.is_playing() and $anim.current_animation == "hitted":
		speed /= 2
	else:
		speed = 60
	
###ANIMATION
	if velocity != Vector2(0,0):
		$Sprite.play("walk")
	else:
		$Sprite.play("idle")
		


func _on_hitbox_area_entered(area):
	if area.is_in_group("player"):
		var player = get_parent().get_node("player")
		
		if player.on_way:
			$anim.play("hitted")
			AudioControl.play_sound("res://sounds/sword_1.wav")
			
			var damage = rand_range(15, 20)
			hp -= damage
			
			$Tween.interpolate_property($hp, "value", $hp.value, hp, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
			$Tween.start()
			
			#####
			##   BLOOD
			var blood = load("res://blood.tscn").instance()
			get_tree().current_scene.add_child(blood)
			blood.global_position = global_position
			blood.rotation = global_position.angle_to_point(get_parent().get_node("player").position) * -1


func _on_attack_timeout():
	can_attack = true
	


func _on_anim_animation_finished(anim_name):
	if anim_name == "attack":
		on_attack = true
		$anim.play("attack_reversed")

	if anim_name == "attack_reversed":
		on_attack = false
		can_attack = true
	
