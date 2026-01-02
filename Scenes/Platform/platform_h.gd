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

func _process(delta: float) -> void:
	path.progress += speed * delta
