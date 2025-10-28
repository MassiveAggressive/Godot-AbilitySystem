class_name AttributeBasedModifier extends Resource

@export var operator: Util.EOperator
@export var coefficient: float = 1.0
@export var attribute_capture: AttributeCapture

func _init(_operator: Util.EOperator = Util.EOperator.ADD, _coefficient: float = 1.0, _attribute_capture: AttributeCapture = null) -> void:
	operator = _operator
	coefficient = _coefficient
	attribute_capture = _attribute_capture
