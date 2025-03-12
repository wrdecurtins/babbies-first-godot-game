extends Node

@export var max_health = 1
@onready var health = max_health:
	get = get_health,
	set = set_health

func get_health():
		return health
func set_health(value):
		health = value
		if health <= 0:
			emit_signal('no_health')

signal no_health
