extends Path2D

@export var close_path = true
@export var speed : int = 1
@export var speed_scale = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready():
	if not close_path:
		animation.play("move")
		animation.speed_scale = speed_scale
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress += speed * delta
	#var path := get_parent() as PathFollow2D
	#path.set_progress(path.get_progress() + speed * delta)
	#path.get_
	#move_and_collide()
