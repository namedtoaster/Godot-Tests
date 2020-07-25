extends Timer

func _ready():
	pass # Replace with function body.

func _process(delta):
	$"../Time".text = str(wait_time - time_left)
