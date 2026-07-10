extends Button
@export var animation_frames: SpriteFrames
@export var character_boss: SpriteFrames

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var boss_sprite: AnimatedSprite2D = $BossAnimatedSprite

func _ready() -> void:
	if animation_frames:
		sprite.sprite_frames = animation_frames
	
	sprite.stop()
	sprite.frame = 0
	if character_boss:
		boss_sprite.sprite_frames = character_boss
func _on_focus_entered() -> void:
	sprite.play("focus")
	sprite.frame = 1
	SFXManager.play(SFXManager.MENU_SELECT)

func _on_focus_exited() -> void:
	sprite.stop()
	sprite.frame = 0
