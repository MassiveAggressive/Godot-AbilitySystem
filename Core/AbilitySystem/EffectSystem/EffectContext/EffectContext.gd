class_name EffectContext extends Resource

var source_ability_system: AbilitySystem
var target_ability_system: AbilitySystem

func _init(_source_ability_system: AbilitySystem = null, _target_ability_system: AbilitySystem = null) -> void:
	source_ability_system = _source_ability_system
	target_ability_system = _target_ability_system
