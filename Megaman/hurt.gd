class_name MegaMan_State_Hurt extends MegaManState

var frame_counter := 0

func enter(_previous_state_path: String, _data := {}) -> void:
	#print("hurt!")
	megaman.animation_player.play("hurt")
	megaman.animation_player.position.y += 8
	#megaman.has_control = false
	frame_counter = 0
	pass

func physics_update(_delta: float) -> void:
	if frame_counter == 30:
		#self.exit()
		finished.emit(IDLE)
	frame_counter += 1
	pass
	
func exit():
	#print("hurt ended!")
	megaman.animation_player.position.y -= 8
	#megaman.has_control = true
