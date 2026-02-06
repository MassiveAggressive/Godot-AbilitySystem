@tool
class_name AbilitySystem extends Node

var owner_node: Node

@export var attribute_sets: Dictionary[String, AttributeSet]:
	set(value):
		attribute_sets = value
		for attribute_set in attribute_sets.values():
			attribute_set = attribute_set as AttributeSet
			#attributeları toparlayıp attributes a ekle

@export var attributes: Dictionary

var active_effects: Dictionary[int, ActiveEffect]

func _ready() -> void:
	owner_node = get_parent()

func GetAttributeSet(attribute_set_name: String) -> AttributeSet:
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

func ApplyEffectSpec(effect_spec: EffectSpec) -> ActiveEffectHandle:
	var calculated_modifiers: Dictionary[String, Array] = effect_spec.CalculateModifiers()
	
	for attribute in calculated_modifiers:
		var aggregator: Aggregator = FindOrCreateAttributeAggregator(attribute)
		
		#aggregator'a modifierlar eklenecek
	return null

func ApplyModifierToAttribute(attribute: String, modifier: AggregatorModifier) -> void:
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
				
	#modifier ilgili attribute a uygulanacak

func SetAttributeBaseValue(attribute: String) -> void:
	pass

func ApplyEffectSpecToSelf(effect_spec: EffectSpec) -> ActiveEffectHandle:
	if effect_spec.duration == Util.EDurationPolicy.INSTANT:
		return null
	else:
		var new_id: int = CreateNewID()
		var active_effect_handle: ActiveEffectHandle = ActiveEffectHandle.new(self, new_id)
		var active_effect: ActiveEffect = ActiveEffect.new(effect_spec, active_effect_handle)
		
		active_effects[new_id] = active_effect
		active_effect.ApplyEffect()
		
		return active_effect_handle

func RemoveActiveEffectByID(id: int) -> void:
	if active_effects.has(id):
		active_effects[id].RemoveEffect()
		active_effects.erase(id)

func RemoveActiveEffectByHandle(active_effect_handle: ActiveEffectHandle) -> void:
	RemoveActiveEffectByID(active_effect_handle.id)
