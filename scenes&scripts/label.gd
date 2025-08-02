extends Label

@onready var player: CharacterBody2D = $"../../CharacterBody2D"
var zeros: String = ""
var prev_score: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if prev_score.length() != str(player.score).length():
		setZeros()
	text = zeros + str(player.score)
	prev_score = text

func _ready() -> void:
	setZeros()

func setZeros():
	zeros = ""
	for i in 7-str(player.score).length():
		zeros += "0"
