extends Node
class_name CommandTarget

var console: Console = null

func _ready() -> void:
	console = console_manager.get_console()
	_register_commands()

# Virtual method to be overridden by extending classes
func _register_commands() -> void:
	pass

# Helper method to register a command
func register_command(registered_name: String, callback: Callable, description: String = "") -> void:
	if not console: return
	console.register_command(registered_name, callback, description)
