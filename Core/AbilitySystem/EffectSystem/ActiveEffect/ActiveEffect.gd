class_name ActiveEffect extends Resource

var source_effect_spec: EffectSpec
var handle: ActiveEffectHandle

var effect_context: EffectContext

var target_ability_system: AbilitySystem
var source_ability_system: AbilitySystem

var calculated_duration_magnitude: float
var duration_interval_id: int
var period_interval_id: int
var affected_attributes: Array[Attribute]

func _init(_source_effect_spec: EffectSpec, _handle: ActiveEffectHandle) -> void:
	source_effect_spec = _source_effect_spec
	handle = _handle
	effect_context = source_effect_spec.effect_context
	target_ability_system = effect_context.target_ability_system
	source_ability_system = effect_context.source_ability_system

func ApplyEffect() -> void:
	var calculated_modifiers: Array[AttributeModifierEvaluatedData] = source_effect_spec.GetCalculatedModifiers()
	
	for modifier in calculated_modifiers:
		modifier.active_effect_handle = handle
		affected_attributes.append(modifier.attribute)
	
	match source_effect_spec.duration_policy:
		Util.EDurationPolicy.INFINITE:
			target_ability_system.AddModifiersToAggregator(calculated_modifiers, handle)
		Util.EDurationPolicy.DURATION:
			calculated_duration_magnitude = source_effect_spec.GetCalculatedDurationMagnitude()
			
			if source_effect_spec.period > 0.0:
				if source_effect_spec.execute_period_on_application:
					target_ability_system.ApplyInstantModifiers(calculated_modifiers)
				period_interval_id = TimerManager.CreateInterval(self, Period, source_effect_spec.period, false)
			else:
				target_ability_system.AddModifiersToAggregator(calculated_modifiers, handle)
			
			duration_interval_id = TimerManager.CreateInterval(target_ability_system, target_ability_system.RemoveActiveEffectByHandle.bind(handle)\
			,source_effect_spec.GetCalculatedDurationMagnitude())

func RemoveEffect() -> void:
	if source_effect_spec.period > 0.0:
		TimerManager.RemoveInterval(period_interval_id)
		
	target_ability_system.RemoveModifiersFromAggregator(affected_attributes, handle)

func Period() -> void:
	target_ability_system.ApplyInstantModifiers(source_effect_spec.GetCalculatedModifiers())
