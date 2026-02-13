@tool
class_name EffectModifierMagnitude extends Resource

var magnitude_type: Util.EMagnitudeType:
	set(value):
		magnitude_type = value
		notify_property_list_changed()

var scalable_float_magnitude: float
var coefficient: float = 1.0

var source_attribute: String
var source_attribute_source: Util.EAttributeSource
var source_attribute_coefficient: float = 1.0

func CalculateMagnitude(source_effect_spec: EffectSpec) -> float:
	match magnitude_type:
		Util.EMagnitudeType.SCALABLE_FLOAT:
			return scalable_float_magnitude * coefficient
		Util.EMagnitudeType.ATTRIBUTE_BASED:
			var source_attribute_set_name: String = source_attribute.get_slice(".", 0)
			var source_attribute_name: String = source_attribute.get_slice(".", 1)
			var source_attribute_set: AttributeSet
			
			match source_attribute_source:
				Util.EAttributeSource.SOURCE:
					source_attribute_set = source_effect_spec.effect_context.source_ability_system.GetAttributeSet(source_attribute_set_name)
				Util.EAttributeSource.TARGET:
					source_attribute_set = source_effect_spec.effect_context.target_ability_system.GetAttributeSet(source_attribute_set_name)
			
			var attribute_value: float = source_attribute_set.GetAttributeValue(source_attribute_name)
			
			return attribute_value * source_attribute_coefficient * coefficient
	
	return 0.0

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
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
			
			var attribute_strings: Array[String]
	
			for attribute_set_name: String in AttributePicker.editor_attributes:
				for attribute_name in AttributePicker.editor_attributes[attribute_set_name]:
					attribute_strings.append(attribute_set_name + "." + attribute_name)
			
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
