@tool
class_name AttributePicker extends Resource

static var editor_attributes: Dictionary
static var attributes_path: String = "res://Core/AbilitySystem/AttributeSystem/AttributePicker/EditorAttributes.txt"

var attribute: String

static func InitializeAttributes() -> void:
	var file = FileAccess.open(attributes_path, FileAccess.READ)
	
	if file:
		AttributePicker.editor_attributes = JSON.parse_string(file.get_as_text())

static func AddAttributes(attribute_set_name: String, attribute_names: Array[String]) -> void:
	AttributePicker.editor_attributes[attribute_set_name] = attribute_names
	
	var file = FileAccess.open(attributes_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(AttributePicker.editor_attributes, "\t"))

func _init(_attribute: String = "") -> void:
	attribute = _attribute
	AttributePicker.InitializeAttributes()

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
