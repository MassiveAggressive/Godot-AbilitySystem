class_name EffectContext extends Resource

var source_ability_system: AbilitySystemBase
var target_ability_system: AbilitySystemBase

func _init(_source_ability_system: AbilitySystemBase = null, _target_ability_system: AbilitySystemBase = null) -> void:
	source_ability_system = _source_ability_system
	target_ability_system = _target_ability_system
