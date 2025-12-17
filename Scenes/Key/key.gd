extends Node2D
class_name Key

@export var id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("key")
	add_to_group("interactive")


func pickup(body: Node2D) -> void:
	if body.has_method("pickup_key"):
		body.pickup_key(id)
	queue_free()
