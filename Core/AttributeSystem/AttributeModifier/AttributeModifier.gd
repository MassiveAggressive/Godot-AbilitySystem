class_name AttributeModifier extends Resource

@export var operator: Util.EOperator
@export var magnitude: float
@export var coefficient: float = 1.0

func _init(_operator: Util.EOperator = Util.EOperator.ADD, _magnitude: float = 0.0, _coefficient: float = 1.0) -> void:
	operator = _operator
	magnitude = _magnitude
	coefficient = _coefficient
