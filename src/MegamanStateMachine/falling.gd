class_name MegaMan_State_Falling extends MegaManState


func enter(previous_state_path: String, data := {}) -> void:
	print("falling!")
	megaman.animation_player.play("jump")
	megaman.animation_player.position.y += 7
	pass

func physics_update(_delta: float) -> void:
			
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		megaman.velocity.x = direction * megaman.JUMP_X_SPEED
	else:
		megaman.velocity.x = 0
	
	if megaman.velocity.x > 0:
		megaman.animation_player.flip_h = true
	else:
		megaman.animation_player.flip_h = false
	
	if megaman.is_on_floor():
		if megaman.velocity.x != 0:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
	pass
	
func exit():
	megaman.animation_player.position.y -= 7
	print("falling ended!")
