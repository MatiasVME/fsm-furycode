class_name FSM_StateMachine
extends Node

@onready @export var target: Node2D

@export var initial_state: String

@export var debug: bool = false

# Signals
signal state_entered(next_state: Node)
signal state_exited(current_state: Node)

@onready var current_state: FSM_State


func _ready():
	current_state = get_state_by_name(initial_state)
	if current_state:
		current_state.enable_all_process(true)
	else:
		if debug:
			print_debug("Initial state %s not found " % initial_state)


# Transition to a state by name
func transition_with_name(next_state: String):
	transition_with_state(get_state_by_name(next_state))


# Transition to a state by instance
func transition_with_state(next_state: FSM_State):
	if debug:
		print("---- BEGIN transition_with_state ----")
		print("Current State: ", current_state.name)
		print("Next State: ", next_state.name)
		print("---- END transition_with_state ----")

	# Check if the current state can transition to the next state
	if not current_state.transitions_names.has(next_state.name):
		if debug:
			push_error("%s does not belong to the transitions " % next_state.name)
		return

	self.state_exited.emit(current_state)
	current_state.enable_all_process(false)

	current_state = next_state

	current_state.enable_all_process(true)
	self.state_entered.emit(next_state)


# Get a state by it's name
func get_state_by_name(_name: String) -> FSM_State:
	for state in get_children():
		if state.name == _name:
			return state

	if debug:
		print_debug("State %s not found " % _name)
	return null
