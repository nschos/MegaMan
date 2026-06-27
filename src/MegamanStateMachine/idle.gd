class_name MegaMan_State_Idle extends MegaManState

func enter(_previous_state_path: String, _data := {}) -> void:
	#print("idle!")
	megaman.animation_player.play("idle")
	pass

const blink_frame := 162


func physics_update(_delta: float) -> void:
	
	if not megaman.is_shooting:
		if megaman.blink_timer >= blink_frame:
			megaman.animation_player.play("idle_blink")
		elif megaman.blink_timer >= 2:
			megaman.animation_player.play("idle")
	else:
		megaman.animation_player.play("idle_shooting")
		
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		finished.emit(RUNNING)
	
		
	pass
