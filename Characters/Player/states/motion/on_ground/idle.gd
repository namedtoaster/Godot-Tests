extends "on_ground.gd"

func enter():
	owner.get_node("AnimationPlayer").play("idle")

func handle_input(event):
	return .handle_input(event)
	
func update(delta):
	var input_direction = get_input_direction()
	
	# If the player is trying to move, exit the state and start the move state
	if input_direction:
		emit_signal("finished", "move")
		
	.update(delta)
