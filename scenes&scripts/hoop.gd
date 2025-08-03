extends Node2D

var used: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !used:
		if body.is_in_group("player"):
			body.add_score_mult(1)
			used = true
