@tool
class_name Effect extends Resource

@export var duration_policy: Util.EDurationPolicy
@export var duration_magnitude: EffectModifierMagnitude
@export var period: float
@export var execute_period_on_application: bool = true
@export var modifiers: Array[EffectModifierData]
