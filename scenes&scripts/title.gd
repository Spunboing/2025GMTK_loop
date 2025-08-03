extends Node2D


func _ready() -> void:
	MusicController.play_title_theme()
	$AnimationPlayer.play("opensesame")


func _on_button_pressed() -> void:
	GlobalData.gameplay_active = true
	MusicController.play_gameplay_music()
	get_tree().change_scene_to_file("res://scenes&scripts/grapple_test(Joey).tscn")
