extends Label

var init_pos: Vector2 = position
var speed: int = 200

@onready var score_time: Timer = $score_time

func activate(score):
	if score <= 0:
		add_theme_color_override("font_color", Color(.87, .0, .0, 1)) #red
	else:
		add_theme_color_override("font_color", Color(.89, .67, .00, 1))#gold
	position = init_pos
	text = str(score)
	visible = true
	score_time.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= delta*speed

func _on_score_time_timeout() -> void:
	visible = false
	position = init_pos
