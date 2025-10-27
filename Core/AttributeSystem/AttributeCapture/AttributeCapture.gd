class_name AttributeCapture extends Resource

signal AttributeChanged(name: String, value: float)

var attribute_set: AttributeSetBase
var attribute_name: String

func _init(_attribute_set: AttributeSetBase, _attribute_name: String) -> void:
	attribute_set = _attribute_set
	attribute_name = _attribute_name
	
	attribute_set.AttributeChanged.connect(OnAttributeChanged)

func OnAttributeChanged(attribute_name: String, value: float) -> void:
	AttributeChanged.emit(attribute_name, value)
