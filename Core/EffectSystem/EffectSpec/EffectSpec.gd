@tool
class_name EffectSpec extends Resource

var source_ability_system: AbilitySystemBase
@export var source_effect_data: EffectData:
	set(value):
		source_effect_data = value
		if source_effect_data:
			duration_policy = source_effect_data.duration_policy
			duration = source_effect_data.duration
			modifiers = source_effect_data.modifiers

@export var duration_policy: Util.EDurationPolicy
@export var duration: float
@export var period: float
@export var execute_period_on_application: bool
@export var modifiers: Array[AttributeModifierData]

func _init(_source_ability_system: AbilitySystemBase = null, _source_effect_data: EffectData = null) -> void:
	if _source_ability_system:
		source_ability_system = _source_ability_system
		if _source_effect_data:
			source_effect_data = _source_effect_data
			duration_policy = source_effect_data.duration_policy
			duration = source_effect_data.duration
			period = source_effect_data.period
			execute_period_on_application = source_effect_data.execute_period_on_application
			modifiers = source_effect_data.modifiers.duplicate_deep()

func AddModifier(attribute_name: String, modifier_magnitude: ModifierMagnitude) -> void:
	var attribute_modifier_data: AttributeModifierData = AttributeModifierData.new(attribute_name, modifier_magnitude)
	modifiers.append(attribute_modifier_data)
