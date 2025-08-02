extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = $"../CharacterBody2D".global_position.x
	#zoom = Vector2(1,1) * clamp(remap($"../CharacterBody2D".velocity.length(), 1000, 3000, 0.3, 0.25), 0.25, 0.3)
