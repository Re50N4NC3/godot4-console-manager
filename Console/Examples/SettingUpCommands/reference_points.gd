extends Node2D
class_name ReferencePoints

@export var references: Array[Sprite2D]


func change_reference_color(reference_number: int, reference_color: Color):
	if reference_number > references.size() - 1 or reference_number < 0:
		console_manager.log_warning("Reference number `" + str(reference_number) + " out of reference range")
		return
	references[reference_number].modulate = reference_color
