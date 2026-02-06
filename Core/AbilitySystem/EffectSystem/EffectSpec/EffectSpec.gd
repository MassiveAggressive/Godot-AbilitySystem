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
@export var modifiers: Array[AttributeModifier]

var effect_context: EffectContext

func _init(_source_effect_data: Effect = null, _effect_context: EffectContext = null) -> void:
	source_effect_data = _source_effect_data
	effect_context = _effect_context

func AddModifier(attribute_modifier_data: AttributeModifier) -> void:
	modifiers.append(attribute_modifier_data)

func CalculateModifiers() -> Dictionary[String, Array]:
	var calculated_modifiers: Dictionary[String, Array]
	
	for modifier in modifiers:
		var magnitude: float 
		
		match modifier.magnitude_type:
			Util.EMagnitudeType.SCALABLE_FLOAT:
				magnitude = modifier.scalable_float_magnitude * modifier.coefficient
			Util.EMagnitudeType.ATTRIBUTE_BASED:
				var attribute_capture: AttributeCapture
				var source_attribute_set_name: String = modifier.source_attribute.get_slice(".", 0)
				var source_attribute_name: String = modifier.source_attribute.get_slice(".", 1)
				
				match modifier.source_attribute_source:
					Util.EAttributeSource.SOURCE:
						var attribute_set: AttributeSet = effect_context.source_ability_system.GetAttributeSet(source_attribute_set_name)
						var attribute_value: float = attribute_set.GetAttributeValue(source_attribute_name)
						
						magnitude = attribute_value * modifier.coefficient
					Util.EAttributeSource.TARGET:
						var attribute_set: AttributeSet = effect_context.target_ability_system.GetAttributeSet(source_attribute_set_name)
						var attribute_value: float = attribute_set.GetAttributeValue(source_attribute_name)
						
						magnitude = attribute_value * modifier.coefficient
		
		var aggregator_modifier_data: AggregatorModifier = AggregatorModifier.new(modifier.operator, magnitude)
		
		if !calculated_modifiers.has(modifier.attribute):
			calculated_modifiers[modifier.attribute] = []
			
		calculated_modifiers[modifier.attribute].append(aggregator_modifier_data)
	
	return calculated_modifiers
