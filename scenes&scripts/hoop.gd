extends Node2D

var used: bool = false
@onready var hoop_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !used:
		if body.is_in_group("player"):
			hoop_sfx.play()
			body.add_score_mult(1)
			used = true
