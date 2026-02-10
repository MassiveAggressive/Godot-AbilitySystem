@tool
class_name AbilitySystem extends Node

var owner_node: Node

@export var attribute_sets: Dictionary[String, AttributeSet]
var aggregators: Dictionary[String, Aggregator]

var active_effects: Dictionary[int, ActiveEffect]

func _ready() -> void:
	owner_node = get_parent()

func GetAttributeSet(_attribute_set_name: String) -> AttributeSet:
	var attribute_set_name: String = _attribute_set_name.get_slice(".", 0)
	
	if attribute_sets.has(attribute_set_name):
		return attribute_sets[attribute_set_name]
	return null

func FindOrCreateAttributeAggregator(attribute: String) -> Aggregator:
	if aggregators.has(attribute):
		return aggregators[attribute]
	
	var aggregator: Aggregator = GetAttributeSet(attribute).CreateAggregator(attribute.get_slice(".", 1))
	
	aggregators[attribute] = aggregator
	
	return aggregator

func CreateNewID() -> int:
	if active_effects.is_empty():
		return 0
	else:
		return active_effects.keys().max() + 1

func MakeEffectSpec(effect_data: Effect, effect_context: EffectContext) -> EffectSpec:
	var effect_spec: EffectSpec = EffectSpec.new(effect_data, effect_context)
	
	return effect_spec

func ApplyEffectSpecToTarget(effect_spec: EffectSpec, effect_target: AbilitySystem) -> ActiveEffectHandle:
	return effect_target.ApplyEffectSpecToSelf(effect_spec)

func ApplyEffectSpecToSelf(effect_spec: EffectSpec) -> ActiveEffectHandle:
	if effect_spec.duration == Util.EDurationPolicy.INSTANT:
		var calculated_modifiers: Array[EvaluatedAttributeData] = effect_spec.GetCalculatedModifiers()
		
		ApplyInstantModifiers(calculated_modifiers)
		
		return null
	else:
		var new_id: int = CreateNewID()
		var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
		var active_effect: ActiveEffect = ActiveEffect.new(effect_spec, active_effect_handle)
		
		active_effects[new_id] = active_effect
		active_effect.ApplyEffect()
		
		return active_effect_handle

func ApplyInstantModifiers(modifiers: Array[EvaluatedAttributeData]) -> void:
	for modifier in modifiers:
		var attribute_base_value: float = modifier.attribute.attribute_data.base_value
		
		attribute_base_value = ModifierCalculator.Calculate(attribute_base_value, [modifier.modifier])
		
		SetAttributeBaseValue(modifier.attribute, attribute_base_value)

func AddModifiersToAggregator(modifiers: Array[EvaluatedAttributeData], active_effect_handle: ActiveEffectHandle) -> void:
	for modifier in modifiers:
		var aggregator: Aggregator = modifier.attribute.attribute_set.GetAggregator(modifier.attribute.attribute_name)
		
		aggregator.AddModifier(active_effect_handle, modifier.modifier)
		
		SetAttributeValue(modifier.attribute, aggregator.Calculate())

func RemoveModifiersFromAggregator(affected_attributes: Array[Attribute], active_effect_handle: ActiveEffectHandle) -> void:
	for attribute in affected_attributes:
		var aggregator: Aggregator = attribute.attribute_set.GetAggregator(attribute.attribute_name)
		
		aggregator.RemoveModifier(active_effect_handle)
		
		SetAttributeValue(attribute, aggregator.Calculate())

func SetAttributeBaseValue(attribute: Attribute, value: float) -> void:
	var new_base_value: NewValue = NewValue.new(value)
	
	attribute.attribute_set.PreAttributeBaseChange(attribute.attribute_name, new_base_value)
	attribute.attribute_set.SetAttributeBaseValue(attribute.attribute_name, new_base_value.value)
	
	SetAttributeValue(attribute, attribute.attribute_set.GetAggregator(attribute.attribute_name).Calculate())

func SetAttributeValue(attribute: Attribute, value: float) -> void:
	var new_current_value: NewValue = NewValue.new(value)
	
	attribute.attribute_set.PreAttributeChange(attribute.attribute_name, new_current_value)
	attribute.attribute_set.SetAttributeValue(attribute.attribute_name, new_current_value.value)

func RemoveActiveEffectByID(id: int) -> void:
	if active_effects.has(id):
		active_effects[id].RemoveEffect()
		active_effects.erase(id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
