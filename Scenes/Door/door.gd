extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_collision: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var trigger : Area2D = $Area2D

var is_open = false

const region_opened := Rect2i(208, 160, 16, 32)
const region_closed := Rect2i(192, 160, 16, 32)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.region_enabled = true
	close()

func open() -> void:
	is_open = true
	sprite.region_rect = region_opened
	wall_collision.disabled = true
	
func close() -> void:
	is_open = false
	sprite.region_rect = region_closed
	wall_collision.disabled = false
	
func toggle() -> void:
	if is_open:
		close()
	else:
		open()
