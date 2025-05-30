extends Node2D

@export var wander_range = 32

@onready var timer = $Timer
@onready var start_position = global_position
@onready var target_position = global_position

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randi_range(-wander_range, wander_range), randi_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left
	
func is_stopped():
	return timer.is_stopped()
	
func start_wander_timer(duration):
	timer.start(duration)

func _on_timer_timeout() -> void:
	update_target_position()
