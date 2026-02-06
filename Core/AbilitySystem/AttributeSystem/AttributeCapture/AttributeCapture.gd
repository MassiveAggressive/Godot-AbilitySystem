class_name AttributeCapture extends Resource

var attribute_set: AttributeSet
var attribute_name: String
var attribute_data: AttributeData

func _init(_attribute_set: AttributeSet, _attribute_name: String) -> void:
	attribute_set = _attribute_set
	attribute_name = _attribute_name
	
	attribute_data = attribute_set.GetAttribute(attribute_name)
