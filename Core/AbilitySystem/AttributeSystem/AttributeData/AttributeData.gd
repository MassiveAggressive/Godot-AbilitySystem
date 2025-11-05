@tool
class_name AttributeData extends Resource

@export var value: float:
	set(_value):
		value = _value
		base_value = value
		current_value = value
var base_value: float
var current_value: float

func _init(_value: float = 0.0) -> void:
	value = _value
	base_value = value
	current_value = base_value
