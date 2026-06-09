class_name MegaMan_State_Jumping extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("jumping!")
	megaman.animation_player.play("jump")
	megaman.animation_player.position.y += 7
	megaman.velocity.y = megaman.JUMP_VELOCITY
	pass

func physics_update(_delta: float) -> void:

	if not megaman.is_on_floor() and not Input.is_action_pressed("ui_accept"):
		if megaman.velocity.y < -127.265625:
			megaman.velocity.y = -60
			pass
	
	
	
	if megaman.is_on_floor():
		finished.emit(IDLE)
	pass
	
func exit():
	megaman.animation_player.position.y -= 7
	print("jump ended!")
