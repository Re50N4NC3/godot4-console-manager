extends Control
class_name ConsoleUi

@export var console_log: RichTextLabel
@export var console_input: Console

func _ready() -> void:
	console_input.log_display = console_log
	console_input.command_executed.connect(_on_command_executed)

func _on_command_executed(_command: String, _args: Array[String]) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_released():
		if event.keycode == KEY_QUOTELEFT:
			visible = !visible
			if visible:
				console_input.edit()
