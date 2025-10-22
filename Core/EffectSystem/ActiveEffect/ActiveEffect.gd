class_name ActiveEffect extends Resource

var target_ability_system: AbilitySystemBase
var handle: ActiveEffectHandle

var source_effect_spec: EffectSpec

var affected_aggregator: Dictionary[String, Aggregator]

func _init(_target_ability_system: AbilitySystemBase, _source_effect_spec: EffectSpec, _handle: ActiveEffectHandle) -> void:
	target_ability_system = _target_ability_system
	source_effect_spec = _source_effect_spec
	handle = _handle

func ApplyEffect() -> void:
	match source_effect_spec.duration_policy:
		Util.EDurationPolicy.INSTANT, Util.EDurationPolicy.INFINITE:
			target_ability_system.SetupModifiers(source_effect_spec.modifiers, source_effect_spec.duration_policy, handle)
		Util.EDurationPolicy.DURATION:
			if source_effect_spec.period > 0.0:
				target_ability_system.SetupModifiers(source_effect_spec.modifiers, Util.EDurationPolicy.INSTANT, handle)
				TimerManager.CreateInterval(self, Period, source_effect_spec.period, false)
			else:
				target_ability_system.SetupModifiers(source_effect_spec.modifiers, source_effect_spec.duration_policy, handle)
				
			TimerManager.CreateInterval(target_ability_system, target_ability_system.RemoveActiveEffectByHandle.bind(handle), source_effect_spec.duration)

func RemoveEffect() -> void:
	pass

func Period() -> void:
	target_ability_system.SetupModifiers(source_effect_spec.modifiers, Util.EDurationPolicy.INSTANT, handle)
