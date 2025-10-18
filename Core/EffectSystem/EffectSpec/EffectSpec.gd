class_name EffectSpec extends Resource

var source_ability_system: AbilitySystemBase
var source_effect_data: EffectData

var duration_policy: Util.EDurationPolicy
var duration: float
var modifiers: Dictionary[AttributePicker, AttributeModifier]

func _init(_source_ability_system: AbilitySystemBase, _source_effect_data: EffectData) -> void:
	source_ability_system = _source_ability_system
	source_effect_data = _source_effect_data
	duration_policy = source_effect_data.duration_policy
	duration = source_effect_data.duration
	modifiers = source_effect_data.modifiers.duplicate_deep()

func AddModifier(attribute_name: String, attribute_modifier: AttributeModifier) -> void:
	var attribute_picker: AttributePicker = AttributePicker.new(attribute_name)
	modifiers[attribute_picker] = attribute_modifier
