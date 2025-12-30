extends Area2D
class_name HurtBox

signal hurted()
signal died()

@export var hp := 3

func get_damage(val: int) -> void:
	hp -= val
	if hp <= 0:
		died.emit()
	else:
		hurted.emit()
