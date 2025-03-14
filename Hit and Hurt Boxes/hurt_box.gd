extends Area2D

@export var show_hit: bool = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended

@onready var timer = $Timer

var invincible = false:
	get:
		return invincible
	set(value):
		invincible = value
		if invincible == true:
			emit_signal('invincibility_started')
		else:
			emit_signal('invincibility_ended')

func create_hit_effect():
	var hitEffect = HitEffect.instantiate()
	var world = get_tree().current_scene
	world.add_child(hitEffect)
	hitEffect.global_position = global_position

func start_invincibility(duration):
	invincible = true
	timer.start(duration)

func _on_timer_timeout() -> void:
	invincible = false;


func _on_invincibility_ended() -> void:
	set_deferred('monitoring', true)

func _on_invincibility_started() -> void:
	set_deferred('monitoring', false)
