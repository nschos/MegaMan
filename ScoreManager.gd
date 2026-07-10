extends Node

signal score_changed(new_score: int)

const POINTS_PER_ENEMY := 200

var score: int = 0:
	set(value):
		score = max(0, value)
		score_changed.emit(score)

func add_score(amount: int) -> void:
	score += amount

func add_enemy_kill_score() -> void:
	add_score(POINTS_PER_ENEMY)

func reset_score() -> void:
	score = 0
