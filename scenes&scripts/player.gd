extends CharacterBody2D

@onready var raycast: Node = $Raycast

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var hook_pos = Vector2()
var hooked = false
var rope_length = 500
var current_rope_length

func _ready() -> void:
	current_rope_length = rope_length

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	hook()
	queue_redraw()
	#update()
	if hooked:
		swing(delta)
		velocity *= .975 #Swing speed
	move_and_slide()

func _draw():
	var pos = global_position
	print(hooked)
	if hooked:
		print(position)
		print(to_local(hook_pos))
		draw_line(Vector2.ZERO, to_local(hook_pos), Color(0.35, 0.7, 0.9), 3, true) #cyan
	else:
		return
		
		var colliding = $Raycast.is_colliding()
		var collide_point = $Raycast.get_collision_point()
		if colliding and pos.distance_to(collide_point) < rope_length:
			draw_line(Vector2.ZERO, to_local(collide_point), Color(1, 1, 1, 0.25), 3, true) #white

func hook():
	$Raycast.look_at(-get_global_mouse_position())
	if Input.is_action_just_pressed("left_click"):
		hook_pos = get_hook_pos()
		print(hook_pos)
		if hook_pos:
			hooked = true
			current_rope_length = global_position.distance_to(hook_pos)
	if Input.is_action_just_released("left_click") and hooked:
		hooked = false
		
func get_hook_pos():
	for ray in $Raycast.get_children():
		if ray.is_colliding():
			return ray.get_collision_point()
			
func swing(delta):
	var rad =  global_position - hook_pos
	if velocity.length() < 0.01 or rad.length() < 10:
		return
	var angle = acos(rad.dot(velocity) / (rad.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	velocity += rad.normalized() * -rad_vel
	
	if global_position.distance_to(hook_pos) > current_rope_length:
		global_position = hook_pos + rad.normalized() * current_rope_length
		
	velocity +=  (hook_pos - global_position).normalized() * 15000 * delta
			
			
		
