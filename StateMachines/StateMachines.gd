extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$VBoxContainer/StatesStack/States.text = ""
	var i = 1
	for state in $Player/StateMachine.states_stack:
		$VBoxContainer/StatesStack/States.text += str(i) + ": " + state.name + "\n"
		i += 1
