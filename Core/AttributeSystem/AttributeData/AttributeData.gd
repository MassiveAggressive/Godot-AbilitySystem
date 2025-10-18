@tool
class_name AttributeData extends Resource

@export var value: float:
	set(_value):
		value = _value
		base_value = value
		current_value = value
var base_value: float
var current_value: float

func _init(value: float = 0.0) -> void:
	base_value = value
	current_value = base_value
