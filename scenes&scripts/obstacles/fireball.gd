extends Node2D

@export var speed : int = 50

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x -= speed
