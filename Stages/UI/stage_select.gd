extends Control

@onready var initial_button: Button = $Control/Cutman_Button

@onready var score_value: RichTextLabel = $ColorRect/ColorRect/ScoreValue
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var animation_duration: float = 1.5
var tick_speed: float = 0.05          
var score_increment: int = 10000   

var final_score: int = 90000
var current_display_score: int = 0

func _ready() -> void:
	initial_button.grab_focus()
	randomize()

func _on_cutman_button_pressed() -> void:
	print("Botão pressionado!")
	
	$AnimationPlayer.play("Cutman Stage")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://main.tscn")


func start_score_sequence(target_score: int) -> void:
	final_score = target_score
	current_display_score = 0
	
	# Start your AnimationPlayer visual sequence if needed
	if anim_player.has_animation("Cutman Stage"):
		anim_player.play("Cutman Stage")
		
	# Start the randomization loop
	_roll_score_loop()

func _roll_score_loop() -> void:
	var elapsed_time: float = 0.5
	
	# Loop until the elapsed timer runs past our desired duration
	while elapsed_time < animation_duration:
		# 1. Pick a random multiple of 10,000
		# Calculates how many 10k blocks fit into the final score, picks a random block index, and multiplies it back
		var max_blocks = final_score / score_increment
		if max_blocks > 0:
			var random_block = randi_range(1, max_blocks)
			current_display_score = random_block * score_increment
		else:
			current_display_score = 0
			
		# 2. Update display with thousands separator formatting (e.g., 20.000 or 20,000 depending on locale)
		score_value.text = _format_score(current_display_score)
		
		# 3. This acts as our timer. It pauses this function for 'tick_speed' seconds before looping
		await get_tree().create_timer(tick_speed).timeout
		elapsed_time += tick_speed
		
	# TIMER ENDED: Lock in the final, true score
	score_value.text = _format_score(final_score)

# Helper function to format the number with a dot separator like classic retro games
func _format_score(value: int) -> String:
	var num_str = str(value)
	if num_str.length() > 3:
		# Inserts a dot before the last 3 digits (e.g., 10000 becomes 10.000)
		return num_str.left(num_str.length() - 3) + "." + num_str.right(3)
	return num_str
