extends Button
@export var animation_frames: SpriteFrames
@export var character_boss: SpriteFrames 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if animation_frames:
		sprite.sprite_frames = animation_frames
	
	sprite.stop()
	sprite.frame = 0

func _on_focus_entered() -> void:
	sprite.play("focus")
	sprite.frame = 1
	SFXManager.play(SFXManager.MENU_SELECT)

func _on_focus_exited() -> void:
	sprite.stop()
	sprite.frame = 0
