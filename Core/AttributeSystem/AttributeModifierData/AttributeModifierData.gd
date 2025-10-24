@tool
class_name AttributeModifierData extends Resource

@export var attribute: String:
	set(value):
		attribute = value
@export var modifier: AttributeModifier

func _init(_attribute: String = "", _modifier: AttributeModifier = null) -> void:
	pass

func _validate_property(property: Dictionary) -> void:
	if property["name"] == "attribute":
		var attribute_strings: Array[String]
		
		for attribute_set_name: String in AttributePicker.editor_attributes:
			for attribute_name in AttributePicker.editor_attributes[attribute_set_name]:
				attribute_strings.append(attribute_set_name + "." + attribute_name)
		
		property["type"] = TYPE_STRING
		property["usage"] = PROPERTY_USAGE_DEFAULT
		property["hint"] = PROPERTY_HINT_ENUM
		property["hint_string"] = ",".join(attribute_strings)
