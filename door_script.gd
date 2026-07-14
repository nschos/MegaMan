extends Area2D

@onready var animation_player := $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	if body is MegaMan:
		#print("megaman!")
		animation_player.play("opening_door")
		
	pass # Replace with function body.
