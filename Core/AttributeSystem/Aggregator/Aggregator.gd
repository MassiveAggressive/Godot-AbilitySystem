class_name Aggregator extends RefCounted

@export var attribute: AttributeData
@export var scalable_float_modifiers: Dictionary[ActiveEffectHandle, ScalableFloatModifierArray]
@export var attribute_based_modifiers: Dictionary[ActiveEffectHandle, AttributeBasedModifierArray]
var captured_attributes: Array[AttributeCapture]

var additive_modifiers: Array[float]
var multiplicative_modifiers: Array[float]
var multiplicative_compound_modifiers: Array[float]
var additive_final_modifiers: Array[float]
var overrider_modifiers: Array[float]

func _init(_attribute: AttributeData) -> void:
	attribute = _attribute

func AddScalableFloatModifier(active_effect_handle: ActiveEffectHandle, modifier: ScalableFloatModifier) -> void:
	if !scalable_float_modifiers.has(active_effect_handle):
		scalable_float_modifiers[active_effect_handle] = ScalableFloatModifierArray.new()
	
	scalable_float_modifiers[active_effect_handle].array.append(modifier)

func AddAttributeBasedModifier(active_effect_handle: ActiveEffectHandle, modifier: AttributeBasedModifier) -> void:
	if !attribute_based_modifiers.has(active_effect_handle):
		attribute_based_modifiers[active_effect_handle] = AttributeBasedModifierArray.new()
	
	attribute_based_modifiers[active_effect_handle].array.append(modifier)
	
	modifier.attribute_capture.AttributeChanged.connect(OnAttributeChanged)

func RemoveModifier(active_effect_handle: ActiveEffectHandle) -> void:
	scalable_float_modifiers.erase(active_effect_handle)
	attribute_based_modifiers.erase(active_effect_handle)

func OnAttributeChanged() -> void:
	print(Calculate())

func Calculate() -> float:
	additive_modifiers.clear()
	multiplicative_modifiers.clear()
	multiplicative_compound_modifiers.back()
	additive_final_modifiers.clear()
	overrider_modifiers.clear()
	
	var value_result: float = 0.0
	
	for handle in scalable_float_modifiers:
		for modifier in scalable_float_modifiers[handle].array:
			match modifier.operator:
				Util.EOperator.ADD:
					additive_modifiers.append(modifier.scalable_float_magnitude * modifier.coefficient)
				Util.EOperator.MULTIPLY:
					multiplicative_modifiers.append(modifier.scalable_float_magnitude * modifier.coefficient)
				Util.EOperator.DIVIDE:
					multiplicative_modifiers.append(1 / (modifier.scalable_float_magnitude * modifier.coefficient))
				Util.EOperator.MULTIPLY_COMPOUND:
					multiplicative_compound_modifiers.append(modifier.scalable_float_magnitude * modifier.coefficient)
				Util.EOperator.ADD_FINAL:
					additive_final_modifiers.append(modifier.scalable_float_magnitude * modifier.coefficient)
				Util.EOperator.OVERRIDE:
					overrider_modifiers.append(modifier.scalable_float_magnitude * modifier.coefficient)
	for handle in attribute_based_modifiers:
		for modifier in attribute_based_modifiers[handle].array:
			match modifier.operator:
				Util.EOperator.ADD:
					additive_modifiers.append(modifier.attribute_capture.attribute_data.current_value * modifier.coefficient)
				Util.EOperator.MULTIPLY:
					multiplicative_modifiers.append(modifier.attribute_capture.attribute_data.current_value * modifier.coefficient)
				Util.EOperator.DIVIDE:
					multiplicative_modifiers.append(1 / (modifier.attribute_capture.attribute_data.current_value * modifier.coefficient))
				Util.EOperator.MULTIPLY_COMPOUND:
					multiplicative_compound_modifiers.append(modifier.attribute_capture.attribute_data.current_value * modifier.coefficient)
				Util.EOperator.ADD_FINAL:
					additive_final_modifiers.append(modifier.attribute_capture.attribute_data.current_value * modifier.coefficient)
				Util.EOperator.OVERRIDE:
					overrider_modifiers.append(modifier.attribute_capture.attribute_data.current_value * modifier.coefficient)
	
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
