extends Node
class_name Clue

enum Type {PEOPLE, OBJECT, REASON, PLACE}

@export var label: String = ""
@export var type: Type = Type.PEOPLE
