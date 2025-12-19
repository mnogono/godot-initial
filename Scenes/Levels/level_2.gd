extends Node2D

@onready var player: Player = $Player


func _on_area_2d_body_entered(body: Node2D) -> void:
	Game.restart_level()
