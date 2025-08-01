extends Node2D

@onready var timer: Timer = $Timer
var fireball = preload("res://scenes&scripts/obstacles/fireball.tscn")
var axe = preload("res://scenes&scripts/obstacles/axe.tscn")
var activate : bool = false

func _ready():
	await get_tree().create_timer(2).timeout
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	activate = true
	
	for n in round(randf_range(4, 8)):
		if activate:
			var instance
			if round(randf_range(0, 1)) == 0:
				instance = fireball.instantiate()
			else:
				instance = axe.instantiate()
			instance.global_position = global_position
			$"../..".add_child(instance)
			await get_tree().create_timer(1).timeout
	activate = false
	timer.start()
