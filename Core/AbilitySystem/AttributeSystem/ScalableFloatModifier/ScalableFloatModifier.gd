class_name ScalableFloatModifier extends Resource

@export var operator: Util.EOperator
@export var coefficient: float = 1.0
@export var scalable_float_magnitude: float

func _init(_operator: Util.EOperator = Util.EOperator.ADD, _coefficient: float = 1.0, _scalable_float_magnitude: float = 0.0) -> void:
	operator = _operator
	coefficient = _coefficient
	scalable_float_magnitude = _scalable_float_magnitude
