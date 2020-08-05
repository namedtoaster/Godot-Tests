extends Node

# Placeholder var for now
# Eventually, there will be moments in the game when the dialog box gets triggered
# When that happens, the text will change and the box will display
# Until then, just keep it hidden and don't allow it to process anything until it is displayed
onready var intro = ["Welcome to the game",
"Do this, do that",
"Don't do this, don't do that",
"This is how you do this",
"This is how you do that",
"Good luck"]
onready var dialog = intro

# These variables will always be here and will just load whenever the node is loaded
onready var page = 0
onready var text = $Box/MarginContainer/Text
onready var status = false

enum COLOR { RED, BLUE }
export(COLOR) var DIALOG_COLOR

# Functions
func _ready():
	# Set the texture of the dialog based on what the user sets
	# I'm arbitrarily using Red for non-NPC dialog and blue for NPC dialog for now
	if (DIALOG_COLOR == COLOR.RED):
		$Box/DialogBG.texture = load("res://Dialog/assets/dialog_red.png")
	elif (DIALOG_COLOR == COLOR.BLUE):
		$Box/DialogBG.texture = load("res://Dialog/assets/dialog_blue.png")
	
	# Hide dialog box
	self.visible = false
	
	# Don't allow the user to click to the next page until the dialog box starts to fade in
	set_process_input(false)
	
	# Comment this out when testing is done
	# When developing the game, just call this from whatever node to change the dialog text and automatically load the box
	change_dialog_text(intro)

func _input(_event):
	if Input.is_action_just_pressed("click"):
		if text.get_visible_characters() > text.get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				text.set_bbcode(dialog[page])
				text.set_visible_characters(0)
		else:
			text.set_visible_characters(text.get_total_character_count())
			
		if (text.get_visible_characters() > text.get_total_character_count()):
			if (page == dialog.size() - 1):
				set_status(false)

func set_status(value):
	status = value
	
	# If status is set to true, enable the node
	if (status):
		# TODO - might not be the best way to do this, might not. But it works for now
		# Right now, just deactivate the player so he can't move while the dialog is playing
		var player = get_tree().get_current_scene().get_node("Player")
		var state_machine = player.get_node("StateMachine")
		
		# Make sure the player is idling and not running or anything else
		state_machine._change_state("idle")
		# Set the player to inactive so they can't move around
		state_machine.set_active(false)
		
		# Set the text to the beginning of the dialog and hide all characters
		# and set the page back to 0
		text.text = dialog[0]
		text.set_visible_characters(0)
		page = 0
		
		# Start the start delay timer which enables several things
		$Box/Timers/StartDelay.start()
		
	if (!status):
		var player = get_tree().get_current_scene().get_node("Player")
		var state_machine = player.get_node("StateMachine")
		state_machine.initialize(state_machine.START_STATE)
		state_machine._change_state("idle")
		get_tree().get_current_scene().get_node("Player").get_node("StateMachine").set_active(true)
		
		# Fade out - should probably make sure the timer is greater than 1 second so the dialog box doesn't disappear while fading out
		$AnimationPlayer.play("fade_out")
		$Box/Timers/EndDelay.start()
		
		# Make sure all other timers are stopped
		$Box/Timers/StartDelay.stop()
		$Box/Timers/Timer.stop()
		
		# Stop processing input
		self.set_process_input(false)
		

# It's assumed that every time you change the dialog text, you wish to show the dialog
# So after the text is updated, set the status to true
func change_dialog_text(dialog_text):
	dialog = dialog_text
	set_status(true)
	

func _on_Timer_timeout():
	text.set_visible_characters(text.get_visible_characters()+1)

func _on_StartDelay_timeout():
	# TODO
	# If the animation player isn't set to the first key of the fade in animation player in the editor,
	# the dialog box will flash before fading in
	# To prevent that, I just have the animation player set to the first frame on the fade in animation
	# for now. Not ideal, because if I want to do anything visually to the box in the editor, I'll have to
	# change the keyframe then reset it before I play. But it will do for now
	self.visible = true
	
	# Fade dialog in
	$AnimationPlayer.play("fade_in")
	set_process_input(true)
	$Box/Timers/Timer.start()

func _on_EndDelay_timeout():
	self.visible = false
