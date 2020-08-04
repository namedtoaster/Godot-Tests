extends "on_ground.gd"



func enter():
	speed = 0.0
	owner._velocity = Vector2()

	owner.get_node("AnimationPlayer").play("run")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	
	# If the player isn't inputing movement, stop and change to idle state
	if input_direction == Vector2(0,0):
		emit_signal("finished", "idle")

	# Update the x velocity/position
	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	owner._velocity.x = input_direction.x * speed
	
	.update(delta)
#	var collision_info = move(speed, input_direction)
#	if not collision_info:
#		return
#	if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group("environment"):
#		return null

#func move(speed, direction):
#	owner._velocity = direction.normalized() * speed
#	#owner.move_and_slide(velocity, Vector2(), 5, 2)
#	if owner.get_slide_count() == 0:
#		return
#	return owner.get_slide_collision(0)
