@tool
class_name AttributeModifierData extends Resource

@export var attribute: String:
	set(value):
		attribute = value
@export var operator: Util.EOperator

@export_group("Modifier Magnitude")
@export var magnitude_type: Util.EMagnitudeType:
	set(value):
		magnitude_type = value
		notify_property_list_changed()

@export var coefficient: float = 1.0

var scalable_float_magnitude: float

var source_attribute: String
var source_attribute_source: Util.EAttributeSource

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

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]
	
	match magnitude_type:
		Util.EMagnitudeType.SCALABLE_FLOAT:
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
			
			var attribute_source_strings: Array[String]
			
			for key in Util.EAttributeSource.keys():
				attribute_source_strings.append((key as String).capitalize())
			
			properties.append(
				{
					"name": "source_attribute_source",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
					"hint": PROPERTY_HINT_ENUM,
					"hint_string": ",".join(attribute_source_strings)
				}
			)
	
	return properties
