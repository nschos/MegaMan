class_name MegaMan_State_Jumping extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	#print("jumping!")
	megaman.animation_player.play("jump")
	megaman.animation_player.position.y += 7
	megaman.velocity.y = megaman.JUMP_VELOCITY
	pass

func physics_update(_delta: float) -> void:

	if not megaman.is_on_floor() and not Input.is_action_pressed("jump"):
		if megaman.velocity.y < -127.265625:
			megaman.velocity.y = -60
			pass
			
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		megaman.velocity.x = direction * megaman.JUMP_X_SPEED
	else:
		megaman.velocity.x = 0
	
	if megaman.is_on_floor():
		if megaman.velocity.x != 0:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
	pass
	
	
func handle_shoot() -> void:
	megaman.animation_player.play("jump_shoot")

func exit():
	megaman.animation_player.position.y -= 7
	#print("jump ended!")
