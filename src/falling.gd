class_name MegaMan_State_Falling extends MegaManState

const JUMP_VELOCITY = -4.87109375

const GRAVITY = 15

func enter(previous_state_path: String, data := {}) -> void:
	print("jumping!")
	megaman.animation_player.play("jump")
	megaman.velocity.y = JUMP_VELOCITY
	pass

func physics_update(_delta: float) -> void:
	#megaman.velocity.y += megaman.gravity * _delta
	#megaman.move_and_slide()
	print("velocity y:",megaman.velocity.y)
	
	megaman.velocity.y += GRAVITY * _delta

	if not megaman.is_on_floor() and not Input.is_action_pressed("ui_accept"):
		if megaman.velocity.y < -127.265625:
			megaman.velocity.y = -60
			pass

	if megaman.is_on_floor():
		finished.emit(IDLE)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#finished.emit(RUNNING)
	pass
	
func exit():
	print("jump ended!")
