class_name MegaMan extends CharacterBody2D

const SPEED = 82.5



var is_touching_ladder = false

var has_grabbed_ladder = false

@onready var animation_player := %AnimatedSprite2D
@onready var state_machine := $StateMachine

func _physics_process(delta: float) -> void:
	
	if state_machine.state is not MegaMan_State_Climbing:
		
		if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and is_touching_ladder:
			#has_grabbed_ladder = true
			#print(collision_mask)
			state_machine.state.finished.emit(MegaManState.CLIMBING)
		
		
		if is_on_floor() and velocity.x != 0:
			state_machine.state.finished.emit(MegaManState.RUNNING)
			pass
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			state_machine.state.finished.emit(MegaManState.JUMPING)
			
		
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			

		
		
		#for i in range(get_slide_collision_count()):
			#var collision = get_slide_collision(i)
			#var collider = collision.get_collider()
			#print(collider)
		#var collider = collision.get_collider()
		#
		## Do something if we collided with a specific object
		#if collider.is_in_group("enemies"):
			#print("Collided with an enemy!")
		

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("megaman touched ladder")
	is_touching_ladder = true
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("megaman untouched ladder")
	is_touching_ladder = false
	has_grabbed_ladder = false
	self.set_collision_mask_value(3, true)
	pass # Replace with function body.
