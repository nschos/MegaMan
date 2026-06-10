extends Button
@export var frames_animacao: SpriteFrames

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if frames_animacao:
		sprite.sprite_frames = frames_animacao
	
	sprite.stop()
	sprite.frame = 0

func _on_focus_entered() -> void:
	sprite.play("focus")
	sprite.frame = 1

func _on_focus_exited() -> void:
	sprite.stop()
	sprite.frame = 0
