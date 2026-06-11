class_name MegaMan_State_Idle extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("idle!")
	megaman.animation_player.play("idle")
	pass

const blink_frame := 162

func physics_update(_delta: float) -> void:
	#print("blik timer: ",megaman.blink_timer)
	if megaman.blink_timer >= blink_frame:
		megaman.animation_player.play("idle_blink")
	elif megaman.blink_timer >= 2:
		megaman.animation_player.play("idle")
	pass
