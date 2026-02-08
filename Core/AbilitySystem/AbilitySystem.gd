@tool
class_name AbilitySystem extends Node

var owner_node: Node

@export var attribute_sets: Dictionary[String, AttributeSet]

var active_effects: Dictionary[int, ActiveEffect]

func _ready() -> void:
	owner_node = get_parent()

func GetAttributeSet(_attribute_set_name: String) -> AttributeSet:
	var attribute_set_name: String = _attribute_set_name.get_slice(".", 0)
	
	if attribute_sets.has(attribute_set_name):
		return attribute_sets[attribute_set_name]
	return null

func FindOrCreateAttributeAggregator(attribute: String) -> Aggregator:
	var attribute_set_name: String = attribute.get_slice(".", 0)
	var attribute_name: String = attribute.get_slice(".", 1)
	
	var attribute_set: AttributeSet = GetAttributeSet(attribute_set_name)
	
	if attribute_set.HasAggregator(attribute_name):
		return attribute_set.GetAggregator(attribute_name)
	else:
		return attribute_set.CreateAggregator(attribute_name)

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
		var calculated_modifiers: Dictionary[String, Array] = effect_spec.GetCalculatedModifiers()
		
		ApplyInstantModifiers(calculated_modifiers)
		
		return null
	else:
		var new_id: int = CreateNewID()
		var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
		var active_effect: ActiveEffect = ActiveEffect.new(effect_spec, active_effect_handle)
		
		active_effects[new_id] = active_effect
		active_effect.ApplyEffect()
		
		return active_effect_handle

func ApplyInstantModifiers(modifiers: Dictionary[String, Array]) -> void:
	for attribute in modifiers.keys():
		for modifier in modifiers[attribute]:
			modifier = modifier as AggregatorModifier
			
			var attribute_set_name: String = attribute.get_slice(".", 0)
			var attribute_name: String = attribute.get_slice(".", 1)
			var attribute_set: AttributeSet = attribute_sets[attribute_set_name]
			var attribute_base_value: float = attribute_set.GetAttributeBaseValue(attribute_name)
			
			match modifier.operator: 
					Util.EOperator.ADD:
						attribute_base_value += modifier.magnitude
					Util.EOperator.MULTIPLY:
						attribute_base_value *= modifier.magnitude
					Util.EOperator.DIVIDE:
						attribute_base_value /= modifier.magnitude
					Util.EOperator.MULTIPLY_COMPOUND:
						attribute_base_value *= modifier.magnitude
					Util.EOperator.ADD_FINAL:
						attribute_base_value += modifier.magnitude
					Util.EOperator.OVERRIDE:
						attribute_base_value = modifier.magnitude
			
			SetAttributeBaseValue(attribute, attribute_base_value)

func AddModifiersToAggregator(modifiers: Dictionary[String, Array], active_effect_handle: ActiveEffectHandle) -> void:
	for attribute in modifiers.keys():
		for modifier in modifiers[attribute]:
			modifier = modifier as AggregatorModifier
			
			var attribute_set_name: String = attribute.get_slice(".", 0)
			var attribute_name: String = attribute.get_slice(".", 1)
			var attribute_set: AttributeSet = attribute_sets[attribute_set_name]
			var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
			
			aggregator.AddModifier(active_effect_handle, modifier)
			
			SetAttributeValue(attribute, aggregator.Calculate())

func RemoveModifiersFromAggregator(affected_attributes: Array[String], active_effect_handle: ActiveEffectHandle) -> void:
	for attribute in affected_attributes:
		var attribute_set_name: String = attribute.get_slice(".", 0)
		var attribute_name: String = attribute.get_slice(".", 1)
		var attribute_set: AttributeSet = attribute_sets[attribute_set_name]
		var aggregator: Aggregator = attribute_set.GetAggregator(attribute_name)
		
		aggregator.RemoveModifier(active_effect_handle)
		
		SetAttributeValue(attribute, aggregator.Calculate())

func SetAttributeBaseValue(attribute: String, value: float) -> void:
	var attribute_set_name: String = attribute.get_slice(".", 0)
	var attribute_name: String = attribute.get_slice(".", 1)
	var attribute_set: AttributeSet = attribute_sets[attribute_set_name]
	
	var new_base_value: NewValue = NewValue.new(value)
	
	attribute_set.PreAttributeBaseChange(attribute_name, new_base_value)
	attribute_set.SetAttributeBaseValue(attribute_name, new_base_value.value)
	
	SetAttributeValue(attribute, attribute_set.GetAggregator(attribute_name).Calculate())

func SetAttributeValue(attribute: String, value: float) -> void:
	var attribute_set_name: String = attribute.get_slice(".", 0)
	var attribute_name: String = attribute.get_slice(".", 1)
	var attribute_set: AttributeSet = attribute_sets[attribute_set_name]
	
	var new_current_value: NewValue = NewValue.new(value)
	
	attribute_set.PreAttributeChange(attribute_name, new_current_value)
	attribute_set.SetAttributeValue(attribute_name, new_current_value.value)

func RemoveActiveEffectByID(id: int) -> void:
	if active_effects.has(id):
		active_effects[id].RemoveEffect()
		active_effects.erase(id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
