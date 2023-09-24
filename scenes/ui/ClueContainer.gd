@tool
extends Control

signal updated()

@export var label: String = ""
@export var type: Clue.Type = Clue.Type.PEOPLE
@export var resetable: bool = false
var original_label: String = ""
var original_type: Clue.Type = Clue.Type.PEOPLE

@export var can_drag: bool = false
@export var can_drop: bool = false

@export var color_people: Color = Color.BLUE
@export var color_object: Color = Color.RED
@export var color_reason: Color = Color.GREEN
@export var color_place: Color = Color.YELLOW

func _ready():
  original_label = label
  original_type = type
  set_data(label, type)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
  return can_drop and data != null

func _get_drag_data(_at_position: Vector2) -> Variant:
  if can_drag:
    var ghost = self.duplicate()
    for child in ghost.get_children():
      child.position -= size / 2.0
    set_drag_preview(ghost)
    return self
  return null

func _drop_data(_at_position: Vector2, data: Variant):
  set_data(data.label, data.type)
  updated.emit()

func set_data(a_label: String, a_type: Clue.Type):
  label = a_label
  type = a_type
  $Label.text = a_label
  match a_type:
    Clue.Type.PEOPLE:
      $ColorRect.color = color_people
    Clue.Type.OBJECT:
      $ColorRect.color = color_object
    Clue.Type.REASON:
      $ColorRect.color = color_reason
    Clue.Type.PLACE:
      $ColorRect.color = color_place

func _on_gui_input(event):
  if resetable and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
    set_data(original_label, original_type)
    updated.emit()
