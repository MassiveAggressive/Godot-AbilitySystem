class_name CalculatedAttributeModifier extends RefCounted

var operator: Util.EOperator
var magnitude: float = 0.0

func _init(_operator: Util.EOperator = Util.EOperator.ADD, _magnitude: float = 1.0) -> void:
	operator = _operator
	magnitude = _magnitude
