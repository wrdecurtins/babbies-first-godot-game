extends AnimatedSprite2D

func _ready():
	connect("animation_finished", Callable(self, "_on_animation_finished"))
	frame = 0
	play('default')


func _on_animation_finished() -> void:
	queue_free()

func createDeathEffect():
	pass
	
