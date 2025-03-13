extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death.tscn")

var knockback = Vector2.ZERO

@onready var stats = $Stats

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	velocity = knockback
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockback_vector * 120

func _on_stats_no_health() -> void:
	var enemyDeathEfect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEfect)
	enemyDeathEfect.global_position = global_position
	queue_free()
