extends Node

var is_stepping: bool = false

var current_frame := 0

const hold_window := 0.4
var hold_timer := 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

var frame_advance := true

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("PauseEmulation"):
		get_tree().paused = !get_tree().paused
		print("--- ENGINE PAUSED ---" if get_tree().paused else "--- ENGINE RESUMED ---")
	
	elif Input.is_action_just_pressed("FrameAdvance"):
		if not get_tree().paused:
			get_tree().paused = !get_tree().paused
			print("--- ENGINE PAUSED ---" if get_tree().paused else "--- ENGINE RESUMED ---")
	
	
	if not frame_advance:
		frame_advance = true
		get_tree().paused = true
	
	if not get_tree().paused:
		#print(current_frame)
		current_frame += 1
	
	if get_tree().paused and Input.is_action_pressed("FrameAdvance") and frame_advance and \
	   (hold_timer == 0.0 or hold_timer > hold_window):
		get_tree().paused = false
		print(current_frame)
		current_frame += 1
		frame_advance = false
		
	if Input.is_action_pressed("FrameAdvance"):
		hold_timer += _delta
	else:
		hold_timer = 0
