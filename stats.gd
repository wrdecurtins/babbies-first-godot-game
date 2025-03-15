extends Node

@export var max_health = 4:
	set(value):
		max_health = value
		emit_signal('max_health_changed', max_health)
		health = min(health, max_health)
@export var health = max_health:
	set = set_health

func set_health(value):
		health = value
		emit_signal('health_changed', health)
		if health <= 0:
			emit_signal('no_health')

signal no_health
signal health_changed(value)
signal max_health_changed(value)
