extends Node

var dict_test = {1: "test", 3: "test"}


# Called when the node enters the scene tree for the first time.
func _ready():
	print(dict_test.keys().front() == 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
