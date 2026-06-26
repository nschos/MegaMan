class_name MegaMan_State_Idle extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	#print("idle!")
	megaman.animation_player.play("idle")
	pass

const blink_frame := 162

const shooting_window := 15

var frame_counter := 0

func handle_shoot() -> void:
	print("idle shoot!")
	megaman.is_shooting = true
	megaman.animation_player.play("idle_shooting")
	frame_counter = 0
	#megaman.animation_player.position += Vector2(2, 4)

func physics_update(_delta: float) -> void:
	#print("blik timer: ",megaman.blink_timer)
	
	if megaman.is_shooting and frame_counter >= shooting_window:
		megaman.is_shooting = false
		frame_counter = 0
	else:
		frame_counter += 1
	
	if not megaman.is_shooting:
		if megaman.blink_timer >= blink_frame:
			megaman.animation_player.play("idle_blink")
		elif megaman.blink_timer >= 2:
			megaman.animation_player.play("idle")
		
		
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		finished.emit(RUNNING)
	
		
	pass
