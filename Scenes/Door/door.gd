extends Node2D

class_name Door

@onready var sprite: Sprite2D = $Sprite2D
@onready var static_body: StaticBody2D = $StaticBody
@onready var shape : CollisionShape2D = $Static/Shape

# unique door identifier, the same key identifier can unlock the door
@export var id: int = 0

# door is open/close. if true mean door is unlocked, false doork can be locked/unlocked 
var is_open = false
# door is locked, can't be opened before unlock
var is_lock = true

const sprite_rect_opened := Rect2i(208, 160, 16, 32)
const sprite_rect_closed := Rect2i(192, 160, 16, 32)

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
	sprite.region_rect = sprite_rect_opened
	
	# collision.disabled = true
	# static_body.disabled = true
	# remove static_body layer (1)
	# 1 (player) & 3 (enemy) = 5
	static_body.set_collision_layer_value(Game.collision_layers["door"], false)
	# = static_body.collision_mask & ~5
	# print("open door collision mask = " + str(static_body.collision_mask)) 
	
func close() -> void:
	is_open = false
	sprite.region_rect = sprite_rect_closed
	static_body.set_collision_layer_value(Game.collision_layers["door"], true)
	# collision.disabled = false
	# 1 (player) & 3 (enemy) = 5
	# static_body.collision_mask = static_body.collision_mask | 5
	# print("close door collision mask = " + str(static_body.collision_mask))
	#static_body.disabled = false
	
func toggle() -> void:
	if is_open:
		close()
	else:
		open()
		
func try_unlock(body: Node2D) -> bool:
	if body.has_method("has_key"):
		return body.has_key(id)
	return false
		
func interact(body: Node2D) -> void:
	if body.has_method("has_key"):
		if body.has_key(id):
			unlock()
	toggle()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("on area 2d body entered" + str(body))
	pass # Replace with function body.
