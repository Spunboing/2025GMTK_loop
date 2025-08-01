extends Node2D

var fireball = preload("res://scenes&scripts/obstacles/fireball.tscn")

func _process(delta: float) -> void:
	await get_tree().create_timer(3000).timeout
	
	for n in round(randf_range(4, 8)):
		add_child(fireball.instantiate())
