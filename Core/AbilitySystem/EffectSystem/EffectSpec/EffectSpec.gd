@tool
class_name EffectSpec extends Resource

@export var source_effect_data: Effect:
	set(value):
		source_effect_data = value
		if source_effect_data:
			duration_policy = source_effect_data.duration_policy
			duration = source_effect_data.duration
			period = source_effect_data.period
			modifiers = source_effect_data.modifiers
			execute_period_on_application = source_effect_data.execute_period_on_application

@export var duration_policy: Util.EDurationPolicy
@export var duration: float
@export var period: float
@export var execute_period_on_application: bool
@export var modifiers: Array[EffectAttributeModifier]

var calculated_modifiers: Array[EvaluatedAttributeData]

var effect_context: EffectContext

func _init(_source_effect_data: Effect = null, _effect_context: EffectContext = null) -> void:
	source_effect_data = _source_effect_data
	effect_context = _effect_context
	
	CalculateModifiers()

func AddModifier(modifier: EffectAttributeModifier) -> void:
	modifiers.append(modifier)
	
	calculated_modifiers.append(CalculateModifier(modifier))

func GetCalculatedModifiers() -> Array[EvaluatedAttributeData]:
	return calculated_modifiers

func CalculateModifiers() -> void:
	for modifier in modifiers:
		calculated_modifiers.append(CalculateModifier(modifier))

func CalculateModifier(modifier: EffectAttributeModifier) -> EvaluatedAttributeData:
	var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
	var attribute_name: String = modifier.attribute.get_slice(".", 1)
	var attribute_set: AttributeSet = effect_context.target_ability_system.GetAttributeSet(attribute_set_name)
	var magnitude: float 
	
	match modifier.magnitude_type:
		Util.EMagnitudeType.SCALABLE_FLOAT:
			magnitude = modifier.scalable_float_magnitude * modifier.coefficient
		Util.EMagnitudeType.ATTRIBUTE_BASED:
			var source_attribute_set: AttributeSet
			
			match modifier.source_attribute_source:
				Util.EAttributeSource.SOURCE:
					source_attribute_set = effect_context.source_ability_system.GetAttributeSet(attribute_set_name)
				Util.EAttributeSource.TARGET:
					source_attribute_set = effect_context.target_ability_system.GetAttributeSet(attribute_set_name)
			
			var attribute_value: float = source_attribute_set.GetAttributeValue(attribute_name)
			
			magnitude = attribute_value * modifier.source_attribute_coefficient * modifier.coefficient
	
	var calculated_modifier: CalculatedAttributeModifier = CalculatedAttributeModifier.new(modifier.operator, magnitude)
	var attribute: Attribute = Attribute.new(attribute_set, attribute_name, attribute_set.GetAttribute(attribute_name))
	var evaluated_attribute_data: EvaluatedAttributeData = EvaluatedAttributeData.new(effect_context.target_ability_system, \
	attribute, calculated_modifier, self)
	
	return evaluated_attribute_data
