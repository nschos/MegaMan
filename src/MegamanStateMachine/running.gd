class_name MegaMan_State_Running extends MegaManState

var frame_counter := 0
const frame_acceleration_window := 9
const frame_deceleration_window := 13
const frame_inch_window := 4
const frame_inch_d_window := 7

enum Velocity { ACCELERATE, DECELERATE, FULLSPEED, DECELERATE_FROM_FULLSPEED, FULLHALT, NULL }

var current_velocity: Velocity = Velocity.FULLHALT


func enter(previous_state_path: String, data := {}) -> void:
	print("running!")
	
	megaman.animation_player.play("walk")
	
	if megaman.velocity.x == 0:
		current_velocity = Velocity.FULLHALT
	else:
		current_velocity = Velocity.ACCELERATE
	pass

func physics_update(_delta: float) -> void:
	
	var direction := Input.get_axis("ui_left", "ui_right")
	
	
	# ACCELERATE
	if direction != 0:
		
		print("direction: ",direction)

		if current_velocity == Velocity.FULLHALT or current_velocity == Velocity.DECELERATE or current_velocity == Velocity.DECELERATE_FROM_FULLSPEED:
			current_velocity = Velocity.ACCELERATE
			frame_counter = 0
			
		elif current_velocity == Velocity.ACCELERATE:
			frame_counter += 1
			if frame_counter == frame_inch_window:
				megaman.animation_player.play("inch")
			elif frame_counter >= frame_acceleration_window:
				current_velocity = Velocity.FULLSPEED
				megaman.animation_player.play("walk")
			
		match current_velocity:
			Velocity.FULLSPEED:
				megaman.velocity.x = direction * megaman.RUNNING_FULLSPEED_X
			Velocity.ACCELERATE:
				megaman.velocity.x = direction * megaman.RUNNING_ACCELERATION_X
				
		print("current velocity: ",current_velocity)
		print("megaman velocity x:",megaman.velocity.x)
		
	# DECELERATE
	else:
		if current_velocity == Velocity.FULLSPEED:
			current_velocity = Velocity.DECELERATE_FROM_FULLSPEED
			megaman.velocity.x = direction * megaman.RUNNING_DECELERATION_X
			frame_counter = 0
		
		elif current_velocity == Velocity.DECELERATE_FROM_FULLSPEED:
			frame_counter += 1
			if frame_counter == frame_inch_d_window:
				megaman.animation_player.play("inch")
			elif frame_counter == frame_deceleration_window:
				megaman.velocity.x = 0
				current_velocity = Velocity.FULLHALT
			
		elif current_velocity == Velocity.ACCELERATE:
			current_velocity = Velocity.FULLHALT
			megaman.velocity.x = 0
			
		elif current_velocity == Velocity.FULLHALT:
			finished.emit(IDLE)
		
		pass
	


	if megaman.velocity.x > 0:
		megaman.animation_player.flip_h = true
	elif megaman.velocity.x < 0:
		megaman.animation_player.flip_h = false
	pass
	
	
	
	
func exit():
	pass
