extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
# view area collision, player intersect this activate walk to player
@onready var view_collision = $ViewArea/CollisionShape2D
# TODO убрать AttackArea - вычислять по разнице расстояния
@export var speed = 15
@export var speed_chase = 25

var move_direction: float
var view_direction: int
var player_in_vision: bool
var player_in_attack_range: bool
var is_attacking: bool
var state: State
enum State {Idle, Walk, Attack, Chase}

func _ready() -> void:
	state = State.Idle
	move_direction = 0
	view_direction = 1
	view_collision.position.x = view_collision.shape.size.x / 2
	player_in_vision = false
	player_in_attack_range = false
	is_attacking = false
	#anim.animation_finished.connect(_on_attack_animation_finished)

func _play_animation(animation: String) -> void:
	if anim.animation == animation:
		return
	anim.play(animation)

func state_animation() -> void:
	match state:
		State.Idle: _play_animation("idle")
		State.Walk: _play_animation("walk")
		State.Chase: _play_animation("walk")
		State.Attack: _play_animation("attack")
		
func state_physics_process() -> void:
	match state:
		State.Walk:
			velocity.x = move_direction * speed
		State.Chase:
			velocity.x = move_direction * speed_chase
		State.Attack, State.Idle:
			velocity.x = 0
	if velocity.x < 0 || view_direction == -1:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
		
func state_update() -> void:
	if is_attacking:
		state = State.Attack
	elif player_in_attack_range:
		state = State.Attack
	elif player_in_vision:
		state = State.Chase
	else:
		state = State.Idle
		

func update_view_collision_position() -> void:
	if view_direction == 1:
		view_collision.position.x = view_collision.shape.size.x / 2
	else:
		view_collision.position.x = -view_collision.shape.size.x / 2

func _physics_process(delta: float) -> void:
	state_physics_process()
	state_animation()
	move_and_slide()


func wait(sec: float) -> void:
	await get_tree().create_timer(sec).timeout

func _on_view_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_vision = true
		await wait(1.0)
		move_direction = sign(body.global_position.x - global_position.x)
		state_update()


func _on_view_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_vision = false
		move_direction = 0
		state_update()


func _on_timer_timeout() -> void:
	if player_in_vision == false:
		view_direction = -1 * view_direction
		update_view_collision_position()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = true
		state_update()


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_range = false
		state_update()


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
		state_update()


func _on_animated_sprite_2d_animation_changed() -> void:
	if anim == null:
		return
	if anim.animation == "attack":
		is_attacking = true
		state_update()


func _on_animated_sprite_2d_frame_changed() -> void:
	if not anim: return
	if anim.animation == "attack":
		if anim.frame == 6:
			print("hit box activated")
		elif anim.frame == 9:
			print("hit box deactivated")
