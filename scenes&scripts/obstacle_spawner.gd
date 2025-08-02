extends Node2D

@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var camera: Camera2D = $"../Camera2D"
@onready var half_screen_size_horizontal: float = (get_viewport().size.x*(1/camera.zoom.x))/2
@onready var half_screen_size_vertical: float = (get_viewport().size.y*(1/camera.zoom.y))/2
@onready var timer: Timer = $Timer

var fireball = preload("res://scenes&scripts/obstacles/fireball.tscn")
var axe = preload("res://scenes&scripts/obstacles/axe.tscn")
var activate : bool = false

func _ready():
	await get_tree().create_timer(2).timeout
	spawn_obstacle()

func spawn_obstacle() -> void:
	var offset: int = 200
	activate = true
	print(half_screen_size_horizontal-(player.global_position.x-camera.limit_left))
	for n in round(randf_range(4, 8)):
		if activate:
			var instance
			if round(randf_range(0, 1)) == 0:
				instance = fireball.instantiate()
			else:
				instance = axe.instantiate()
			instance.global_position = Vector2((player.global_position.x+2*half_screen_size_horizontal+offset),(randf_range((player.global_position.y-20), (player.global_position.y+20))))
			add_sibling(instance)
			await get_tree().create_timer(2).timeout
	activate = false
	await get_tree().create_timer(10)
	spawn_obstacle()
