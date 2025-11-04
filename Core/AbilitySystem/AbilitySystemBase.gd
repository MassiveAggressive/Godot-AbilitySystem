@tool
class_name AbilitySystemBase extends Node

var owner_node: Node

@export var attribute_sets: Dictionary[String, AttributeSetBase]

var active_effects: Dictionary[int, ActiveEffect]

func _ready() -> void:
	owner_node = get_parent()
	
	for attribute_set in attribute_sets.values():
		attribute_set = attribute_set as AttributeSetBase
		
		attribute_set.AttributeBaseChanged.connect(OnAttributeBaseChanged)

func GetAttributeSet(attribute_set_name: String) -> AttributeSetBase:
	if attribute_sets.has(attribute_set_name):
		return attribute_sets[attribute_set_name]
	return null

func OnAttributeBaseChanged(attribute_name: String, value: float) -> void:
	print(attribute_name, ": ", value)

func CreateNewID() -> int:
	if active_effects.is_empty():
		return 0
	else:
		return active_effects.keys().max() + 1

func MakeEffectSpec(effect_data: EffectData, effect_context: EffectContext) -> EffectSpec:
	var effect_spec: EffectSpec = EffectSpec.new(effect_data, effect_context)
	
	return effect_spec

func ApplyEffectSpecToTarget(effect_spec: EffectSpec, effect_target: AbilitySystemBase) -> ActiveEffectHandle:
	return effect_target.ApplyEffectSpecToSelf(effect_spec)

func ApplyEffectSpecToSelf(effect_spec: EffectSpec) -> ActiveEffectHandle:
	if effect_spec.duration == Util.EDurationPolicy.INSTANT:
		ApplyInstantModifiers(effect_spec.modifiers, effect_spec.effect_context)
		
		return null
	else:
		var new_id: int = CreateNewID()
		var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
		var active_effect: ActiveEffect = ActiveEffect.new(self, effect_spec, active_effect_handle)
		
		active_effects[new_id] = active_effect
		active_effect.ApplyEffect()
		
		return active_effect_handle

func ApplyInstantModifiers(modifiers: Array[AttributeModifierData], effect_context: EffectContext) -> void:
	for modifier in modifiers:
		var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
		var attribute_name: String = modifier.attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = Aggregator.new(attribute_set.GetAttribute(attribute_name))
		
		match modifier.magnitude_type:
			Util.EMagnitudeType.SCALABLE_FLOAT:
				var scalable_float_modifier: ScalableFloatModifier = ScalableFloatModifier.new(modifier.operator, modifier.coefficient, modifier.scalable_float_magnitude)
				
				aggregator.AddScalableFloatModifier(null, scalable_float_modifier)
			Util.EMagnitudeType.ATTRIBUTE_BASED:
				var attribute_capture: AttributeCapture
				var source_attribute_set_name: String = modifier.source_attribute.get_slice(".", 0)
				var source_attribute_name: String = modifier.source_attribute.get_slice(".", 1)
				
				match modifier.source_attribute_source:
					Util.EAttributeSource.SOURCE:
						attribute_capture = AttributeCapture.new(effect_context.source_ability_system.GetAttributeSet(source_attribute_set_name), source_attribute_name)
					Util.EAttributeSource.TARGET:
						attribute_capture = AttributeCapture.new(effect_context.target_ability_system.GetAttributeSet(source_attribute_set_name), source_attribute_name)
				var attribute_based_modifier: AttributeBasedModifier = AttributeBasedModifier.new(modifier.operator, modifier.coefficient, attribute_capture)
				
				aggregator.AddAttributeBasedModifier(null, attribute_based_modifier)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeBaseChange(attribute_name, new_value)
		attribute_set.SetAttributeBaseValue(attribute_name, new_value.value)

func ApplyTemporaryModifiers(modifiers: Array[AttributeModifierData], effect_context: EffectContext, active_effect_handle: ActiveEffectHandle) -> Array[String]:
	var affected_attributes: Array[String]
	
	for modifier in modifiers:
		var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
		var attribute_name: String = modifier.attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
		
		match modifier.magnitude_type:
			Util.EMagnitudeType.SCALABLE_FLOAT:
				var scalable_float_modifier: ScalableFloatModifier = ScalableFloatModifier.new(modifier.operator, modifier.coefficient, modifier.scalable_float_magnitude)
				
				aggregator.AddScalableFloatModifier(active_effect_handle, scalable_float_modifier)
			Util.EMagnitudeType.ATTRIBUTE_BASED:
				var attribute_capture: AttributeCapture
				var source_attribute_set_name: String = modifier.source_attribute.get_slice(".", 0)
				var source_attribute_name: String = modifier.source_attribute.get_slice(".", 1)
				
				match modifier.source_attribute_source:
					Util.EAttributeSource.SOURCE:
						attribute_capture = AttributeCapture.new(effect_context.source_ability_system.GetAttributeSet(source_attribute_set_name), source_attribute_name)
					Util.EAttributeSource.TARGET:
						attribute_capture = AttributeCapture.new(effect_context.target_ability_system.GetAttributeSet(source_attribute_set_name), source_attribute_name)
				var attribute_based_modifier: AttributeBasedModifier = AttributeBasedModifier.new(modifier.operator, modifier.coefficient, attribute_capture)
				
				aggregator.AddAttributeBasedModifier(active_effect_handle, attribute_based_modifier)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeChange(attribute_name, new_value)
		attribute_set.SetAttributeValue(attribute_name, new_value.value)
		
		affected_attributes.append(modifier.attribute)
	
	return affected_attributes

func RemoveTemporaryModifiers(attributes: Array[String], active_effect_handle: ActiveEffectHandle) -> void:
	for attribute in attributes:
		var attribute_set_name: String = attribute.get_slice(".", 0)
		var attribute_name: String = attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
		
		aggregator.RemoveModifier(active_effect_handle)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeChange(attribute_name, new_value)
		attribute_set.SetAttributeValue(attribute_name, new_value.value)

func RemoveActiveEffectByID(id: int) -> void:
	if active_effects.has(id):
		active_effects[id].RemoveEffect()
		active_effects.erase(id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
