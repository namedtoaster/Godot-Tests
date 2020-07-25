extends "../motion.gd"

export(float) var BASE_MAX_HORIZONTAL_SPEED = 400.0

export(float) var AIR_ACCELERATION = 1000.0
export(float) var AIR_DECCELERATION = 2000.0
export(float) var AIR_STEERING_POWER = 50.0

var enter_velocity = Vector2()

var max_horizontal_speed = 400.0
var horizontal_speed = 0.0
var horizontal_velocity = Vector2()

var vertical_speed = 0.0

func initialize(speed, velocity):
	horizontal_speed = speed
	max_horizontal_speed = speed if speed > 0.0 else BASE_MAX_HORIZONTAL_SPEED
	enter_velocity = velocity

func enter():
	# Only checking the direction here to get the horizontal movement working
	# motion.gd will update the look direction for the sprite for all states that inherit from it
	var input_direction = get_input_direction()

	# Calculate what the horizontal velocity is
	# If the player isn't moving left or right, there won't be any horizontal movement
	horizontal_velocity = enter_velocity if input_direction else Vector2()
	vertical_speed = 900.0
	
	# Change tha animation
	owner.get_node("AnimationPlayer").play("jump")
	
	# This line will just apply the jump velocity
	# The heirarchal state machine template has a separate function for this
	# However, the template is using a top down playing style so it has to do some extra things
	# Since we are moving the entire player, we can just change it's velocity here
	owner._velocity.y -= vertical_speed

func update(delta):
	# Once again, just find if there is any input left or right
	# motion.gd will still update the sprite's look direction
	# We're only interested here if the player is trying to move in either direction
	var input_direction = get_input_direction()
	
	# Self explanatory
	move_horizontally(delta, input_direction)
	
	# If falling, change animation
	# If you are playing the falling animation, don't switch back
	if (owner._velocity.y > 0.0 and owner.get_node("AnimationPlayer").current_animation != "falling"):
		owner.get_node("AnimationPlayer").play("fall")
	
	# Call the parent update function
	# This will apply the gravity so we don't have to do it here
	# We're only concerned about moving horizontally and updating the animation once we enter this state
	.update(delta)
	
	if (owner.is_on_floor()):
		# If you hit the floor, return back to previous
		emit_signal("finished", "previous")
			
	if (owner.is_on_ceiling()):
		# If you hit the ceiling while jumping, immediately change the animation to falling (skip the flip animation)
		owner.get_node("AnimationPlayer").play("falling")

func move_horizontally(delta, direction):
	if direction:
		horizontal_speed += AIR_ACCELERATION * delta
	else:
		horizontal_speed -= AIR_DECCELERATION * delta
	horizontal_speed = clamp(horizontal_speed, 0, max_horizontal_speed)

	var target_velocity = horizontal_speed * direction.normalized()
	var steering_velocity = (target_velocity - horizontal_velocity).normalized() * AIR_STEERING_POWER
	horizontal_velocity += steering_velocity
	
	# Finally, after we get the horizontal velocity, we can actually update it for the parent
	owner._velocity.x = horizontal_velocity.x


func _on_AnimationPlayer_animation_finished(anim_name):
	# Once the jump animation finishes, we want to transition to another animation until the jump state is complete
	# The parent function will handle this logic
	._on_animation_finished(anim_name)
