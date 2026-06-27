class_name MegaMan_State_Idle extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	#print("idle!")
	megaman.animation_player.play("idle")
	pass

const blink_frame := 162


func handle_shoot() -> void:
	print("idle shoot!")
	#megaman.is_shooting = true
	megaman.animation_player.play("idle_shooting")
	
	#megaman.animation_player.position += Vector2(2, 4)

func physics_update(_delta: float) -> void:
	
	if not megaman.is_shooting:
		if megaman.blink_timer >= blink_frame:
			megaman.animation_player.play("idle_blink")
		elif megaman.blink_timer >= 2:
			megaman.animation_player.play("idle")
		
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		finished.emit(RUNNING)
	
		
	pass
