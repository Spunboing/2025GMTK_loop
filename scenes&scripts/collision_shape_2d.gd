extends CollisionShape2D


@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation = animated_sprite_2d.rotation
