@tool
extends Node

enum EDurationPolicy
{
	INSTANT,
	DURATION,
	INFINITE
}

enum EOperator
{
	ADD,
	MULTIPLY,
	DIVIDE,
	MULTIPLY_COMPOUND,
	ADD_FINAL,
	OVERRIDE
}

enum EMagnitudeType
{
	SCALABLE_FLOAT,
	ATTRIBUTE_BASED
}

enum EAttributeSource
{
	SOURCE,
	TARGET
}
