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

func ApplyEffectSpecToSelf(effect_spec: EffectSpec) -> ActiveEffectHandle:
	var new_id: int = CreateNewID()
	var active_effect: ActiveEffect = ActiveEffect.new(self, effect_spec)
	
	active_effects[new_id] = active_effect
	
	var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
	
	active_effect.affected_aggregator = SetupModifiers(effect_spec.modifiers, effect_spec.duration_policy, active_effect_handle)
	
	return active_effect_handle

func SetupModifiers(modifiers: Dictionary[AttributePicker, AttributeModifier], duration_policy: Util.EDurationPolicy, active_effect_handle: ActiveEffectHandle) -> Dictionary[String, Aggregator]:
	var affected_aggregators: Dictionary[String, Aggregator]
	
	for attribute_picker in modifiers:
		var modifier: AttributeModifier = modifiers[attribute_picker]
		var attribute_set_name: String = attribute_picker.attribute.get_slice(".", 0)
		var attribute_name: String = attribute_picker.attribute.get_slice(".", 1)
		
		var attribute_set: AttributeSetBase = attribute_sets[attribute_set_name]
		
		var aggregator: Aggregator
		
		match duration_policy:
			Util.EDurationPolicy.INSTANT:
				aggregator = Aggregator.new(attribute_set.GetAttribute(attribute_name))
				
				aggregator.AddModifier(active_effect_handle, modifier)
				
				var new_value: NewValue = NewValue.new(aggregator.Calculate())
				
				attribute_set.PreAttributeBaseChange(attribute_name, new_value)
				attribute_set.SetAttributeBaseValue(attribute_name, new_value.value)
			Util.EDurationPolicy.DURATION or Util.EDurationPolicy.INFINITE:
				if attribute_set.HasAggregator(attribute_name):
					aggregator = attribute_set.GetAggregator(attribute_name)
				else:
					aggregator = attribute_set.CreateAggregator(attribute_name)
				
				var new_value: NewValue = NewValue.new(aggregator.Calculate())
				
				aggregator.AddModifier(active_effect_handle, modifier)
				
				attribute_set.PreAttributeChange(attribute_name, new_value)
				attribute_set.SetAttributeCurrentValue(attribute_name, new_value.value)
				
		affected_aggregators[attribute_picker.attribute] = aggregator
	
	return affected_aggregators

func RemoveModifiers() -> void:
	pass

func ApplyEffectSpecToTarget(effect_spec: EffectSpec, effect_target: AbilitySystemBase) -> ActiveEffectHandle:
	return effect_target.ApplyEffectSpecToSelf(effect_spec)

func RemoveActiveEffectByID(active_effect_id: int) -> void:
	if active_effects.has(active_effect_id):
		active_effects.erase(active_effect_id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
