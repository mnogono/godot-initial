extends Node2D

class_name Door

@onready var sprite: Sprite2D = $Sprite2D
@onready var static_body: StaticBody2D = $StaticBody2D
@onready var trigger : Area2D = $Area2D

@export var id: int = 0

var is_open = false
var is_lock = true

const region_opened := Rect2i(208, 160, 16, 32)
const region_closed := Rect2i(192, 160, 16, 32)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("door")
	add_to_group("interactive")
	sprite.region_enabled = true
	close()

func unlock() -> void:
	is_lock = false

func open() -> void:
	if is_lock:
		return
	is_open = true
	sprite.region_rect = region_opened
	# static_body.disabled = true
	# remove static_body layer (1)
	static_body.collision_layer = static_body.collision_layer & ~1 
	
func close() -> void:
	is_open = false
	sprite.region_rect = region_closed
	static_body.collision_layer = static_body.collision_layer | 1 
	#static_body.disabled = false
	
func toggle() -> void:
	if is_open:
		close()
	else:
		open()
		
func interact(body: Node2D) -> void:
	if body.has_method("has_key"):
		if body.has_key(id):
			unlock()
	toggle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("on area 2d body entered" + str(body))
	pass # Replace with function body.
