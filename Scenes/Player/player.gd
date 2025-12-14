extends CharacterBody2D

@export var speed: float = 100
@export var jump: float = 250 

@onready var anim = $AnimatedSprite2D

#const SPEED = 200.0
#const JUMP_VELOCITY = -200.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -1 * jump

	if velocity.y != 0:
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		anim.flip_h = direction == -1 
		anim.play("move")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if velocity.x == 0 && velocity.y == 0:
		anim.play("idle")

	move_and_slide()
