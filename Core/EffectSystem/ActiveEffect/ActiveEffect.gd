class_name ActiveEffect extends Resource

var target_ability_system: AbilitySystemBase
var handle: ActiveEffectHandle

var source_effect_spec: EffectSpec

var duration_interval_id: int
var period_interval_id: int

var affected_aggregators: Dictionary[String, Aggregator]

func _init(_target_ability_system: AbilitySystemBase, _source_effect_spec: EffectSpec, _handle: ActiveEffectHandle) -> void:
	target_ability_system = _target_ability_system
	source_effect_spec = _source_effect_spec
	handle = _handle

func ApplyEffect() -> void:
	match source_effect_spec.duration_policy:
		Util.EDurationPolicy.INSTANT, Util.EDurationPolicy.INFINITE:
			affected_aggregators = target_ability_system.SetupModifiers(source_effect_spec.modifiers, source_effect_spec.duration_policy, handle)
		Util.EDurationPolicy.DURATION:
			if source_effect_spec.period > 0.0:
				affected_aggregators = target_ability_system.SetupModifiers(source_effect_spec.modifiers, Util.EDurationPolicy.INSTANT, handle)
				period_interval_id = TimerManager.CreateInterval(self, Period, source_effect_spec.period, false)
			else:
				affected_aggregators = target_ability_system.SetupModifiers(source_effect_spec.modifiers, source_effect_spec.duration_policy, handle)
				
			duration_interval_id = TimerManager.CreateInterval(target_ability_system, target_ability_system.RemoveActiveEffectByHandle.bind(handle), source_effect_spec.duration)

func RemoveEffect() -> void:
	if source_effect_spec.period > 0.0:
		TimerManager.RemoveInterval(period_interval_id)
		
	target_ability_system.RemoveModifiers(affected_aggregators.keys(), handle)

func Period() -> void:
	target_ability_system.SetupModifiers(source_effect_spec.modifiers, Util.EDurationPolicy.INSTANT, handle)
