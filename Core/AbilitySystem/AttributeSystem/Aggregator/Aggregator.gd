class_name Aggregator extends RefCounted

@export var attribute: AttributeData
@export var modifiers: Dictionary[ActiveEffectHandle, Array]

func _init(_attribute: AttributeData) -> void:
	attribute = _attribute

func AddModifier(active_effect_handle: ActiveEffectHandle, modifier: CalculatedAttributeModifier) -> void:
	if !modifiers.has(active_effect_handle):
		modifiers[active_effect_handle] = []
	
	modifiers[active_effect_handle].append(modifier)

func RemoveModifier(active_effect_handle: ActiveEffectHandle) -> void:
	modifiers.erase(active_effect_handle)

func Calculate(base_value: float = attribute.base_value) -> float:
	var all_modifiers: Array[CalculatedAttributeModifier]
	
	for array in modifiers.values():
		all_modifiers.append_array(array)
		
	return ModifierCalculator.Calculate(base_value, all_modifiers)
