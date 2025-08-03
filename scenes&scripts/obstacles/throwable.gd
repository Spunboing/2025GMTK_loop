extends Node2D

@export var speed : int = 30

func _ready() -> void:
	$AnimationPlayer.play("spin")
	position.y = randf_range(-1250, 1250)

func _process(delta: float) -> void:
	position.x -= speed
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
