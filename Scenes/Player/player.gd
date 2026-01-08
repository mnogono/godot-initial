extends CharacterBody2D
class_name Player

@export var speed: float = 100
@export var jump: float = 250 
@export var climb: float = 50

@onready var anim = $AnimatedSprite2D
@onready var no_key : Sprite2D = $NoKey
@onready var hurt_box: HurtBox = $HurtBox

var nearbly_interactive: Array[Node2D] = []
var nearbly_item: Array[Node2D] = []
var keys: Array[int] = []
var is_ladder: bool = false
var view_direction: int = 0
var state: State = State.Idle
enum State {Idle, Walk, Jump, Fall, Died, Climb}

func _ready() -> void:
	add_to_group("player")
	
func _play_animation(animation: String) -> void:
	if anim.animation == animation:
		return
	anim.play(animation)
	
func state_animation() -> void:
	match state:
		State.Idle: _play_animation("idle")
		State.Walk: _play_animation("walk")
		State.Jump: _play_animation("jump")
		State.Fall: _play_animation("fall")
		State.Died: _play_animation("died")
		State.Climb: _play_animation("climb")

func state_transition() -> void:
	if state == State.Died:
		# died can't be transition to other state
		return
	if hurt_box.hp == 0:
		state = State.Died
		return
	if velocity.y != 0:
		if is_ladder:
			state = State.Climb
		elif velocity.y < 0:
			state = State.Jump
		else:
			state = State.Fall
		return
	if velocity.x:
		state = State.Walk
		return
	state = State.Idle

func _physics_process(delta: float) -> void:
	state_transition()
	state_animation()
	if state == State.Died:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = -1 * jump
	var move_x_direction = Input.get_axis("move_left", "move_right")
	if move_x_direction:
		velocity.x = move_x_direction * speed
		view_direction = int(move_x_direction)
	else:
		velocity.x = 0
	anim.flip_h = view_direction == -1
	if is_ladder:
		var move_y_direction = Input.get_axis("move_up", "move_down")
		velocity.y = move_y_direction * climb

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = -1 * jump

	#if velocity.y != 0:
		#if velocity.y < 0:
			#anim.play("jump")
		#else:
			#anim.play("fall")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * speed
		#anim.flip_h = direction == -1 
		#anim.play("move")
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)

	#if velocity.x == 0 && velocity.y == 0:
		#anim.play("idle")
		
	#if is_ladder == true:
		#print("climbing...")
		#var _direction = Input.get_axis("ui_up", "ui_down")
		#velocity.y = _direction * climb
	move_and_slide()

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact"):
		#print("nearble_interactive size: " + str(nearbly_interactive.size()))
	if event.is_action_pressed("interact") and nearbly_interactive.is_empty() == false:
		#print("interact with...")
		for it in nearbly_interactive:
			#print("object check interact method: " + str(it))
			if it.has_method("interact"):
				it.interact(self)
			if it.has_method("try_unlock"):
				if it.try_unlock(self) == false:
					no_key.visible = true
					await get_tree().create_timer(1.0).timeout
					no_key.visible = false

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("interactive"):
		nearbly_interactive.append(body)
	if body.is_in_group("ladder"):
		is_ladder = true
		#print("player overlap ladder enter")
	#print("_on_interaction_area_body_entered: " + str(body))
	#if body is TileMapLayer:
		#if velocity.y != 0:
			#var stairs := body as TileMapLayer
			#stairs.collision_enabled = true
	


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("interactive"):
		nearbly_interactive.erase(body)
	if body.is_in_group("ladder"):
		is_ladder = false
		#print("player move out from ladder")
	#print("_on_interaction_area_body_exited: " + str(body))
	#if body is TileMapLayer:
		#var stairs := body as TileMapLayer
		#stairs.collision_enabled = false
	

func pickup_key(id: int) -> void:
	keys.append(id)
	
func has_key(id: int) -> bool:
	return keys.has(id)

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if Input.is_action_pressed("ui_up"):
		if area.has_method("stair"):
			area.stair(true)
	#print("_on_interaction_area_area_entered: " + str(area))

#func _on_hurt_box_hurted() -> void:
	#print("Autch!")

func _on_hurt_box_died() -> void:
	anim.play("died")
	await anim.animation_finished
	Game.restart_level()
