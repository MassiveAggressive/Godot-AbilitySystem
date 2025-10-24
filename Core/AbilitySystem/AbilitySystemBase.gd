@tool
class_name AbilitySystemBase extends Node

var owner_node: Node

@export var attribute_sets: Dictionary[String, AttributeSetBase]

var active_effects: Dictionary[int, ActiveEffect]

func _ready() -> void:
	owner_node = get_parent()

func CreateNewID() -> int:
	if active_effects.is_empty():
		return 0
	else:
		return active_effects.keys().max() + 1

func MakeEffectSpec(effect_data: EffectData) -> EffectSpec:
	var effect_spec: EffectSpec = EffectSpec.new(self, effect_data)
	
	return effect_spec

func ApplyEffectSpecToTarget(effect_spec: EffectSpec, effect_target: AbilitySystemBase) -> ActiveEffectHandle:
	return effect_target.ApplyEffectSpecToSelf(effect_spec)

func ApplyEffectSpecToSelf(effect_spec: EffectSpec) -> ActiveEffectHandle:
	if effect_spec.duration == Util.EDurationPolicy.INSTANT:
		ApplyInstantModifiers(effect_spec.modifiers)
		
		return null
	else:
		var new_id: int = CreateNewID()
		var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
		var active_effect: ActiveEffect = ActiveEffect.new(self, effect_spec, active_effect_handle)
		
		active_effects[new_id] = active_effect
		active_effect.ApplyEffect()
		
		return active_effect_handle

func ApplyInstantModifiers(modifiers: Array[AttributeModifierData]) -> void:
	for modifier in modifiers:
		var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
		var attribute_name: String = modifier.attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = Aggregator.new(attribute_set.GetAttribute(attribute_name))
		
		aggregator.AddModifier(null, modifier.modifier)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeBaseChange(attribute_name, new_value)
		attribute_set.SetAttributeBaseValue(attribute_name, new_value.value)

func SetupModifiers(modifiers: Array[AttributeModifierData], active_effect_handle: ActiveEffectHandle) -> Array[String]:
	var affected_attributes: Array[String]
	
	for modifier in modifiers:
		var attribute_set_name: String = modifier.attribute.get_slice(".", 0)
		var attribute_name: String = modifier.attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
		
		aggregator.AddModifier(active_effect_handle, modifier.modifier)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeChange(attribute_name, new_value)
		attribute_set.SetAttributeValue(attribute_name, new_value.value)
		
		affected_attributes.append(modifier.attribute)
	
	return affected_attributes

func RemoveModifiers(attributes: Array[String], active_effect_handle: ActiveEffectHandle) -> void:
	for attribute in attributes:
		var attribute_set_name: String = attribute.get_slice(".", 0)
		var attribute_name: String = attribute.get_slice(".", 1)
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
		
		aggregator.RemoveModifier(active_effect_handle)
		
		var new_value: NewValue = NewValue.new(aggregator.Calculate())
		
		attribute_set.PreAttributeCurrentChange(attribute_name, new_value)
		attribute_set.SetAttributeValue(attribute_name, new_value.value)

func RemoveActiveEffectByID(id: int) -> void:
	if active_effects.has(id):
		active_effects[id].RemoveEffect()
		active_effects.erase(id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
