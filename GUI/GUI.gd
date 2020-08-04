extends CanvasLayer


func change_level(level):
	$TopLabels/HBoxContainer/Level.text = "Level: " + str(level)
