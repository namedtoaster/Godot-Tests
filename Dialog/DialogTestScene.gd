extends Node2D

export(String) var NEXT_SCENE

func _ready():
	$GUI.change_level(1)

func _on_LevelEnd_body_entered(body):
	if (body.name == "Player"):
		assert(get_tree().change_scene(NEXT_SCENE) == OK)
