class_name ActiveEffect extends Resource

var target_ability_system: AbilitySystemBase
var handle: ActiveEffectHandle
var source_effect_spec: EffectSpec
var duration_interval_id: int
var period_interval_id: int
var affected_attributes: Array[String]

func _init(_target_ability_system: AbilitySystemBase, _source_effect_spec: EffectSpec, _handle: ActiveEffectHandle) -> void:
	target_ability_system = _target_ability_system
	source_effect_spec = _source_effect_spec
	handle = _handle

func ApplyEffect() -> void:
	for modifier in source_effect_spec.modifiers:
		match modifier.magnitude_type:
			pass
	
	match source_effect_spec.duration_policy:
		Util.EDurationPolicy.INFINITE:
			affected_attributes = target_ability_system.ApplyTemporaryModifiers(source_effect_spec.modifiers, handle)
		Util.EDurationPolicy.DURATION:
			if source_effect_spec.period > 0.0:
				if source_effect_spec.execute_period_on_application:
					target_ability_system.ApplyInstantModifiers(source_effect_spec.modifiers, source_effect_spec.effect_context)
				period_interval_id = TimerManager.CreateInterval(self, Period, source_effect_spec.period, false)
			else:
				affected_attributes = target_ability_system.ApplyTemporaryModifiers(source_effect_spec.modifiers, handle)
				
			duration_interval_id = TimerManager.CreateInterval(target_ability_system, target_ability_system.RemoveActiveEffectByHandle.bind(handle), source_effect_spec.duration)

func RemoveEffect() -> void:
	if source_effect_spec.period > 0.0:
		TimerManager.RemoveInterval(period_interval_id)
		
	target_ability_system.RemoveTemporaryModifiers(affected_attributes, handle)

func Period() -> void:
	target_ability_system.ApplyInstantModifiers(source_effect_spec.modifiers, source_effect_spec.effect_context)
