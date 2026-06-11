class_name MegaMan_State_Climbing extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("climbing!!")
	megaman.set_collision_mask_value(3, false)
	megaman.set_collision_mask_value(1, false)
	megaman.velocity = Vector2(0,0)
	megaman.animation_player.play("climb_R")
	pass
	
func exit() -> void:
	megaman.set_collision_mask_value(3, true)
	megaman.set_collision_mask_value(1, true)
	pass

func physics_update(_delta: float) -> void:
	megaman.velocity.x = 0
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		megaman.velocity.y = direction * megaman.RUNNING_FULLSPEED_X
	else:
		megaman.velocity.y = 0 #move_toward(velocity.x, 0, SPEED)
	#megaman.velocity.y += megaman.gravity * _delta
	#megaman.move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		finished.emit(JUMPING)
	#if not megaman.is_on_floor():
		#finished.emit(JUMPING)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(JUMPING)
	#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		#finished.emit(RUNNING)
	pass
