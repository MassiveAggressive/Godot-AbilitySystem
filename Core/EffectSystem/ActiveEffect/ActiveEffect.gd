class_name ActiveEffect extends Resource

var target_ability_system: AbilitySystemBase
var source_effect_spec: EffectSpec

var affected_aggregator: Dictionary[String, Aggregator]

func _init(_target_ability_system: AbilitySystemBase, _source_effect_spec: EffectSpec) -> void:
	target_ability_system = _target_ability_system
	source_effect_spec = _source_effect_spec
