@tool
class_name EffectModifierData extends Resource

var attribute: String
var operator: Util.EOperator

var magnitude: EffectModifierMagnitude

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	var attribute_strings: Array[String]
	
	for attribute_set_name: String in AttributePicker.editor_attributes:
		for attribute_name in AttributePicker.editor_attributes[attribute_set_name]:
			attribute_strings.append(attribute_set_name + "." + attribute_name)
	
	properties.append(
		{
			"name": "attribute",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(attribute_strings)
		}
	)
	
	var operator_array: Array[String]
	
	for key in Util.EOperator.keys():
		key = key as String
		operator_array.append(key.to_lower().replace("_", " ").capitalize())
	
	properties.append(
		{
			"name": "operator",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(operator_array)
		}
	)
	
	properties.append(
		{
			"name": "Magnitude",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_GROUP
		}
	)
	
	properties.append(
		{
			"name": "magnitude",
			"type": TYPE_OBJECT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": "EffectModifierMagnitude"
		}
	)
	
	return properties
