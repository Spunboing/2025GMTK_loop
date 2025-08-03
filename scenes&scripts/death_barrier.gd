extends Area2D

@onready var camera: Camera2D = $"../Camera2D"
@export var death_barrier_offset: int = 2500
@onready var gameover: Node2D = $"../gameover"
@onready var score: Label = $"../CanvasLayer/score"

func _process(delta: float) -> void:
	global_position.x = camera.limit_left - death_barrier_offset
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("you died")
		print(str(int(score.text))+"DHKAHDKASHDJKAHDIJ")
		gameover.game_over(int(score.text))
	
