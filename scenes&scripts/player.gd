extends CharacterBody2D

@onready var raycast: Node = $Raycast

const SPEED = 500.0
const JUMP_VELOCITY = -600.0

var hook_pos = Vector2()
var hooked = false
var ROPE_LENGTH = 1000
var current_rope_length

@export var GRAPPLE_ACCEL_MULT: float = 1
@export var ROPE_STIFFNESS: float = 0.7
@export var ROPE_DAMPING: float = 1
@export var FORCE_MULT: float = 600
@export var ROPE_PULL_IN_SPEED: float = 3

@export var ACCEL: float = 50 #how much the player can accelerate horizontally by
@export var ACCEL_AIR: float = 2000
@export var SLOWDOWN_ACCEL_GROUND: float = 40 #how quickly the game slows down the player when they are over max speed

func _ready() -> void:
	current_rope_length = ROPE_LENGTH

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
		if is_on_floor():
			if abs(velocity.x) < SPEED:
				velocity.x += direction * ACCEL * delta
		else:
			#print("in air")
			if direction * velocity.x <= 0 or abs(velocity.x) < SPEED:
				print("slowing down")
				velocity.x += direction * ACCEL_AIR * delta

	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN_ACCEL_GROUND * delta)
	"""
	if abs(velocity.x) > SPEED and is_on_floor():
		velocity.x = move_toward(velocity.x, ((velocity.x)/abs(velocity.x) * 0.9) * SPEED, SLOWDOWN_ACCEL_GROUND * delta)
	"""
	hook()
	queue_redraw()
	#update()
	if hooked:
		swing(delta)
		#velocity *= .975 #Swing speed
	move_and_slide()

func _draw():
	var pos = global_position
	#print(hooked)
	if hooked:
		#print(position)
		#print(to_local(hook_pos))
		draw_line(Vector2.ZERO, to_local(hook_pos), Color(0.35, 0.7, 0.9), 3, true) #cyan
	else:
		return
		
		var colliding = $Raycast.is_colliding()
		var collide_point = $Raycast.get_collision_point()
		if colliding and pos.distance_to(collide_point) < ROPE_LENGTH:
			draw_line(Vector2.ZERO, to_local(collide_point), Color(1, 1, 1, 0.25), 3, true) #white

func hook():
	#$Raycast.look_at(-get_global_mouse_position())
	
	
	if Input.is_action_just_pressed("left_click"):
		hook_pos = get_hook_pos()
		#print(hook_pos)
		if hook_pos:
			hooked = true
			current_rope_length = global_position.distance_to(hook_pos)
	if Input.is_action_just_released("left_click") and hooked:
		hooked = false
		
func get_hook_pos():
	var state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, get_global_mouse_position())
	query.exclude = [self]
	
	var result = state.intersect_ray(query)
	
	if result:
		if (result.position - global_position).length() < ROPE_LENGTH:
			return result.position
		
	#old code
	"""
	for ray in $Raycast.get_children():
		if ray.is_colliding():
			return ray.get_collision_point()
	"""
func swing(delta):
	#old code
	"""
	var rad =  global_position - hook_pos
	if velocity.length() < 0.01 or rad.length() < 10:
		return
	var angle = acos(rad.dot(velocity) / (rad.length() * velocity.length()))
	var rad_vel = cos(angle) * velocity.length()
	velocity += rad.normalized() * -rad_vel
	
	if global_position.distance_to(hook_pos) > current_rope_length:
		global_position = hook_pos + rad.normalized() * current_rope_length
		
	velocity +=  (hook_pos - global_position).normalized() * 15000 * delta
	"""
	var force = Vector2.ZERO
	var toHook = hook_pos - global_position
	
	#apply acceleration force NOT IN USE
	#force += toHook * GRAPPLE_ACCEL_MULT
	
	#apply of rope pulling on player, slightly elastic
	
	if toHook.length() > current_rope_length:
		var grappleForce = toHook.normalized() * (toHook.length() - current_rope_length) * ROPE_STIFFNESS
		force += grappleForce
		
		var velAlongRope = velocity.dot(toHook.normalized())
		var dampForce = -toHook.normalized() * velAlongRope * ROPE_DAMPING
		force += dampForce
	
	velocity += force * delta * FORCE_MULT
	current_rope_length = move_toward(current_rope_length, 15, ROPE_PULL_IN_SPEED * delta)
