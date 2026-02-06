class_name Aggregator extends RefCounted

@export var attribute: AttributeData
@export var modifiers: Dictionary[ActiveEffectHandle, Array]

func _init(_attribute: AttributeData) -> void:
	attribute = _attribute

func AddModifier(active_effect_handle: ActiveEffectHandle, modifier: AggregatorModifier) -> void:
	if !modifiers.has(active_effect_handle):
		modifiers[active_effect_handle] = []
	
	modifiers[active_effect_handle].append(modifier)

func RemoveModifier(active_effect_handle: ActiveEffectHandle) -> void:
	modifiers.erase(active_effect_handle)

func Calculate() -> float:
	var additive_modifiers: Array[float]
	var multiplicative_modifiers: Array[float]
	var multiplicative_compound_modifiers: Array[float]
	var additive_final_modifiers: Array[float]
	var overrider_modifiers: Array[float]
	
	var value_result: float = 0.0
	
	for handle in modifiers:
		for modifier in modifiers[handle]:
			modifier = modifier as AggregatorModifier
			match modifier.operator:
				Util.EOperator.ADD:
					additive_modifiers.append(modifier.magnitude)
				Util.EOperator.MULTIPLY:
					multiplicative_modifiers.append(modifier.magnitude)
				Util.EOperator.DIVIDE:
					multiplicative_modifiers.append(1 / modifier.magnitude)
				Util.EOperator.MULTIPLY_COMPOUND:
					multiplicative_compound_modifiers.append(modifier.magnitude)
				Util.EOperator.ADD_FINAL:
					additive_final_modifiers.append(modifier.magnitude)
				Util.EOperator.OVERRIDE:
					overrider_modifiers.append(modifier.magnitude)
	
	var additive_total: float = 0.0
	
	for modifier in additive_modifiers:
		additive_total += modifier
	
	var multiplicative_total = 1.0
	
	for modifier in multiplicative_modifiers:
		multiplicative_total += modifier - 1
	
	value_result = (attribute.base_value + additive_total) * multiplicative_total
	
	for modifier in multiplicative_compound_modifiers:
		value_result *= modifier
	
	var additive_final_total: float = 0.0
	
	for modifier in additive_final_modifiers:
		additive_final_total += modifier
	
	value_result += additive_final_total
	
	if overrider_modifiers.size() > 0:
		value_result = overrider_modifiers[overrider_modifiers.size() - 1]
	
	return value_result
