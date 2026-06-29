class_name MegaMan_State_Hurt extends MegaManState

func enter(_previous_state_path: String, _data := {}) -> void:
	print("hurt!")
	megaman.animation_player.play("hurt")
	pass

func physics_update(_delta: float) -> void:
	
	pass
	
func exit():
	print("hurt ended!")
