extends CharacterBody2D;
@export var ACCELERATION = 500
@export var MAX_SPEED = 80
@export var FRICTION = 400
@export var ROLL_SPEED = MAX_SPEED * 1.25
@export var HIT_INVICIBILITY = .5

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK,
}

var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get('parameters/playback')
@onready var swordHitBox = $HitBoxPivot/SwordHitbox
@onready var playerStats = PlayerStats
@onready var hurtbox = $HurtBox
@onready var blinkAnimationPlayer = $BlinkAnimation

var input_vector = Vector2.ZERO
var roll_vector = Vector2.DOWN

func _ready() -> void:
	playerStats.connect('no_health', queue_free)
	animationTree.active = true
	swordHitBox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta: float):
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitBox.knockback_vector = input_vector
		animationTree.set('parameters/Idle/blend_position', input_vector)
		animationTree.set('parameters/Run/blend_position', input_vector)
		animationTree.set('parameters/Attack/blend_position', input_vector)
		animationTree.set('parameters/Roll/blend_position', input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed('Attack'):
		state = ATTACK
		velocity = Vector2.ZERO
	elif Input.is_action_just_pressed('Roll'):
		state = ROLL

	move_and_slide()

func attack_state(_delta: float):
	animationState.travel('Attack')

func attack_animation_finished():
	state = MOVE
	
func roll_state(_delta: float):
	animationState.travel('Roll')
	velocity = roll_vector * ROLL_SPEED
	move_and_slide()
	
func roll_animation_finished():
	state = MOVE


func _on_hurt_box_area_entered(area: Area2D) -> void:
	playerStats.health -= area.damage
	hurtbox.start_invincibility(HIT_INVICIBILITY)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_hurt_box_invincibility_started() -> void:
	blinkAnimationPlayer.play("Start")

func _on_hurt_box_invincibility_ended() -> void:
	blinkAnimationPlayer.play('Stop')
