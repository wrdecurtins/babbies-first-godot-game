extends Area2D

@export var show_hit: bool = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

func _on_area_entered(area: Area2D) -> void:
	if show_hit:
		var hitEffect = HitEffect.instantiate()
		var world = get_tree().current_scene
		world.add_child(hitEffect)
		hitEffect.global_position = global_position
