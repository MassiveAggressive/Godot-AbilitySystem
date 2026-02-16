@tool
class_name EffectSpec extends Resource

@export var source_effect_data: Effect:
	set(value):
		source_effect_data = value
		if source_effect_data:
			duration_policy = source_effect_data.duration_policy
			duration_magnitude = source_effect_data.duration_magnitude
			period = source_effect_data.period
			modifiers = source_effect_data.modifiers
			execute_period_on_application = source_effect_data.execute_period_on_application

@export var duration_policy: Util.EDurationPolicy
@export var duration_magnitude: EffectModifierMagnitude
@export var period: float
@export var execute_period_on_application: bool
@export var modifiers: Array[EffectModifierData]

var calculated_modifiers: Array[AttributeModifierEvaluatedData]
var calculated_duration: float = 0.0

var effect_context: EffectContext

func _init(_source_effect_data: Effect = null, _effect_context: EffectContext = null) -> void:
	source_effect_data = _source_effect_data
	effect_context = _effect_context
	
	CalculateModifiers()
	CalculateDuration()

func AddModifier(modifier: EffectModifierData) -> void:
	modifiers.append(modifier)
	
	calculated_modifiers.append(CalculateModifier(modifier))

func GetCalculatedModifiers() -> Array[AttributeModifierEvaluatedData]:
	return calculated_modifiers

func GetCalculatedDurationMagnitude() -> float:
	return calculated_duration

func CalculateModifiers() -> void:
	for modifier in modifiers:
		calculated_modifiers.append(CalculateModifier(modifier))

func CalculateDuration() -> void:
	if duration_magnitude != null:
		calculated_duration = duration_magnitude.CalculateMagnitude(self)

func CalculateModifier(modifier: EffectModifierData) -> AttributeModifierEvaluatedData:
	var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
	var attribute_name: String = modifier.attribute.get_slice(".", 1)
	var attribute_set: AttributeSet = effect_context.target_ability_system.GetAttributeSet(attribute_set_name)
	var magnitude: float = modifier.magnitude.CalculateMagnitude(self)	
	var calculated_modifier: CalculatedAttributeModifier = CalculatedAttributeModifier.new(modifier.operator, magnitude)
	var attribute: Attribute = Attribute.new(attribute_set, attribute_name, attribute_set.GetAttribute(attribute_name))
	var evaluated_attribute_data: AttributeModifierEvaluatedData = AttributeModifierEvaluatedData.new(effect_context.target_ability_system, \
	attribute, calculated_modifier, self)
	
	return evaluated_attribute_data
