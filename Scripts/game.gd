extends Node

var level: int
var levels: Array[String] = [
	"res://Scenes/Levels/level_1.tscn",
	"res://Scenes/Levels/level_2.tscn",
	"res://Scenes/Levels/level_3.tscn",
]
const collision_layers := {
	"player": 1,
	"interactive": 2,
	"enemies": 3,
	"ground": 4,
	"door": 5
}

func _ready() -> void:
	level = 0

func restart_level() -> void:
	var tree := get_tree()
	var path := tree.current_scene.scene_file_path
	if path.is_empty():
		push_warning("Current scene has no scene_file_path; can't restart.")
		return
	tree.change_scene_to_file(path)

func next_level() -> void:
	level = (level + 1) % (levels.size())
	get_tree().change_scene_to_file(levels[level])
