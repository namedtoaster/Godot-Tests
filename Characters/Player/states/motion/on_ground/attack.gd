extends "on_ground.gd"

func enter():
	owner.get_node("AnimationPlayer").play("attack")
	
func update(delta):
	# Prevent the player from moving in the attack state
	# Eventually, I might put in the capability to move while attacking similar to the way that I do with the jumping velocity
	# in that I can take in the initial velocity from the move state and apply it
	# Right now, it's just not worth implementing that, so I'm just going to zero out the x velocity
	owner._velocity = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	._on_animation_finished(anim_name)
