extends Node2D

enum MenuState { CLOSED, OPENING, OPEN, CLOSING }

@onready var pause_menu: AnimatedSprite2D = $PauseMenu
@onready var base_menu: Sprite2D = $base_menu
@onready var cursor_c: AnimatedSprite2D = $C
@onready var cursor_p: AnimatedSprite2D = $P
@onready var ammo_bar: TextureProgressBar = $TextureProgressBarAmmo
@onready var health_bar: TextureProgressBar = $TextureProgressBarHealth
@onready var score_label: RichTextLabel = $ScoreLabel

const SCORE_format := "%07d"

var weapon_slots: Array[AnimatedSprite2D]
var selected_index: int = 0
var state: MenuState = MenuState.CLOSED

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	weapon_slots = [cursor_c, cursor_p]

	pause_menu.animation_finished.connect(_on_pause_menu_animation_finished)

	pause_menu.visible = false
	base_menu.visible = false
	ammo_bar.visible = false
	health_bar.visible = true
	score_label.visible = true
	score_label.text = SCORE_format % ScoreManager.score
	ScoreManager.score_changed.connect(_on_score_changed)
	_hide_cursors()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_menu"):
		match state:
			MenuState.CLOSED:
				_open_menu()
			MenuState.OPEN:
				_close_menu()
		get_viewport().set_input_as_handled()
		return

	if state != MenuState.OPEN:
		return

	if event.is_action_pressed("ui_down"):
		_move_selection(1)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_up"):
		_move_selection(-1)
		get_viewport().set_input_as_handled()

func _open_menu() -> void:
	state = MenuState.OPENING

	SFXManager.play(SFXManager.PAUSE_MENU)
	get_tree().paused = true
	_set_player_control(false)

	base_menu.visible = false
	ammo_bar.visible = false
	health_bar.visible = false
	score_label.visible = false
	_hide_cursors()

	pause_menu.visible = true
	pause_menu.play("Appear")


func _close_menu() -> void:
	state = MenuState.CLOSING

	base_menu.visible = false
	ammo_bar.visible = false
	_hide_cursors()

	pause_menu.play("Disappear")

func _on_pause_menu_animation_finished() -> void:
	if pause_menu.animation == "Appear":
		state = MenuState.OPEN
		pause_menu.play("Idle")

		base_menu.visible = true
		_show_cursors()
		_update_selection()

	elif pause_menu.animation == "Disappear":
		state = MenuState.CLOSED
		pause_menu.visible = false
		health_bar.visible = true
		score_label.visible = true

		get_tree().paused = false
		_set_player_control(true)

func _move_selection(direction: int) -> void:
	SFXManager.play(SFXManager.MENU_SELECT)
	selected_index = wrapi(selected_index + direction, 0, weapon_slots.size())
	_update_selection()


func _update_selection() -> void:
	for i in weapon_slots.size():
		weapon_slots[i].play("select" if i == selected_index else "no_select")

	var showing_special_weapon := weapon_slots[selected_index] == cursor_c
	ammo_bar.visible = showing_special_weapon
	if showing_special_weapon:
		ammo_bar.value = ammo_bar.max_value

func _hide_cursors() -> void:
	for slot in weapon_slots:
		slot.visible = false

func _show_cursors() -> void:
	for slot in weapon_slots:
		slot.visible = true

func _set_player_control(can_control: bool) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player and "has_control" in player:
		player.has_control = can_control

func _on_megaman_megaman_hp_changed(HP: int) -> void:
	health_bar.value = HP
	pass # Replace with function body.

func _on_score_changed(new_score: int) -> void:
	score_label.text = SCORE_format % new_score
	pass # Replace with function body.
