extends Control

@onready var initial_button: Button = $Control/Cutman_Button
@onready var score_value: RichTextLabel = $ColorRect/ColorRect/ScoreValue
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var final_score: int = 0 
var score_increment: int = 10000


var is_randomizing: bool = false
var current_time: float = 0.0
var animation_duration: float = 1.5

var tick_timer: float = 0.0
var tick_speed: float = 0.05 

func _ready() -> void:
	SFXManager.play_music(SFXManager.STAGE_SELECT)
	initial_button.grab_focus()
	score_value.text = "" 


func _on_cutman_button_pressed() -> void:
	SFXManager.play(SFXManager.GAME_START)
	anim_player.play("Cutman Stage")
	SFXManager.play_music(SFXManager.ENEMY_CHOSEN)
	await get_tree().create_timer(7.0).timeout
	SFXManager.stop_music()
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://main.tscn")

func start_score_sequence() -> void:
	randomize() 
	final_score = randi_range(5, 10) * 10000
	is_randomizing = true
	current_time = 0.0
	tick_timer = 0.0

func _process(delta: float) -> void:
	if not is_randomizing:
		return
		
	current_time += delta
	tick_timer += delta
	
	if current_time >= animation_duration:
		is_randomizing = false
		
	
		score_value.text = _format_score(final_score)
		SFXManager.play(SFXManager.DINK)
		
		if final_score == 100000:
			await get_tree().create_timer(0.1).timeout
			score_value.text = "100000"
			
		return
		
	if tick_timer >= tick_speed:
		tick_timer = 0.0 
		
		var random_block = randi_range(0, 10)
		var current_display_score = random_block * score_increment
		
		score_value.text = _format_score(current_display_score)
		SFXManager.play(SFXManager.PI_PI_PI)


func _format_score(value: int) -> String:
	if value == 100000:
		return "00000"
	else:
		return "%05d" % value
