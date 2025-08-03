extends Label

@onready var player: CharacterBody2D = $"../../CharacterBody2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mult_sec_left =  player.score_mult_timer.time_left
	if player.score_mult != 1:
		text = str(player.score_mult) + "X " + str(mult_sec_left).pad_decimals(2)
	else:
		text = ""
