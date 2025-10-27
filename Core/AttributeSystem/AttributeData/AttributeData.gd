class_name AttributeData extends Resource

signal BaseValueChanged(value: float)
signal CurrentValueChanged(value: float)

var base_value: float
var current_value: float

func _init(value: float = 0.0) -> void:
	base_value = value
	current_value = base_value

func SetBaseValue(value: float) -> void:
	base_value = value
	BaseValueChanged.emit(value)

func SetCurrentValue(value: float) -> void:
	current_value = value
	CurrentValueChanged.emit(value)
