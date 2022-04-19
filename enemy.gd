extends KinematicBody2D


var hp = 100
var speed = 60

var dead = false


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
	move_and_collide(velocity * speed * delta)
	
	if hp < 0:
		dead = true
		
	if dead:
			var death_particles = load("res://red_mob_death_particles.tscn").instance()
			get_tree().current_scene.add_child(death_particles)
			death_particles.global_position = global_position
			death_particles.scale = self.scale
			
			AudioControl.play_death("res://sounds/death_1.wav")
			
			queue_free()

		
		
	if $anim.is_playing():
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
