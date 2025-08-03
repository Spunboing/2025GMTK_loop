extends Node

var highest_score: int = 0

func get_high_score(recent_score):
	if recent_score > highest_score:
		highest_score = recent_score
	return highest_score
