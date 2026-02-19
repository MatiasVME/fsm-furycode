extends Node

class_name FSM_State

@onready var state_machine := get_parent()

@onready var target = state_machine.target

# Put the string names of the another states
@export var transitions_names: PackedStringArray


func _init():
	await ready
	enable_all_process(false)


func enable_all_process(enabled: bool):
	set_physics_process(enabled)
	set_physics_process_internal(enabled)
	set_process(enabled)
	set_process_input(enabled)
	set_process_internal(enabled)
	set_process_shortcut_input(enabled)
	set_process_unhandled_input(enabled)
	set_process_unhandled_key_input(enabled)
