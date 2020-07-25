extends Node2D

var frame = 0
var recording_num = 0
var input_data = {}
var writing = true
var reading = false
var beginning_pos = Vector2()
onready var action = InputEventAction.new()

enum Press_State {PRESSED, RELEASED}
enum Record_State {RECORDING, NOT_RECORDING}
enum Play_State {PLAYING, NOT_PLAYING}

var record_stack = []
onready var record_state = Record_State.NOT_RECORDING
onready var play_state = Play_State.NOT_PLAYING

class RecordData:
	var start_frame = 0
	
	var current_press_state = {"left" : Press_State.RELEASED, 
	"right" : Press_State.RELEASED,
	"jump" : Press_State.RELEASED,
	"attack" : Press_State.RELEASED}
	
	# input_data will store values for any input actions
	# If an action has changed, the frame it occured on will be stored
	# along with the state of that action
	var input_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	beginning_pos = $Player.global_position
	$GUI/DebugInfo/ReadOrRecord.text = "Recording"
	
func begin_recording(frame):
	var new_recording = RecordData.new()
	new_recording.start_frame = frame
	
	record_stack.push_front(new_recording)
	# For each recording, save the frame at which you started recording
	# Since you have to press a button to start recording, this frame will always be greater than zero
	# When it comes time to replay the events, just subtract "start_frame" from the frame each input was recorded
	# That way, when you start replaying, it will start playing right when you started recording
		
func record(frame):
	# How to save inputs:
	# Moving
	#	Each frame, record the current state
	#
	#	Record if the action is being pressed (T/F) and the current frame you are on
	#
	#	When playing back (separate function), check if the first value in the dict has a value for the current frame
	#	If not, break. If so:
	#		If the state is pressed, press down
	#		If the state is not pressed, release for that button (left or right)
	if record_stack[0].current_press_state["left"] == Press_State.RELEASED and Input.is_action_pressed("left"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["left"] = Press_State.PRESSED
		# Update the current state for this action
		record_stack[0].current_press_state["left"] = Press_State.PRESSED
	elif record_stack[0].current_press_state["left"] == Press_State.PRESSED and !Input.is_action_pressed("left"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["left"] = Press_State.RELEASED
		# Update the current state for this action
		record_stack[0].current_press_state["left"] = Press_State.RELEASED
		
	if record_stack[0].current_press_state["right"] == Press_State.RELEASED and Input.is_action_pressed("right"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["right"] = Press_State.PRESSED
		# Update the current state for this action
		record_stack[0].current_press_state["right"] = Press_State.PRESSED
	elif record_stack[0].current_press_state["right"] == Press_State.PRESSED and !Input.is_action_pressed("right"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["right"] = Press_State.RELEASED
		# Update the current state for this action
		record_stack[0].current_press_state["right"] = Press_State.RELEASED
		
	if record_stack[0].current_press_state["jump"] == Press_State.RELEASED and Input.is_action_just_pressed("jump"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["jump"] = Press_State.PRESSED
		# Update the current state for this action
		record_stack[0].current_press_state["jump"] = Press_State.PRESSED
	elif record_stack[0].current_press_state["jump"] == Press_State.PRESSED and !Input.is_action_just_pressed("jump"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["jump"] = Press_State.RELEASED
		# Update the current state for this action
		record_stack[0].current_press_state["jump"] = Press_State.RELEASED
		
	if record_stack[0].current_press_state["attack"] == Press_State.RELEASED and Input.is_action_just_pressed("attack"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["attack"] = Press_State.PRESSED
		# Update the current state for this action
		record_stack[0].current_press_state["attack"] = Press_State.PRESSED
	elif record_stack[0].current_press_state["attack"] == Press_State.PRESSED and !Input.is_action_just_pressed("attack"):
		# Add the state to the recording
		# First, assign a dict to that key
		record_stack[0].input_data[frame] = {}
		record_stack[0].input_data[frame]["attack"] = Press_State.RELEASED
		# Update the current state for this action
		record_stack[0].current_press_state["attack"] = Press_State.RELEASED
	
func end_recording():
	recording_num += 1
	frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if record_state == Record_State.RECORDING:
		record(frame)
	if play_state == Play_State.PLAYING:
		if frame in record_stack[0].input_data.keys():
			if "left" in record_stack[0].input_data[frame].keys():
				action.action = "left"
				if record_stack[0].input_data[frame]["left"] == Press_State.PRESSED:
					action.pressed = true
				else:
					action.pressed = false
				Input.parse_input_event(action)
			
			if "right" in record_stack[0].input_data[frame].keys():
				action.action = "right"
				if record_stack[0].input_data[frame]["right"] == Press_State.PRESSED:
					action.pressed = true
				else:
					action.pressed = false
				Input.parse_input_event(action)
				
			if "jump" in record_stack[0].input_data[frame].keys():
				action.action = "jump"
				if record_stack[0].input_data[frame]["jump"] == Press_State.PRESSED:
					action.pressed = true
				else:
					action.pressed = false
				Input.parse_input_event(action)
				# Immediately release the button after pressing it once
				action.pressed = false
				Input.parse_input_event(action)
				
			if "attack" in record_stack[0].input_data[frame].keys():
				action.action = "attack"
				if record_stack[0].input_data[frame]["attack"] == Press_State.PRESSED:
					action.pressed = true
				else:
					action.pressed = false
				Input.parse_input_event(action)
				# Immediately release the button after pressing it once
				action.pressed = false
				Input.parse_input_event(action)
				
		if frame > record_stack[0].input_data.keys().back():
			_on_Play_pressed()
			
	frame += 1
	update_states_GUI()
	update_frame_GUI()
	
func _input(event):
	$Player/StateMachine._input(event)
	
func update_frame_GUI():
	$GUI/DebugInfo/FrameInfo/Value.text = str(frame)

func update_states_GUI():
	$GUI/DebugInfo/StatesStack/States.text = ""
	
	var i = 1
	for state in $Player/StateMachine.states_stack:
		$GUI/DebugInfo/StatesStack/States.text += str(i) + ": " + state.name + "\n"
		i += 1


func _on_Timer_timeout():
	pass
		
	
func _on_Button_pressed():
	# Prevent being able to click buttton with spacebar
	$GUI/ReplayTools/Record.release_focus()
	
	if record_state == Record_State.NOT_RECORDING:
		# Change the state to recording
		record_state = Record_State.RECORDING
		
		# Bring the player back to the beginning
		$Player.global_position = beginning_pos
		
		# Change the button text
		$GUI/ReplayTools/Record.text = "Click Here To Stop Recording"
		
		# Show the recording icon
		$GUI/ReplayTools/RecordingIcon.visible = true
		# Play the recording icon animation
		$GUI/ReplayTools/RecordingAnimation.play("recording")
		
		# Hide the play button
		$GUI/ReplayTools/Play.visible = false
		
		# Create a record data
		begin_recording(frame)
	elif record_state == Record_State.RECORDING:
		record_state = Record_State.NOT_RECORDING
		
		# End the recording
		end_recording()
		
		# Change the button text
		$GUI/ReplayTools/Record.text = "Click Here To Record Movements"
		
		# Hide the recording icon
		$GUI/ReplayTools/RecordingIcon.visible = false
		# Stop the recording icon animation
		$GUI/ReplayTools/RecordingAnimation.stop()
		
		# Show the play button
		$GUI/ReplayTools/Play.visible = true


func _on_Play_pressed():
	# Prevent being able to click buttton with spacebar
	$GUI/ReplayTools/Play.release_focus()
	
	if play_state == Play_State.NOT_PLAYING:
		# Hide the record button so you can't record during playback
		$GUI/ReplayTools/Record.visible = false
		
		play_state = Play_State.PLAYING
		frame = 0
		
		# Reset the player's position
		$Player.global_position = beginning_pos
		
		$GUI/ReplayTools/Play.text = "Stop Playing"
	elif play_state == Play_State.PLAYING:
		play_state = Play_State.NOT_PLAYING
		
		# Stop any action from being pressed
		action.pressed = false
		Input.parse_input_event(action)
		
		# Show the record button
		$GUI/ReplayTools/Record.visible = true
		
		$GUI/ReplayTools/Play.visible = true
		$GUI/ReplayTools/Play.text = "Play"
