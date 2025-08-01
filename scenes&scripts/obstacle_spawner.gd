extends Node2D

var fireball = preload("res://scenes&scripts/obstacles/fireball.tscn")
var activate : bool = false
func _process(delta: float) -> void:
	await get_tree().create_timer(3).timeout
	activate = true
	
	for n in round(randf_range(4, 8)):
		if activate:
			var instance = fireball.instantiate()
			instance.global_position = global_position
			$"../..".add_child(instance)
			await get_tree().create_timer(1).timeout
	activate = false
