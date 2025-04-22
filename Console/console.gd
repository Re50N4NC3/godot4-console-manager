extends LineEdit
class_name Console

signal command_executed(command: String, args: Array[String])

# History
var command_history: Array[String] = []
var history_index: int = -1
var current_input: String = ""
@export var log_display: RichTextLabel

# Dictionary to store registered commands
var commands: Dictionary = {}

# Settings
@export_category("Console settings")
@export_range(2, 100, 1) var command_history_limit: int = 40
@export var print_to_godot_output_terminal: bool = true

@export_group("Text colors")
@export var text_color_message: Color = Color.WHITE
@export var text_color_command: Color = Color.YELLOW
@export var text_color_warning: Color = Color.YELLOW
@export var text_color_error: Color = Color.RED
@export var text_color_success: Color = Color.GREEN
@export var text_color_debug: Color = Color.LIGHT_SKY_BLUE

func _ready() -> void:
	text_submitted.connect(_on_text_submitted)
	keep_editing_on_text_submit = true  # Required for 4.4

	# Built-in commands
	register_command("help", _cmd_help, "Shows all available commands")
	register_command("clear", _cmd_clear, "Clears the console log")
	register_command("echo", _cmd_echo, "Echoes the provided text")
	register_command("history", _cmd_history, "Shows command history")

# Registers a new command
func register_command(registered_name: String, callback: Callable, description: String = "") -> void:
	commands[registered_name] = {
		"callback": callback,
		"description": description
	}

# Execute a command string
func execute_command(command_str: String) -> void:
	log_command("> " + command_str)
	_add_to_history(command_str)

	# Parse the command and arguments
	var parts: PackedStringArray = command_str.split(" ", false)
	if parts.size() == 0:
		return

	var command_name: String = parts[0].to_lower()
	var args: Array[String] = []

	for i in range(1, parts.size()):
		args.append(parts[i])

	if commands.has(command_name):
		# Execute the command callback
		var callback: Callable = commands[command_name]["callback"]
		if callback.get_argument_count() == 0:
			callback.call()
		else:
			callback.call(args)

		command_executed.emit(command_name, args)
	else:
		log_error("Unknown command: '" + command_name + "'")

# Add a message to console logs
func log_message(message: String, color: Color = text_color_message) -> void:
	if print_to_godot_output_terminal: print(message)
	log_display.append_text("[color=#%s]%s[/color]\n" % [color.to_html(false), message])

# Log a command
func log_command(command: String) -> void:
	log_message(command, text_color_command)

# Log a warning
func log_warning(warning: String) -> void:
	log_message("Warning: " + warning, text_color_warning)

# Log an error
func log_error(error: String) -> void:
	log_message("Error: " + error, text_color_error)

# Log a success message
func log_success(message: String) -> void:
	log_message(message, text_color_success)

# Log a debug message
func log_debug(message: String) -> void:
	log_message(message, text_color_debug)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_QUOTELEFT:
			visible = !visible
			if visible:
				grab_focus()
			text = ""

		# Command history navigation
		if visible:
			if event.keycode == KEY_UP:
				_navigate_history(1)
				get_viewport().set_input_as_handled()
			elif event.keycode == KEY_DOWN:
				_navigate_history(-1)
				get_viewport().set_input_as_handled()

func _on_text_submitted(new_text: String) -> void:
	var input: String = new_text.strip_edges()
	if input.length() > 0:
		execute_command(input)
	text = ""
	history_index = -1
	grab_focus()

# Add a command to history
func _add_to_history(command: String) -> void:
	# Don't add duplicate consecutive commands
	if command_history.size() > 0 and command_history.back() == command: return
	command_history.append(command)

	# Trim history if it gets too long
	if command_history.size() > command_history_limit:
		command_history.pop_front()

# Navigate command history
func _navigate_history(direction: int) -> void:
	if command_history.size() == 0:
		return

	# Store current input if we're just starting to navigate
	if history_index == -1:
		current_input = text
	history_index = clamp(history_index + direction, -1, command_history.size() - 1)

	if history_index == -1:
		# Restore the current input if we navigate past the start
		text = current_input
	else:
		# Set text to the historical command
		text = command_history[command_history.size() - 1 - history_index]

	caret_column = text.length()

# -----------------------------
# ------ Built-in Commands ----
#------------------------------
# Help
func _cmd_help(args: Array[String]) -> void:
	if args.size() > 0:
		var command_name = args[0].to_lower()
		if commands.has(command_name):
			var description = commands[command_name]["description"]
			log_message("Command: ", command_name)
			log_message("Description: ", description)
		else:
			log_error("No help available for unknown command: '" + command_name + "'")
	else:
		# Show all commands
		log_message("Available commands:")
		var command_names = commands.keys()
		command_names.sort()

		for cmd in command_names:
			var description = commands[cmd]["description"]
			log_message("  " + cmd + " - "+ description)

func _cmd_clear() -> void:
	if log_display:
		log_display.clear()
	log_success("Console cleared")

func _cmd_echo(args: Array[String]) -> void:
	var message = " ".join(args)
	log_message(message)

func _cmd_history() -> void:
	if command_history.size() == 0:
		log_message("No command history")
		return

	log_message("Command history:")
	for i in range(command_history.size()):
		log_message("  "+ str(i+1) +". " + command_history[i])
