extends Node2D

@onready var camera: Camera2D = $"../Camera2D"
@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var half_screen_size_horizontal: float = (get_viewport().size.x*(1/camera.zoom.x))/2
@onready var half_screen_size_vertical: float = (get_viewport().size.y*(1/camera.zoom.y))/2
@onready var cam_pos: Vector2 = camera.position
@onready var player_pos: Vector2 = player.position


@export var despawn_distance = 20000

var rng = RandomNumberGenerator.new()
var grapple_point = preload("res://scenes&scripts/grapple_point.tscn")

func _ready():
	camera.limit_left = int(camera.global_position.x) - 4000
	despawn()
	
func despawn():
	for i in get_tree().get_nodes_in_group("point spawner"):
		player.global_position.x - i.global_position.x
		if i.global_position.x <= camera.limit_left - 200:
			print("DESPAWNIG GRAPPLE POINT")
			i.queue_free()
	await get_tree().create_timer(1).timeout
	despawn()
			
func _process(delta: float) -> void:
	if player.position.x >= player_pos.x + 2000:
		change_camera_limit()
		print("SPAWNING GRAPPLE POINT")
		player_pos = player.position
		spawn_grapple_point()

func change_camera_limit():
	camera.limit_left = int(camera.global_position.x) - 4000

func spawn_grapple_point():
	var offset: int = 500
	var point = grapple_point.instantiate()
	add_child(point)
	point.global_position = Vector2((player.global_position.x+half_screen_size_horizontal+offset),(rng.randf_range((camera.limit_top)+half_screen_size_vertical,camera.limit_top+400)))
