extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var current_score: Label = $CanvasLayer/AnimationPlayer/currentScore
@onready var high_score: Label = $CanvasLayer/AnimationPlayer/highScore
@onready var new_high_score: Label = $"CanvasLayer/AnimationPlayer/NEW HIGH SCORE"
@onready var newhighscore: AnimationPlayer = $CanvasLayer/newhighscore


func game_over(cur_score: int):
	if cur_score > GlobalData.highest_score:
		newhighscore.play("newHighScore")
		print("YAHOO")
		
	var cur_score_zeros: String = ""
	var high_score_zeros: String = ""
	
	#Fills out score display up to the millionths place
	for i in 7-str(cur_score).length():
		cur_score_zeros += "0"
	for i in 7-str(GlobalData.get_high_score(cur_score)).length():
		high_score_zeros += "0"
			
	current_score.text = "Score: " + cur_score_zeros + str(cur_score)
	high_score.text = "High Score: " + high_score_zeros + str(GlobalData.get_high_score(cur_score))
	animation_player.play("curtains_close")


func _on_button_pressed() -> void:
	current_score.visible = false
	high_score.visible = false
	new_high_score.visible = false
	get_tree().reload_current_scene()
	
