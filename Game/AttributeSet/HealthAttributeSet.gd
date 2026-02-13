@tool
class_name HealthAttributeSet extends AttributeSet

func PreEffectExecute(data: AttributeModifierEvaluatedData) -> bool:
	print("PreEffectExecute")
	
	return true

func PostEffectExecute(data: AttributeModifierEvaluatedData) -> void:
	print("PostEffectExecute")

func PreAttributeBaseChange(attribute_name: String, new_value: NewValue) -> void:
	print("PreAttributeBaseChange -> " + attribute_name + ": " + str(new_value.value))

func PostAttributeBaseChange(attribute_name: String, old_value: float, new_value: float) -> void:
	print("PostAttributeBaseChange -> " + attribute_name + ": " + str(old_value) + " -> " + str(new_value))

func PreAttributeChange(attribute_name: String, new_value: NewValue) -> void:
	print("PreAttributeChange -> " + attribute_name + ": " + str(new_value.value))

func PostAttributeChange(attribute_name: String, old_value: float, new_value: float) -> void:
	print("PostAttributeChange -> " + attribute_name + ": " + str(old_value) + " -> " + str(new_value))
