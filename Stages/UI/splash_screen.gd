extends Control

@onready var animation_frames: SpriteFrames
@onready var sprite = $AnimatedSprite2D

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		print("play")
		sprite.play()
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://Stages/UI/stage_select.tscn")

	#if animation_frames:
		#sprite.sprite_frames = animation_frames
	#
	#sprite.stop()
	#sprite.frame = 0
	
