class_name AttributeModifierEvaluatedData extends Resource

var target_ability_system: AbilitySystem
var attribute: Attribute
var modifier: CalculatedAttributeModifier
var source_effect_spec: EffectSpec
var active_effect_handle: ActiveEffectHandle

func _init(_target_ability_system, _attribute: Attribute, _modifier, _source_effect_spec, _active_effect_handle = null) -> void:
	target_ability_system = _target_ability_system
	attribute = _attribute
	modifier = _modifier
	source_effect_spec = _source_effect_spec
	active_effect_handle = _active_effect_handle
