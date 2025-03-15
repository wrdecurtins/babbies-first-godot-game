extends Control

@onready var playerStats = PlayerStats
@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

@export var hearts = 4:
	set = set_hearts
@export var max_hearts = 4:
	set(value):
		max_hearts = max(value, 1)
		if heartUIEmpty != null:
			heartUIEmpty.size.x = max_hearts * 15

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.size.x = hearts * 15

func _ready():
	self.max_hearts = playerStats.max_health
	self.hearts = playerStats.health
	playerStats.connect('health_changed', func(x): hearts = x)
	playerStats.connect('max_health_changed', func(x): max_hearts = x)
