extends Camera2D
class_name TestCamera

var speed_multiplier: float = 1

func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "global_position", Vector2(0, 0), 3 * speed_multiplier)
	tween.tween_property(self, "global_position", Vector2(500, 400), 2 * speed_multiplier)
	tween.tween_property(self, "global_position", Vector2(808, -144), 1 * speed_multiplier)


func set_speed_multiplier(value: float):
	if value < -10 or value > 10:
		console_manager.log_warning("Wrong multplier value " + str(value))
		return

	speed_multiplier = value
