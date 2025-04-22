extends Node
class_name CommandTarget

var console: Console = null

func _ready() -> void:
	_find_console()
	_register_commands()

# Find the console in the scene
func _find_console() -> void:
	if Engine.has_singleton("ConsoleManager"):
		var manager = Engine.get_singleton("ConsoleManager")
		if manager and manager.has_method("get_console"):
			console = manager.get_console()
			return
	else:
		push_error("Please set up `console_manager` autoload script")

# Virtual method to be overridden by extending classes
func _register_commands() -> void:
	pass

# Helper method to register a command
func register_command(registered_name: String, callback: Callable, description: String = "") -> void:
	if not console: return
	console.register_command(registered_name, callback, description)
