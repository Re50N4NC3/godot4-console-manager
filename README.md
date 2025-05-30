# godot4-console-manager
Self contained console manager with custom commands and UI.

Allows developers to easily register and execute functions via text commands directly within the running game. Supports commands with simple arguments and provides various logging levels with customizable colors.

## Features
- In-game console UI (`LineEdit` for input, `RichTextLabel` for output).
- Register custom commands from anywhere in your project.
- Global `ConsoleManager` singleton for easy access.
- `CommandTarget` component script for straightforward command registration on specific nodes.
- Basic argument parsing (space-separated).
- Command history navigation (Up/Down arrows).
- Customizable log message colors.
- Configurable console toggle key (default `\``).
- Optionally mirrors console output to the Godot editor Output panel.

## Set up
1.  Copy the `Console` directory (containing `Console.tscn`, `console.gd`, `console_manager.gd`, and `command_target.gd`) anywhere into your Godot project's filesystem (e.g., `res://addons/console/`).
2.  Go to `Project -> Project Settings -> Globals -> AutoLoad`.
3.  Click the folder icon next to "Path" and select the `console_manager.gd` script.
4.  Enter `console_manager` in the "Node Name" field. Click "Add".
5.  Add the `Console.tscn` scene as an instance to your main game scene, or another persistent scene (like a UI manager or attached to your main camera).

Shown UI is just an example, scripts and core functionality is be separated enough to use them on their own with custom made UI setup.

Check out `Examples` folder for use cases and code examlpes. You can also remove it as nothing is dependent on it.

## ConsoleUi Visual settings
Here is the list of useful visual properties and how to set them.

### PanelContainer, sizing and scaling
`PanelContainer` has minimum sizing, you can change it if needed or resize the panel manually.
This panel also can be changed to something more fitting like grid container or set its mode to `Fill Horizontal`.

### Console Input (LineEdit) Settings
- Select the `ConsoleInput` node (which has the `Console.gd` script attached).
- In the Inspector, under the "Console settings" category:
	- Adjust `Command History Limit`.
	- Toggle `Print To Godot Output Terminal`.
	- Change the `Console Key` used to toggle visibility.
	- Set `Initially Visible` state.
- Under the "Text colors" group:
	- Customize the colors for different log types (`Text Color Message`, `Text Color Command`, `Text Color Warning`, etc.).

### Anchor Position
To change position use `Anchors Preset` property inside `PanelContainer`.

### Content fitting (input box movement on command execution)
When changing anchor position to top there are two options to keep input box in place:
	1. Disable content fitting inside `ConsoleLog`, `Fit Content = false`, it will cause logs to always stay the same size.
	1. Move `ConsoleInput` in hierarchy tree above the `ConsoleLog`, it will cause logs to expand downwards and will put console input at the top.

## Usage
### Opening/Closing the Console
- Press the key defined in the `Console Key` property on the `ConsoleInput` node (default `~`).

### Executing Commands
- Type a command and its arguments (space separated) into the input field.
- Press Enter to execute.

### Command History
Access command history with Up and Down Arrow Keys.

### Built-in Commands
- `help`: Lists all registered commands and their descriptions.
- `help <command_name>`: Shows the description for a specific command.
- `clear`: Clears the console log display.
- `echo <text>`: Prints the provided text back to the console.
- `history`: Displays the list of previously executed commands.

## Registering Custom Commands
You can add your own commands in two main ways:

**1. Using `command_target` Component:**
- Attach the `command_target.gd` script to any Node in your scene.
- Create a new script that extends the node's original script or `CommandTarget` itself. Override the `_register_commands` virtual function.
- Use the `register_command` helper within `_register_commands`.

```gdscript
# In your node's script (e.g., Player.gd) that also has CommandTarget.gd attached or extends a script that does.
# Assuming command_target.gd is also attached to this node via the editor
extends CharacterBody3D

func _ready():
	# Your other code, for example references to other nodes that contain functions that you want to test.
	_register_commands() # Call the registration method

# This method is automatically called by CommandTarget if it exists
func _register_commands() -> void:
	# The callback function MUST EXIST IN THIS script instance.
	# Remember that registering uses callable and not function reference, so you don't have to put `()` after the function name.
	register_command("player_pos", _cmd_get_position, "Prints the player's current position.")
	register_command("heal", _cmd_heal_player, "Heals the player. Usage: heal <amount>")

func _cmd_get_position(args: Array[String]) -> void:
	# Callbacks might take 0 or N args. This example doesn't take any as it uses built in global_position.
	# It always receives args that will be strings.
	# You have to cast each positional argument to a desired type.
	ConsoleManager.log_message("Player Position: " + str(global_position))

func _cmd_heal_player(args: Array[String]) -> void:
	if args.size() != 1:
		ConsoleManager.log_warning("Not enough arguments to call heal on plater")
		return
	var amount = args[0].to_int()
	# Healing logic here, could be a reference to other node function.
	ConsoleManager.log_success("Healed player by " + str(amount))
