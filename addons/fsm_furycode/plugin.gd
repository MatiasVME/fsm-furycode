@tool
extends EditorPlugin

# Called when the plugin is added to the editor
func _enter_tree():
	# Register custom types for StateMachine and State
	add_custom_type(
		"StateMachine",
		"Node",
		load("res://addons/fsm_furycode/state_machine.gd"),
		load("res://addons/fsm_furycode/node_icons/statemachine.png")
	)
	add_custom_type(
		"State",
		"Node",
		load("res://addons/fsm_furycode/state.gd"),
		load("res://addons/fsm_furycode/node_icons/state.png")
	)


# Called when the plugin is removed from the editor
func _exit_tree():
	# Unregister custom types
	remove_custom_type("StateMachine")
	remove_custom_type("State")
