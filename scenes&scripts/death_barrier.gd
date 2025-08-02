extends Area2D

@onready var camera: Camera2D = $"../Camera2D"
@export var death_barrier_offset: int = 2500

func _process(delta: float) -> void:
	global_position.x = camera.limit_left - death_barrier_offset
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("you died")
		get_tree().reload_current_scene()
	
