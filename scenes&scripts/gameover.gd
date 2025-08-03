extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var current_score: Label = $CanvasLayer/AnimationPlayer/currentScore
@onready var high_score: Label = $CanvasLayer/AnimationPlayer/highScore

func game_over(cur_score: int):
	current_score.text = str(cur_score)
	high_score.text = str(GlobalData.get_high_score(cur_score))
	animation_player.play("curtains_close")


func _on_button_pressed() -> void:
	current_score.visible = true
	high_score.visible = true
	get_tree().reload_current_scene()
	
