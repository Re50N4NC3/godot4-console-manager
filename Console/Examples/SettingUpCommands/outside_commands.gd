extends CommandTarget

@onready var test_camera: TestCamera = $"../TestCamera"

# Those commands are available only to scenes containing this component
func _register_commands() -> void:
	register_command("cam_speed", _cmd_change_cam_speed, "Changes camera speed multiplier. Args: <camera speed multiplier>")


func _cmd_change_cam_speed(args: Array[String]) -> void:
	# Extract arguments from input
	var multiplier_new_value: float = float(args[0])
	console_manager.log_debug("Speed change requested")
	test_camera.set_speed_multiplier(multiplier_new_value)
