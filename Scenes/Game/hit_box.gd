extends Area2D

func _ready() -> void:
	# print("set active false")
	set_active(false)
	
func set_active(val: bool) -> void:
	for child in get_children():
		if child is not CollisionShape2D: continue
		# print("disable " + str(val) + " cs: " + str(child))
		child.disabled = not val

func _on_area_entered(area: Area2D) -> void:
	# print("hurt area entered")
	if area is HurtBox:
		area.get_damage(1)
