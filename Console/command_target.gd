extends Node
class_name CommandTarget


func _ready() -> void:
	_register_commands()

# Virtual method to be overridden by extending classes
func _register_commands() -> void:
	pass

# Helper method to register a command
func register_command(registered_name: String, callback: Callable, description: String = "") -> void:
	console_manager.register_command(registered_name, callback, description)
