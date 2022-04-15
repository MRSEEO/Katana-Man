extends Control



##
# Запуск музыки
##
func play_music(file : String, fadein : bool, duration : float):
	$music.set_stream(load(file))
	$music.set_volume_db(-80)
	
	if fadein:
		$fadein.interpolate_property($music, "volume_db",
		-80, 0,
		duration, $fadein.TRANS_LINEAR)
		
		$fadein.start()
		$music.play()
		
	else:
		$music.play()
	
func _on_fadein_tween_completed(object, key):
	pass # Replace with function body.
	
	
##
# Остановка музыки
##
func stop_music(fadeout : bool, duration : float):
	if fadeout:
		var db = $music.get_volume_db()
		$fadeout.interpolate_property($music, "volume_db", 
		db, -80, 
		duration, $fadeout.TRANS_LINEAR, $fadeout.EASE_IN_OUT)
		
		$fadeout.start()
		
	else:
		$music.stop()
		
func _on_fadeout_tween_completed(_object, _key):
	$music.stop()


##
# Проигрываем звук
##
func play_sound(file : String):
	if !$sound.is_playing():
		$sound.set_stream(load(file))
		$sound.play(); #print(str(file) + " played on sound")
	
	elif $sound.is_playing():
		$sound2.set_stream(load(file))
		$sound2.play(); #print(str(file) + " played on sound2")
		
	elif $sound.is_playing() and $sound2.is_playing():
		$sound3.set_stream(load(file))
		$sound3.play(); #print(str(file) + " played on sound3")
