extends Node
class_name ConsoleManager

# References the main console input instance
var _console: Console = null

# Set the console reference
func set_console(console: Console) -> void:
	_console = console

# Get the console reference
func get_console() -> Console:
	return _console

# Forward command registration to the console
func register_command(registered_name: String, callback: Callable, description: String = "") -> void:
	if not _console: return
	_console.register_command(registered_name, callback, description)

# Log a message to the console
func log_message(message: String, color: Color = Color.WHITE) -> void:
	if not _console: return
	_console.log_message(message, color)

# Log a warning to the console
func log_warning(warning: String) -> void:
	if not _console: return
	_console.log_warning(warning)

# Log an error to the console
func log_error(error: String) -> void:
	if not _console: return
	_console.log_error(error)

# Log a success message to the console
func log_success(message: String) -> void:
	if not _console: return
	_console.log_success(message)

# Log debug messages
func log_debug(message: String) -> void:
	if not _console: return
	_console.log_debug(message)
