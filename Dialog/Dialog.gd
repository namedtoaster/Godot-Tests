extends Node

onready var intro = ["Welcome to the game",
"Do this, do that",
"Don't do this, don't do that",
"This is how you do this",
"This is how you do that",
"Good luck"]
onready var dialog = intro
onready var page = 0
onready var text = $Box/MarginContainer/Text

# Functions
func _ready():
	text.text = dialog[0]
	text.set_visible_characters(0)
	
	# Hide dialog box
	self.visible = false
	
	# Don't allow the user to click to the next page until the dialog box is visible
	# It will become visible after the delay timer expires
	set_process_input(false)

func _input(event):
	if Input.is_action_just_pressed("click"):
		if text.get_visible_characters() > text.get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				text.set_bbcode(dialog[page])
				text.set_visible_characters(0)
		else:
			text.set_visible_characters(text.get_total_character_count())

func _on_Timer_timeout():
	text.set_visible_characters(text.get_visible_characters()+1)


func _on_StartDelay_timeout():
	self.visible = true
	set_process_input(true)
	$Box/Timers/Timer.start()
