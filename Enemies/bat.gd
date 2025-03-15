extends CharacterBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

@export var FRICTION = 200
@export var ACCELERATION = 300
@export var MAX_SPEED = 50

const EnemyDeathEffect = preload("res://Effects/enemy_death.tscn")

var knockback = Vector2.ZERO
var state = IDLE

@onready var animatedSprite = $Bat
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $HurtBox
@onready var softCollison = $SoftCollision

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = knockback
	move_and_slide()
	
	match(state):
		IDLE:
			_idle_state(delta)
		WANDER:
			_wander_state(delta)
		CHASE:
			_chase_state(delta)
	
	animatedSprite.flip_h = velocity.x < 0
	if softCollison.is_colliding():
		velocity += softCollison.get_push_vector() * delta * ACCELERATION
	move_and_slide()

func _on_hurt_box_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()

func _on_stats_no_health() -> void:
	var enemyDeathEfect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEfect)
	enemyDeathEfect.global_position = global_position
	queue_free()

func _idle_state(delta: float):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seek_player()

func _wander_state(delta: float):
	pass
	
func _chase_state(delta: float):
	var player = playerDetectionZone.player
	if player != null:
		#var direction = (player.global_position - global_position).normalized()
		var direction = global_position.direction_to(player.global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		state = IDLE

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
