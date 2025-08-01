extends CharacterBody2D

@onready var raycast: Node = $Raycast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var arm = $Arm
@onready var score_popup: Label = $Label

const SPEED = 500.0
const JUMP_VELOCITY = -600.0


var hook_pos = Vector2()
var hooked = false
var ROPE_LENGTH = 4000
var current_rope_length

var spinVel := 0.0
var totalFlipRotation: float = 0
var isFlipping: bool = false
var previousRotation: float = 0

@export var MAX_SPIN_SPEED: float = 270
const SPIN_ACCEL: float = 720

#split/star vars
var splitKeyPressTime: int = 0 #in msecs
var isDoingSplits: bool = false
var doingSplitInput: bool = false

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
	arm.visible = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpAudio.play()
		handleAnimations("airAnimation")
		
	#if not is_on_floor() and not hooked:
		#animated_sprite.play("jump")

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	

	if velocity.x > 0:
		animated_sprite.flip_h  = false 
	elif velocity.x < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		handleAnimations("onGround")
		


	
	if direction:
		if is_on_floor():
			hooked = false
			if abs(velocity.x) < SPEED:
				velocity.x += direction * ACCEL * delta
		else:
			#print("in air")
			if direction * velocity.x <= 0 or abs(velocity.x) < SPEED:
				#print("slowing down")
				velocity.x += direction * ACCEL_AIR * delta

	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN_ACCEL_GROUND * delta)
	"""
	if abs(velocity.x) > SPEED and is_on_floor():
		velocity.x = move_toward(velocity.x, ((velocity.x)/abs(velocity.x) * 0.9) * SPEED, SLOWDOWN_ACCEL_GROUND * delta)
	"""
	hook()
	
	#update()
	if hooked:
		$AnimatedSprite2D.rotation = 0
		swing(delta)
		if not is_on_floor():
			arm.visible = true
		arm.global_rotation = ((hook_pos - arm.global_position).angle()) - 67.5
		spinVel = 0
		#velocity *= .975 #Swing speed
		
	var spinInput = Input.get_axis("flip_left", "flip_right")
	if not is_on_floor() and not hooked:
		arm.visible = false
		spinVel = move_toward(spinVel, spinInput * MAX_SPIN_SPEED, SPIN_ACCEL * delta)
		$AnimatedSprite2D.rotate(deg_to_rad(spinVel) * delta)
	
	detectFlip()
	handleSplitOrStar()
	
	queue_redraw()
	
	previousRotation = $AnimatedSprite2D.rotation
	move_and_slide()

func _draw():
	var pos = global_position
	#print(hooked)
	if hooked:
		#print(position)
		#print(to_local(hook_pos))
		draw_line(arm.position, to_local(hook_pos), Color(1, 1, 1), 10, true) #cyan
	else:
		return
		#what is this? why is there code below a return?
		var colliding = $Raycast.is_colliding()
		var collide_point = $Raycast.get_collision_point()
		if colliding and pos.distance_to(collide_point) < ROPE_LENGTH:
			draw_line(Vector2.ZERO, to_local(collide_point), Color(1, 1, 1, 0.25), 3, true) #white
		arm.visible = false

func hook():
	#$Raycast.look_at(-get_global_mouse_position())
	
	
	if Input.is_action_just_pressed("left_click"):
		hook_pos = get_hook_pos()
		if not is_on_floor():
			animated_sprite.play("grapple")
		#print(hook_pos)
		if hook_pos:
			hooked = true
			handleAnimations("grapple")
			$GrabAudio.play()
			current_rope_length = global_position.distance_to(hook_pos)
	if Input.is_action_just_released("left_click") and hooked:
		hooked = false
		arm.visible = false
		if velocity.y < 0:
			$WEeeeeee.play()
		handleAnimations("airAnimation")
	#elif Input.is_action_just_released("left_click"):
		#animated_sprite.play("idle")
		
	
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

func detectFlip():
	if Input.is_action_just_pressed("flip_left") or Input.is_action_just_pressed("flip_right"):
		totalFlipRotation = 0
	
	if Input.get_axis("flip_left", "flip_right") != 0 and not hooked:
		if not isFlipping:
			isFlipping = true
			totalFlipRotation = 0
		
		var spinDelta = $AnimatedSprite2D.rotation - previousRotation
		
		#highkey stole this part from gemini but it looks right soo...
		if spinDelta > 180:
			spinDelta -= 360
		elif spinDelta < -180:
			spinDelta += 360
		
		totalFlipRotation += rad_to_deg(spinDelta)
		if abs(totalFlipRotation) >= 360:
			print("DID A FLIP")
			totalFlipRotation = 0
			$trickComplete.play()
			#will put something else here later
		
		#print(totalFlipRotation)
		
func handleSplitOrStar():
	if Input.is_action_just_pressed("splits_star") and not is_on_floor():
		splitKeyPressTime = Time.get_ticks_msec()
		doingSplitInput = true
	
	if Input.is_action_just_released("splits_star"):
		doingSplitInput = false
		if Time.get_ticks_msec() - splitKeyPressTime < 100:
			print("DID STAR")
			handleAnimations("star")
		else:
			print("FINISHED SPLITS")
			print("time: " + str((Time.get_ticks_msec() - splitKeyPressTime)/1000.0).pad_decimals(1))
			handleAnimations("airAnimation")
		isDoingSplits = false
	elif Input.is_action_pressed("splits_star") and doingSplitInput:
		if Time.get_ticks_msec() - splitKeyPressTime > 100:
			if not isDoingSplits:
				print("STARTING SPLITS")
				isDoingSplits = true
				handleAnimations("split")
				
func handleAnimations(animName: String):
	if animName == "unhook":
		if is_on_floor():
			handleAnimations("onGround")
		else:
			handleAnimations("airAnimation")
	elif animName == "onGround":
		if abs(velocity.x) >= 0.1:
			handleAnimations("run")
		else:
			handleAnimations("idle")
	elif animName == "airAnimation":
		if hooked:
			handleAnimations("grapple")
		else:
			handleAnimations("jump")
	
	
	if animName == "jump":
		animated_sprite.play("jump")
	elif animName == "idle":
		animated_sprite.play("idle")
	elif animName == "run":
		animated_sprite.play("run")
	elif animName == "split":
		if not hooked:
			animated_sprite.play("splits_noGrapple")
		else:
			animated_sprite.play("splits_whileGrapple")
	elif animName == "star":
		animated_sprite.play("star")
		await get_tree().create_timer(1).timeout
		if animated_sprite.animation == "star":
			if is_on_floor():
				handleAnimations("onGround")
			else:
				handleAnimations("airAnimation")
	elif animName == "grapple":
		animated_sprite.play("grapple")
			
