extends CommandTarget

@onready var test_camera: TestCamera = $"../TestCamera"
@onready var reference_points: ReferencePoints = $"../ReferencePoints"


# Those commands are available only to scenes containing this component
func _register_commands() -> void:
	register_command("cam_speed", _cmd_change_cam_speed, "Changes camera speed multiplier. Args: <camera speed multiplier>")
	register_command("ref_color", _cmd_change_reference_color, "Changes reference sprite color to one specified by RGB 0-255 values. Args: <reference position> <red> <green> <blue>")


func _cmd_change_cam_speed(args: Array[String]) -> void:
	# Extract arguments from input
	var multiplier_new_value: float = float(args[0])

	console_manager.log_debug("Speed change requested")
	test_camera.set_speed_multiplier(multiplier_new_value)

func _cmd_change_reference_color(args: Array[String]) -> void:
	var reference_position: int = int(args[0])
	var color_r: int = int(args[1])
	var color_g: int = int(args[2])
	var color_b: int = int(args[3])

	var result_color: Color = Color.from_rgba8(color_r, color_g, color_b)

	reference_points.change_reference_color(reference_position, result_color)
