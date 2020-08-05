extends CanvasLayer


func change_level(level):
	$TopLabels/HBoxContainer/Level.text = "Level: " + str(level)
	
func _input(event):
	if event.is_action_pressed("left"):
		$BottomMenu/VBoxContainer2/Keys/LeftRight/Left.modulate = Color(1, 1, 1, 1)
	else:
		$BottomMenu/VBoxContainer2/Keys/LeftRight/Left.modulate = Color(1, 1, 1, 0)
		
	if event.is_action_pressed("right"):
		$BottomMenu/VBoxContainer2/Keys/LeftRight/Right.modulate = Color(1, 1, 1, 1)
	else:
		$BottomMenu/VBoxContainer2/Keys/LeftRight/Right.modulate = Color(1, 1, 1, 0)
		
	if event.is_action_pressed("jump"):
		$BottomMenu/VBoxContainer2/Keys/Spacebar.modulate = Color(1, 1, 1, 1)
	else:
		$BottomMenu/VBoxContainer2/Keys/Spacebar.modulate = Color(1, 1, 1, 0)
