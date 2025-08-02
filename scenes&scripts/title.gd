extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("opensesame")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes&scripts/grapple_test(Joey).tscn")
