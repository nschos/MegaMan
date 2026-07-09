class_name MegaMan_State_Teleport extends MegaManState

#var frame_counter := 0

func enter(_previous_state_path: String, _data := {}) -> void:
	print("teleport!")
	SFXManager.play(SFXManager.MEGAMAN_WARP)
	megaman.animation_player.play("teleport")
	megaman.has_control = false
	await megaman.animation_player.animation_finished
	megaman.state_machine.state.finished.emit(IDLE)
	megaman.has_control = true
	#exit()
	
	
	#megaman.animation_player.position.y += 8
	#megaman.has_control = false
	#frame_counter = 0
	pass

func physics_update(_delta: float) -> void:
	#if frame_counter == 30:
		#self.exit()
		#finished.emit(IDLE)
	#frame_counter += 1
	pass
	
func exit():
	print("teleport ended!")
	#megaman.animation_player.position.y -= 8
	#megaman.has_control = true
