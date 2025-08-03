extends Node2D

@export var speed : int = 25

@onready var camera: Camera2D = $"../Camera2D"

var minus_score: int

func _ready() -> void:
	$AnimationPlayer.play("spin")

func _physics_process(delta: float) -> void:
	if GlobalData.gameplay_active:
		global_position.x -= speed
		if global_position.x <= camera.limit_left - 200:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if GlobalData.gameplay_active:
		if body.is_in_group("player"):
			if self.is_in_group("axe"):
				minus_score = -25
			elif self.is_in_group("fire"):
				minus_score = -50
			print("OW")
			body.addScore(minus_score,1)
			if body.score < 0:
				body.score = 0
			print(body.score)
