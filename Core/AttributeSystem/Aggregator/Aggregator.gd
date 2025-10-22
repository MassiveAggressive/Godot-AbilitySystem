class_name Aggregator extends RefCounted

@export var attribute: AttributeData
@export var modifiers: Dictionary[ActiveEffectHandle, AttributeModifierArray]

var additive_modifiers: Array[float]
var multiplicative_modifiers: Array[float]
var overrider_modifiers: Array[float]

func _init(_attribute: AttributeData) -> void:
	attribute = _attribute

func AddModifier(active_effect_handle: ActiveEffectHandle, modifier: AttributeModifier) -> void:
	if !modifiers.has(active_effect_handle):
		modifiers[active_effect_handle] = AttributeModifierArray.new()
	
	modifiers[active_effect_handle].array.append(modifier)

func RemoveModifier(active_effect_handle: ActiveEffectHandle) -> void:
	modifiers.erase(active_effect_handle)

func Calculate() -> float:
	additive_modifiers.clear()
	multiplicative_modifiers.clear()
	overrider_modifiers.clear()
	
	var value_result: float = 0.0
	
	for handle in modifiers:
		for modifier in modifiers[handle].array:
			match modifier.operator:
				Util.EOperator.ADD:
					additive_modifiers.append(modifier.magnitude * modifier.coefficient)
				Util.EOperator.MULTIPLY:
					multiplicative_modifiers.append(modifier.magnitude * modifier.coefficient)
				Util.EOperator.DIVIDE:
					multiplicative_modifiers.append(1 / (modifier.magnitude * modifier.coefficient))
				Util.EOperator.OVERRIDE:
					overrider_modifiers.append(modifier.magnitude * modifier.coefficient)
				
	var additive_total: float = 0.0
	
	for modifier in additive_modifiers:
		additive_total += modifier
	
	var multiplicative_total = 1.0
	
	for modifier in multiplicative_modifiers:
		multiplicative_total *= modifier
	
	value_result = (attribute.base_value + additive_total) * multiplicative_total
	
	if overrider_modifiers.size() > 0:
		value_result = overrider_modifiers[overrider_modifiers.size() - 1]
	
	return value_result
