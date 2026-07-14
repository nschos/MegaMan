extends Node

signal score_changed(new_score: int)

const POINTS_PER_ENEMY := 200

const POINTS_PER_BONUS_PEARL := 10
const POINTS_PER_SMALL_WEAPON_REFILL := 25
const POINTS_PER_BIG_WEAPON_REFILL := 50

const HP_PER_SMALL_ENERGY_REFILL := 4
const HP_PER_BIG_ENERGY_REFILL := 10

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

func collect_drop(drop_type: Drop.DropType, player: MegaMan) -> void:
	match drop_type:
		Drop.DropType.BONUS_PEARL:
			add_score(POINTS_PER_BONUS_PEARL)
			SFXManager.play(SFXManager.BONUS_BALL)

		Drop.DropType.SMALL_WEAPON_REFILL:
			add_score(POINTS_PER_SMALL_WEAPON_REFILL)
			SFXManager.play(SFXManager.ENERGY_FILL)

		Drop.DropType.BIG_WEAPON_REFILL:
			add_score(POINTS_PER_BIG_WEAPON_REFILL)
			SFXManager.play(SFXManager.ENERGY_FILL)

		Drop.DropType.SMALL_ENERGY_REFILL:
			if player:
				player.heal(HP_PER_SMALL_ENERGY_REFILL)
			SFXManager.play(SFXManager.ENERGY_FILL)

		Drop.DropType.BIG_ENERGY_REFILL:
			if player:
				player.heal(HP_PER_BIG_ENERGY_REFILL)
			SFXManager.play(SFXManager.ENERGY_FILL)

		Drop.DropType.EXTRA_LIFE:
			SFXManager.play(SFXManager.ONE_UP)

		Drop.DropType.NOTHING:
			pass
