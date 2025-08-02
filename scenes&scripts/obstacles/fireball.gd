extends Node2D

@export var speed : int = 25
@onready var camera: Camera2D = $"../Camera2D"


func _physics_process(delta: float) -> void:
	global_position.x -= speed
	if global_position.x <= camera.limit_left - 200:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.score -= 50
		if body.score < 0:
			body.score = 0
		print(body.score)
