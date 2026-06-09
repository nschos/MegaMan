class_name MegaMan_State_Idle extends MegaManState

func enter(previous_state_path: String, data := {}) -> void:
	print("idle!")
	megaman.animation_player.play("idle")
	pass

func physics_update(_delta: float) -> void:
	pass
