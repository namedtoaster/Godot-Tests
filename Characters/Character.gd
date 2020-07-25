class_name Character
extends KinematicBody2D


# Both the Player and Enemy inherit this scene as they have shared behaviours
# such as speed and are affected by gravity.


export var speed = Vector2(0.0, 350.0)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

# _physics_process is called after the inherited _physics_process function.
# This allows the Player and Enemy scenes to be affected by gravity.
func _physics_process(delta):
	# Apply gravity - each state will handle the velocity on its own as necessary
	_velocity.y += gravity * delta
