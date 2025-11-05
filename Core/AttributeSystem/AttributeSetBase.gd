@tool 
class_name AttributeSetBase extends Resource

signal AttributeBaseChanged(attribute_set: AttributeSetBase, name: String, value: float)
signal AttributeChanged(name: String, value: float)

@export var attribute_set_name: String

@export var attributes: Dictionary[String, AttributeData]:
	set(value):
		attributes = value
		AttributePicker.AddAttributes(attribute_set_name, attributes.keys())

var aggregators: Dictionary[String, Aggregator]

func InitializeAttribute(attribute_name: String, value: float = 0.0) -> AttributeData:
	if attributes.has(attribute_name):
		return attributes[attribute_name]
	else:
		var new_attribute: AttributeData = AttributeData.new(value)
		
		attributes[attribute_name] = new_attribute
		
		return new_attribute

func HasAttribute(attribute_name: String) -> bool:
	return attributes.has(attribute_name)

func GetAttribute(attribute_name: String) -> AttributeData:
	return attributes[attribute_name]

func SetAttributeBaseValue(attribute_name: String, new_value: float) -> void:
	attributes[attribute_name].base_value = new_value
	AttributeBaseChanged.emit(attribute_name, new_value)

func GetAttributeBaseValue(attribute_name: String) -> float:
	return attributes[attribute_name].base_value

func SetAttributeValue(attribute_name: String, new_value: float) -> void:
	attributes[attribute_name].current_value = new_value
	AttributeChanged.emit(attribute_name, new_value)

func GetAttributeValue(attribute_name: String) -> float:
	return attributes[attribute_name].current_value

func CreateAggregator(attribute_name: String) -> Aggregator:
	var new_aggregator: Aggregator = Aggregator.new(attributes[attribute_name])
	
	aggregators[attribute_name] = new_aggregator
	
	return new_aggregator

func AddAggregator(attribute_name: String, aggregator: Aggregator) -> void:
	aggregators[attribute_name] = aggregator

func HasAggregator(attribute_name: String) -> bool:
	return aggregators.has(attribute_name)

func GetAggregator(attribute_name: String) -> Aggregator:
	if aggregators.has(attribute_name):
		return aggregators[attribute_name]
	else:
		return CreateAggregator(attribute_name)

func PreAttributeBaseChange(attribute_name: String, new_value: NewValue) -> void:
	pass

func PreAttributeChange(attribute_name: String, new_value: NewValue) -> void:
	pass
