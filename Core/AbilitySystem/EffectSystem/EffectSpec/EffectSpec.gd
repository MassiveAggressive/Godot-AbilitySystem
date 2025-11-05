@tool
class_name EffectSpec extends Resource

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

var effect_context: EffectContext

func _init(_source_effect_data: EffectData = null, _effect_context: EffectContext = null) -> void:
	if _source_effect_data:
		source_effect_data = _source_effect_data
		duration_policy = source_effect_data.duration_policy
		duration = source_effect_data.duration
		period = source_effect_data.period
		execute_period_on_application = source_effect_data.execute_period_on_application
		modifiers = source_effect_data.modifiers.duplicate_deep()
	
	effect_context = _effect_context

func AddModifier(attribute_modifier_data: AttributeModifierData) -> void:
	modifiers.append(attribute_modifier_data)
