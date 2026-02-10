class_name ModifierCalculator

static func Calculate(base_value: float, modifiers: Array) -> float:
	var add_total: float = 0.0
	var multiply_total: float = 1.0
	var divide_total: float = 1.0
	var multiply_compound_total: float = 1.0
	var add_final_total: float = 0.0
	
	var override: bool = false
	var overrider: float = 0.0
	
	var value_result: float = 0.0
	
	for modifier in modifiers:
		modifier = modifier as CalculatedAttributeModifier
		match modifier.operator:
			Util.EOperator.ADD:
				add_total += modifier.magnitude
			Util.EOperator.MULTIPLY:
				multiply_total += modifier.magnitude - 1
			Util.EOperator.DIVIDE:
				divide_total += modifier.magnitude - 1
			Util.EOperator.MULTIPLY_COMPOUND:
				multiply_compound_total *= modifier.magnitude
			Util.EOperator.ADD_FINAL:
				add_final_total += modifier.magnitude
			Util.EOperator.OVERRIDE:
				override = true
				overrider = modifier.magnitude
	
	if override:
		return overrider
	
	value_result = (base_value + add_total) * multiply_total / divide_total
	value_result *= multiply_compound_total
	value_result += add_final_total
	
	return value_result
