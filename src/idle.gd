class_name MegaMan_State_Idle extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("idle!!")
	#megaman.velocity.x = 0.0
	megaman.animation_player.play("idle")
	pass

func physics_update(_delta: float) -> void:
	#print("idle!!")
	#megaman.velocity.y += megaman.gravity * _delta
	#megaman.move_and_slide()

	#if not megaman.is_on_floor():
		#finished.emit(JUMPING)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#finished.emit(RUNNING)
	pass
