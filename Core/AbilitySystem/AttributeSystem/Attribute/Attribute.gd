class_name Attribute extends RefCounted

var attribute_set: AttributeSet
var attribute_name: String
var attribute_data: AttributeData

func _init(_attribute_set: AttributeSet, _attribute_name: String, _attribute_data: AttributeData) -> void:
	attribute_set = _attribute_set
	attribute_name = _attribute_name
	attribute_data = _attribute_data
