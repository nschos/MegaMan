class_name MegaMan_State_Running extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("running!")
	megaman.animation_player.play("walk")
	pass

func physics_update(_delta: float) -> void:
	
	if megaman.velocity.x > 0:
		megaman.animation_player.flip_h = true
	elif megaman.velocity.x < 0:
		megaman.animation_player.flip_h = false
	else:
		finished.emit(IDLE)
		#finished.emit()
	#if megaman.is_on_floor():
		#finished.emit(IDLE)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#finished.emit(RUNNING)
	pass
	
func exit():
	pass
