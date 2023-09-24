extends Control

@export var label : RichTextLabel = null
@export var word_clue_in_label : String = ""

signal clue_discovered(clue_label: String, clue_type: Clue.Type)

var inside = load("res://assets/graphics/cursorGauntlet_bronze.png")
var outside = load("res://assets/graphics/cursorHand_grey.png")

func _on_gui_input(event):
  if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
    return
  if not word_clue_in_label.is_empty() and label != null:
    label.text = label.text.replace("[b][u][i]{0}[/i][/u][/b]".format([word_clue_in_label]), "[b]{0}[/b]".format([word_clue_in_label]))
  for node in get_children():
    if node is Clue:
      clue_discovered.emit(node.label, node.type)

func _on_mouse_entered():
  Input.set_custom_mouse_cursor(inside)

func _on_mouse_exited():
  Input.set_custom_mouse_cursor(outside)
