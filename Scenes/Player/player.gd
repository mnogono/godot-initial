extends CharacterBody2D


@export var speed: float = 100
@export var jump: float = 250 

@onready var anim = $AnimatedSprite2D

#const SPEED = 200.0
#const JUMP_VELOCITY = -200.0
var nearbly_interactive: Array[Node2D] = []
var keys: Array[int] = []

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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and nearbly_interactive.is_empty() == false:
		print("interact with...")
		for it in nearbly_interactive:
			print("object: " + str(it))
			if it.has_method("interact"):
				it.interact(self)

func _on_interaction_area_body_entered(body: Node2D) -> void:
	print("_on_interaction_area_body_entered: " + str(body))
	nearbly_interactive.append(body)


func _on_interaction_area_body_exited(body: Node2D) -> void:
	nearbly_interactive.erase(body)

func pickup_key(id: int) -> void:
	keys.append(id)
	
func has_key(id: int) -> bool:
	return keys.has(id)


func _on_interaction_area_area_entered(area: Area2D) -> void:
	if Input.is_action_pressed("ui_up"):
		if area.has_method("stair"):
			area.stair(true)
		print("up!")
	print("_on_interaction_area_area_entered: " + str(area))


#func _on_interaction_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("ASDASD")
#
#
#func _on_interaction_area_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#print("BBBBASD")
