class_name ActiveEffectHandle extends Resource

var source_ability_system: AbilitySystemBase
var id: int

func _init(_source_ability_system: AbilitySystemBase, _id: int) -> void:
	source_ability_system = _source_ability_system
	id = _id

func IsValid() -> bool:
	return source_ability_system.active_effects.has(id)

func GetEffect() -> ActiveEffect:
	return source_ability_system.active_effects[id]
