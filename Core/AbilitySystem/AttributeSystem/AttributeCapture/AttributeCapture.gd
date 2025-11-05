class_name AttributeCapture extends Resource

signal AttributeChanged()

var attribute_set: AttributeSetBase
var attribute_name: String
var attribute_data: AttributeData

func _init(_attribute_set: AttributeSetBase, _attribute_name: String) -> void:
	attribute_set = _attribute_set
	attribute_name = _attribute_name
	
	attribute_data = attribute_set.GetAttribute(attribute_name)
	
	attribute_set.AttributeChanged.connect(OnAttributeChanged)

func OnAttributeChanged(_attribute_name: String, value: float) -> void:
	if _attribute_name == attribute_name:
		AttributeChanged.emit()
