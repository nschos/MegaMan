extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0

var is_touching_ladder = false

var has_grabbed_ladder = false


func _physics_process(delta: float) -> void:
	
	if has_grabbed_ladder:
		velocity = Vector2(0,0)
		if Input.is_action_just_pressed("ui_accept"):
			has_grabbed_ladder = false
			set_collision_mask_value(3, true)
			
		var direction := Input.get_axis("ui_up", "ui_down")
		if direction:
			velocity.y = direction * SPEED
		else:
			velocity.y = 0 #move_toward(velocity.x, 0, SPEED)
	
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and is_touching_ladder:
			has_grabbed_ladder = true
			print(collision_mask)
			self.set_collision_mask_value(3, false)
		
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
