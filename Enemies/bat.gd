extends CharacterBody2D

enum {
	IDLE,
	WANDER,
	CHASE
}

@export var FRICTION = 200
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var INVINCIBILITY_DURATION = 0.3

const EnemyDeathEffect = preload("res://Effects/enemy_death.tscn")

var knockback = Vector2.ZERO
var state = IDLE
var randomStateSet = [IDLE, WANDER]

@onready var animatedSprite = $Bat
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $HurtBox
@onready var softCollison = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

func _ready():
	randomize()
	state = randomStateSet.pick_random()

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
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_stats_no_health() -> void:
	var enemyDeathEfect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEfect)
	enemyDeathEfect.global_position = global_position
	queue_free()
	
func accelerate_Toward(vector_pos):
	var direction = global_position.direction_to(vector_pos).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)

func _idle_state(delta: float):
	seek_player()
	set_random_state()
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func _wander_state(_delta: float):
	seek_player()
	set_random_state()
	accelerate_Toward(wanderController.target_position)
	
	if global_position.distance_to(wanderController.target_position) <= 2:
		update_wander()
	
func _chase_state(_delta: float):
	var player = playerDetectionZone.player
	if player != null:
		accelerate_Toward(player.global_position)
	else:
		state = IDLE

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func set_random_state():
	if wanderController.get_time_left() == 0:
		update_wander()
		
func update_wander():
	state = randomStateSet.pick_random()
	wanderController.start_wander_timer(randi_range(1, 3))


func _on_hurt_box_invincibility_started() -> void:
	animationPlayer.play("Start")

func _on_hurt_box_invincibility_ended() -> void:
	animationPlayer.play("Stop")
