extends Node


var highest_score: int = 0
var first_play: bool = false

func game_over(recent_score):
	if recent_score > highest_score:
		highest_score = recent_score
			
