extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var view_collision = $View/CollisionShape2D

@export var speed = 15
var direction: float
var view_direction: int
var player_in_vision: bool

func _ready() -> void:
	direction = 0
	view_direction = 1
	view_collision.position.x = 75
	player_in_vision = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity.x = direction * speed
	if velocity.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	if view_direction == 1:
		view_collision.position.x = 75
	else:
		view_collision.position.x = -75

	if player_in_vision == false:
		velocity.x = 0

	move_and_slide()
	
	#if velocity.x == 0:
	#	direction = direction * -1
	
	if velocity.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")


func _on_view_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_vision = true
		if body.global_position.x > global_position.x:
			direction = 1
		elif body.global_position.x < global_position.x:
			direction = -1


func _on_view_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_vision = false


func _on_timer_timeout() -> void:
	if player_in_vision == false:
		view_direction = -1 * view_direction
