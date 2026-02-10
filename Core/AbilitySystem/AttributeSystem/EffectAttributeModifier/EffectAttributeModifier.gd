@tool
class_name EffectAttributeModifier extends Resource

var attribute: String:
	set(value):
		attribute = value
var operator: Util.EOperator
var magnitude_type: Util.EMagnitudeType:
	set(value):
		magnitude_type = value
		notify_property_list_changed()

var scalable_float_magnitude: float
var coefficient: float = 1.0

var source_attribute: String
var source_attribute_source: Util.EAttributeSource
var source_attribute_coefficient: float = 1.0

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
			"name": "Modifier Magnitude",
			"type": TYPE_NIL,
			"usage": PROPERTY_USAGE_CATEGORY
		}
	)
	properties.append(
		{
			"name": "coefficient",
			"type": TYPE_FLOAT,
			"usage": PROPERTY_USAGE_DEFAULT
		}
	)
	
	var magnitude_type_array: Array[String]
	
	for key in Util.EMagnitudeType.keys():
		key = key as String
		magnitude_type_array.append(key.to_lower().replace("_", " ").capitalize())
	properties.append(
		{
			"name": "magnitude_type",
			"type": TYPE_INT,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(magnitude_type_array)
		}
	)
	match magnitude_type:
		Util.EMagnitudeType.SCALABLE_FLOAT:
			properties.append(
				{
					"name": "Scalable Float Magnitude",
					"type": TYPE_NIL,
					"usage": PROPERTY_USAGE_SUBGROUP
				}
			)
			properties.append(
				{
					"name": "scalable_float_magnitude",
					"type": TYPE_FLOAT,
					"usage": PROPERTY_USAGE_DEFAULT,
				}
			)
		Util.EMagnitudeType.ATTRIBUTE_BASED:
			properties.append(
				{
					"name": "Attribute Based Magnitude",
					"type": TYPE_NIL,
					"usage": PROPERTY_USAGE_SUBGROUP
				}
			)
			properties.append(
				{
					"name": "source_attribute",
					"type": TYPE_STRING,
					"usage": PROPERTY_USAGE_DEFAULT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": ",".join(attribute_strings)
				}
			)
			
			var source_attribute_source_array: Array[String]
			for key in Util.EAttributeSource.keys():
				key = key as String
				source_attribute_source_array.append(key.to_lower().replace("_", " ").capitalize())
			properties.append(
				{
					"name": "source_attribute_source",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": ",".join(source_attribute_source_array)
				}
			)
			properties.append(
				{
					"name": "source_attribute_coefficient",
					"type": TYPE_FLOAT,
					"usage": PROPERTY_USAGE_DEFAULT
				}
			)
	
	return properties
