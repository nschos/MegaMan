class_name MegaMan_State_Climbing extends MegaManState

var flip_sprite_window := 9
var frame_counter := 0

func enter(previous_state_path: String, data := {}) -> void:
	#print("climbing!!")
	megaman.set_collision_mask_value(3, false)
	#megaman.set_collision_mask_value(1, false)
	#if megaman.collision_shape.shape is RectangleShape2D:
		#print("teste!")
	megaman.velocity = Vector2(0,0)
	megaman.animation_player.play("climb_R")
	megaman.animation_player.position.y += 7
	pass
	
	
	
func exit() -> void:
	megaman.set_collision_mask_value(3, true)
	#megaman.set_collision_mask_value(1, true)
	megaman.animation_player.position.y -= 7
	pass
	
func handle_shoot() -> void:
	print("shooting while climbing!")

func physics_update(_delta: float) -> void:
	megaman.velocity.x = 0
	#print("frame counter:",frame_counter)
	var direction := Input.get_axis("ui_up", "ui_down")
	if direction:
		megaman.velocity.y = direction * megaman.CLIMB_SPEED
	else:
		megaman.velocity.y = 0 #move_toward(velocity.x, 0, SPEED)
		frame_counter = 0
	#megaman.velocity.y += megaman.gravity * _delta
	#megaman.move_and_slide()
	
	if megaman.is_on_floor() and Input.is_action_pressed("ui_down"):
		finished.emit(IDLE)
		
	if direction == 0.0:
		if Input.is_action_just_pressed("jump"):
			finished.emit(FALLING)
			
			
	if frame_counter == flip_sprite_window:
		megaman.animation_player.flip_h = not megaman.animation_player.flip_h
		frame_counter = 0
		
	frame_counter += 1

	pass
