class_name MegaMan_State_Climbing extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("climbing!!")
	megaman.set_collision_mask_value(3, false)
	megaman.set_collision_mask_value(1, false)
	megaman.velocity = Vector2(0,0)
	megaman.animation_player.play("climb_R")
	megaman.animation_player.position.y += 7
	pass
	
	
	
func exit() -> void:
	megaman.set_collision_mask_value(3, true)
	megaman.set_collision_mask_value(1, true)
	megaman.animation_player.position.y -= 7
	pass

func physics_update(_delta: float) -> void:
	megaman.velocity.x = 0
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		megaman.velocity.y = direction * megaman.CLIMB_SPEED
	else:
		megaman.velocity.y = 0 #move_toward(velocity.x, 0, SPEED)
	#megaman.velocity.y += megaman.gravity * _delta
	#megaman.move_and_slide()
	
	#if megaman.is_on_floor():
		#finished.emit(IDLE)
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(FALLING)

	pass
