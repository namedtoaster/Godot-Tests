extends "../motion.gd"

func handle_input(event):
	if event.is_action_pressed("jump") and self.name != "Attack":
		emit_signal("finished", "jump")
	if event.is_action_pressed("attack"):
		emit_signal("finished", "attack")
	
	return .handle_input(event)
	
func update(delta):		
	.update(delta)
	
func _on_animation_finished(anim_name):
	._on_animation_finished(anim_name)
